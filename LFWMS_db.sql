CREATE TABLE providers (
    Provider_ID INT PRIMARY KEY,
    Name VARCHAR(150),
    Type VARCHAR(50),
    Address VARCHAR(255),
    City VARCHAR(100),
    Contact VARCHAR(50)
);

CREATE TABLE receivers (
    Receiver_ID INT PRIMARY KEY,
    Name VARCHAR(150),
    Type VARCHAR(50),
    City VARCHAR(100),
    Contact VARCHAR(50)
);

CREATE TABLE food_listings (
    Food_ID INT PRIMARY KEY,
    Food_Name VARCHAR(100),
    Quantity INT,
    Expiry_Date DATE,
    Provider_ID INT,
    Provider_Type VARCHAR(50),
    Location VARCHAR(100),
    Food_Type VARCHAR(50),
    Meal_Type VARCHAR(50),
    FOREIGN KEY (Provider_ID) REFERENCES providers(Provider_ID)
);

CREATE TABLE claims (
    Claim_ID INT PRIMARY KEY,
    Food_ID INT,
    Receiver_ID INT,
    Status VARCHAR(20),
    claim_timestamp TIMESTAMP,
    FOREIGN KEY (Food_ID) REFERENCES food_listings(Food_ID),
    FOREIGN KEY (Receiver_ID) REFERENCES receivers(Receiver_ID)
);


CREATE TABLE food_listings_staging (
    Food_ID INT,
    Food_Name VARCHAR(100),
    Quantity INT,
    Expiry_Date TEXT,
    Provider_ID INT,
    Provider_Type VARCHAR(50),
    Location VARCHAR(100),
    Food_Type VARCHAR(50),
    Meal_Type VARCHAR(50)
);

CREATE TABLE claims_staging (
    Claim_ID INT,
    Food_ID INT,
    Receiver_ID INT,
    Status VARCHAR(20),
    Timestamp TEXT
);



INSERT INTO food_listings
SELECT Food_ID, Food_Name, Quantity, TO_DATE(Expiry_Date,'MM/DD/YYYY'),
       Provider_ID, Provider_Type, Location, Food_Type, Meal_Type
FROM food_listings_staging;

INSERT INTO claims
SELECT Claim_ID, Food_ID, Receiver_ID, Status,
       TO_TIMESTAMP(Timestamp, 'MM/DD/YYYY HH24:MI')
FROM claims_staging;



DROP TABLE food_listings_staging;
DROP TABLE claims_staging;

SELECT COUNT(*) FROM food_listings;
SELECT COUNT(*) FROM claims;

SELECT * FROM claims LIMIT 5;




Q1. How many food providers and receivers are there in each city?
SELECT
    city,
    'Provider' AS role,
    COUNT(*)   AS total
FROM providers
GROUP BY city
UNION ALL
SELECT
    city,
    'Receiver' AS role,
    COUNT(*)   AS total
FROM receivers
GROUP BY city
ORDER BY city, role;




Q2. Which type of food provider (restaurant, grocery store, etc.)
--     contributes the most food?
SELECT
    p.type                   AS provider_type,
    SUM(fl.quantity)         AS total_quantity
FROM food_listings fl
JOIN providers p ON fl.provider_id = p.provider_id
GROUP BY p.type
ORDER BY total_quantity DESC;




Q3. What is the contact information of food providers in a specific city?
--     (Replace 'New Jessica' with any city name you want)
SELECT
    name,
    type,
    address,
    city,
    contact
FROM providers
WHERE LOWER(city) = LOWER('New Jessica')
ORDER BY name;




Q4. Which receivers have claimed the most food?
SELECT
    r.receiver_id,
    r.name                   AS receiver_name,
    r.type                   AS receiver_type,
    COUNT(c.claim_id)        AS total_claims
FROM claims c
JOIN receivers r ON c.receiver_id = r.receiver_id
GROUP BY r.receiver_id, r.name, r.type
ORDER BY total_claims DESC
LIMIT 10;





Q5. What is the total quantity of food available from all providers?
SELECT
    SUM(quantity) AS total_food_available
FROM food_listings;




Q6. Which city has the highest number of food listings?
SELECT
    location          AS city,
    COUNT(food_id)    AS total_listings,
    SUM(quantity)     AS total_quantity
FROM food_listings
GROUP BY location
ORDER BY total_listings DESC
LIMIT 10;




Q7. What are the most commonly available food types?
SELECT
    food_type,
    COUNT(food_id)  AS listing_count,
    SUM(quantity)   AS total_quantity
FROM food_listings
GROUP BY food_type
ORDER BY listing_count DESC;




Q8. How many food claims have been made for each food item?
SELECT
    fl.food_id,
    fl.food_name,
    fl.food_type,
    COUNT(c.claim_id)  AS total_claims
FROM food_listings fl
LEFT JOIN claims c ON fl.food_id = c.food_id
GROUP BY fl.food_id, fl.food_name, fl.food_type
ORDER BY total_claims DESC;




Q9. Which provider has had the highest number of successful food claims?
SELECT
    p.provider_id,
    p.name                  AS provider_name,
    p.type                  AS provider_type,
    COUNT(c.claim_id)       AS completed_claims
FROM claims c
JOIN food_listings fl ON c.food_id = fl.food_id
JOIN providers p      ON fl.provider_id = p.provider_id
WHERE LOWER(c.status) = 'completed'
GROUP BY p.provider_id, p.name, p.type
ORDER BY completed_claims DESC
LIMIT 10;




Q10. What percentage of food claims are completed vs. pending vs. cancelled?
SELECT
    status,
    COUNT(*)                                          AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM claims
GROUP BY status
ORDER BY total DESC;




Q11. What is the average quantity of food claimed per receiver?
SELECT
    r.receiver_id,
    r.name                       AS receiver_name,
    COUNT(c.claim_id)            AS total_claims,
    ROUND(AVG(fl.quantity), 2)   AS avg_quantity_per_claim
FROM claims c
JOIN receivers r    ON c.receiver_id = r.receiver_id
JOIN food_listings fl ON c.food_id = fl.food_id
GROUP BY r.receiver_id, r.name
ORDER BY avg_quantity_per_claim DESC
LIMIT 10;



Q12. Which meal type (breakfast, lunch, dinner, snacks) is claimed the most?
SELECT
    fl.meal_type,
    COUNT(c.claim_id)   AS total_claims
FROM claims c
JOIN food_listings fl ON c.food_id = fl.food_id
GROUP BY fl.meal_type
ORDER BY total_claims DESC;



Q13. What is the total quantity of food donated by each provider?
SELECT
    p.provider_id,
    p.name                  AS provider_name,
    p.type                  AS provider_type,
    p.city,
    SUM(fl.quantity)        AS total_quantity_donated,
    COUNT(fl.food_id)       AS total_listings
FROM providers p
JOIN food_listings fl ON p.provider_id = fl.provider_id
GROUP BY p.provider_id, p.name, p.type, p.city
ORDER BY total_quantity_donated DESC;



Q14. Food wastage trend — listings with no claims (potential waste)
SELECT
    fl.food_id,
    fl.food_name,
    fl.quantity,
    fl.expiry_date,
    fl.location,
    p.name          AS provider_name
FROM food_listings fl
JOIN providers p ON fl.provider_id = p.provider_id
LEFT JOIN claims c ON fl.food_id = c.food_id
WHERE c.claim_id IS NULL
ORDER BY fl.expiry_date ASC;




Q15. Highest demand locations based on food claims
SELECT
    fl.location             AS city,
    COUNT(c.claim_id)       AS total_claims,
    SUM(fl.quantity)        AS total_food_claimed
FROM claims c
JOIN food_listings fl ON c.food_id = fl.food_id
WHERE LOWER(c.status) = 'completed'
GROUP BY fl.location
ORDER BY total_claims DESC
LIMIT 10;
