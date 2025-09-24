# 💳 Credit Card Fraud Detection (SQL Project)

## 📌 Overview
This project focuses on **credit card fraud detection** using SQL.  
It simulates a real-world financial database with **cardholders, credit cards, merchants, merchant categories, and transactions**, and then applies analytical queries to uncover suspicious activity.  

The database was designed, seeded with data, and extended with **fraud detection queries** to highlight anomalies such as unusually large transactions, rapid multiple purchases, and outlier spending behavior.

---

## 🗄️ Database Schema
The project consists of 5 main tables:

- **card_holder** → Stores cardholder information.  
- **credit_card** → Stores credit card numbers linked to cardholders.  
- **merchant_category** → Categories such as restaurant, coffee shop, bar, pub, food truck.  
- **merchant** → Stores merchant details, linked to categories.  
- **transaction** → Records transactions with amount, timestamp, card, and merchant.  

*(You can add a schema diagram image here if available.)*

---

## 📂 Files
- `schema.sql` → Defines the database schema and relationships.  
- `seed.sql` → Populates the database with sample data.  
- `fraud_queries.sql` → Contains queries for detecting fraudulent transactions.  

---

## 🔍 Fraud Detection Queries

Some examples of suspicious patterns detected:

1. **High-value transactions** (> 1000).  
2. **Multiple transactions in short time frames**.  
3. **Transactions across very different merchant categories within 1 hour**.  
4. **Same card used at multiple merchants in <10 minutes**.  
5. **Sudden spikes compared to average spend**.  
6. **Dormant cards suddenly active**.  
7. **Heavy concentration of spending at one merchant**.  
8. **Odd-hour transactions (midnight–5 AM)**.  
9. **Merchant testing: multiple cardholders used at the same shop quickly**.  
10. **Potential cloned card: same card linked to multiple cardholders**.  

---

## 📊 Future Enhancements

- Build a **dashboard** for real-time fraud monitoring (Streamlit or Power BI).  
- Add **machine learning anomaly detection** on top of SQL rules.  
- Extend dataset with **geolocation** to track cross-country fraud.  

---

