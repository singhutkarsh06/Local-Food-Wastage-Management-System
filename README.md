# 🍱 Local Food Waste Management System

A data-driven web application that connects food providers with receivers 
to reduce food waste using SQL analytics and an interactive dashboard.

---

## 📌 Project Overview
- **Database:** PostgreSQL with 4 tables and 4,000 records
- **Dashboard:** Built with Streamlit — fully interactive
- **Analysis:** 15 SQL queries covering providers, claims, and food trends

---

## 📂 Dataset Tables
| Table | Records | Description |
|-------|---------|-------------|
| Providers | 1,000 | Restaurants, grocery stores, supermarkets |
| Receivers | 1,000 | Individuals, shelters, NGOs |
| Food Listings | 1,000 | Food items with quantity, expiry, location |
| Claims | 1,000 | Links food listings to receivers with status |

---

## 🚀 Features
- 📊 **Live Dashboard** — charts, metrics, and filters update in real time
- 🔍 **Sidebar Filters** — filter by city, provider, food type, claim status
- 📋 **15 SQL Queries** — all visible with live output inside the app
- ✏️ **CRUD Operations** — insert, update, delete records directly
- 📞 **Contact Directory** — searchable provider and receiver contacts
- ⬇️ **CSV Export** — download filtered data from any table

---

## 🛠️ Tech Stack
- **Database:** PostgreSQL
- **Backend:** Python, psycopg2
- **Dashboard:** Streamlit
- **Charts:** Plotly
- **Data:** Pandas

---

## ▶️ How to Run Locally
1. Clone the repo
2. Install dependencies
3. Update DB credentials in `LFWMS.py`
4. Run the app

---

## 📊 Key Insights
- **35%** of food listings received zero claims (potential waste)
- **Grocery Stores** contribute the highest food quantity
- **Dinner & Lunch** are the most claimed meal types
- Real-time city-wise demand tracking through dashboard filters

---

## 🌐 Live App
local-food-wastage-management-system-mzwvckouhampb3vf3hrxma.streamlit.app

---
Made with ❤️ for reducing food waste
