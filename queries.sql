
--High-value transactions (potential fraud spikes)
SELECT t.id, ch.name, t.amount, t.date, m.name AS merchant
FROM transaction t
JOIN credit_card cc ON t.card = cc.card
JOIN card_holder ch ON cc.id_card_holder = ch.id
JOIN merchant m ON t.id_merchant = m.id
WHERE t.amount > 1000
ORDER BY t.amount DESC;


--Multiple transactions in a short window
SELECT ch.name, cc.card, COUNT(t.id) AS txn_count, MIN(t.date) AS first_txn, MAX(t.date) AS last_txn
FROM transaction t
JOIN credit_card cc ON t.card = cc.card
JOIN card_holder ch ON cc.id_card_holder = ch.id
WHERE t.date::date = '2018-01-04'
GROUP BY ch.name, cc.card
HAVING COUNT(t.id) > 5;

--Transactions across distant merchant categories in short time
SELECT t1.card, ch.name, t1.date AS txn_time, mc1.name AS category1, mc2.name AS category2
FROM transaction t1
JOIN transaction t2 ON t1.card = t2.card AND ABS(EXTRACT(EPOCH FROM (t1.date - t2.date))) < 3600
JOIN credit_card cc ON t1.card = cc.card
JOIN card_holder ch ON cc.id_card_holder = ch.id
JOIN merchant m1 ON t1.id_merchant = m1.id
JOIN merchant m2 ON t2.id_merchant = m2.id
JOIN merchant_category mc1 ON m1.id_merchant_category = mc1.id
JOIN merchant_category mc2 ON m2.id_merchant_category = mc2.id
WHERE mc1.id <> mc2.id;

--Transactions at multiple merchants within 10 minutes
SELECT t1.card, ch.name, COUNT(DISTINCT t2.id_merchant) AS different_merchants, t1.date
FROM transaction t1
JOIN transaction t2 ON t1.card = t2.card AND ABS(EXTRACT(EPOCH FROM (t1.date - t2.date))) < 600
JOIN credit_card cc ON t1.card = cc.card
JOIN card_holder ch ON cc.id_card_holder = ch.id
GROUP BY t1.card, ch.name, t1.date
HAVING COUNT(DISTINCT t2.id_merchant) > 3;


--Average spend vs sudden spike
SELECT ch.name, cc.card, ROUND(AVG(t.amount),2) AS avg_spend, MAX(t.amount) AS max_spend
FROM transaction t
JOIN credit_card cc ON t.card = cc.card
JOIN card_holder ch ON cc.id_card_holder = ch.id
GROUP BY ch.name, cc.card
HAVING MAX(t.amount) > 5 * AVG(t.amount);


--Dormant card suddenly active
SELECT ch.name, cc.card, MIN(t.date) AS first_txn, MAX(t.date) AS last_txn, COUNT(t.id) AS txn_count
FROM transaction t
JOIN credit_card cc ON t.card = cc.card
JOIN card_holder ch ON cc.id_card_holder = ch.id
GROUP BY ch.name, cc.card
HAVING COUNT(t.id) < 3 AND MAX(t.date) - MIN(t.date) < INTERVAL '1 day';


--Merchant outliers (single cardholder spending unusually at one merchant)
SELECT ch.name, m.name AS merchant, COUNT(t.id) AS txn_count, SUM(t.amount) AS total_spent
FROM transaction t
JOIN credit_card cc ON t.card = cc.card
JOIN card_holder ch ON cc.id_card_holder = ch.id
JOIN merchant m ON t.id_merchant = m.id
GROUP BY ch.name, m.name
HAVING SUM(t.amount) > 500 AND COUNT(t.id) > 10;


--Transactions at unusual times (e.g., midnight–5 AM)
SELECT ch.name, t.id, t.date, t.amount, m.name AS merchant
FROM transaction t
JOIN credit_card cc ON t.card = cc.card
JOIN card_holder ch ON cc.id_card_holder = ch.id
JOIN merchant m ON t.id_merchant = m.id
WHERE EXTRACT(HOUR FROM t.date) BETWEEN 0 AND 5;


--Multiple cardholders sharing the same merchant in <1 hour
SELECT m.name AS merchant, COUNT(DISTINCT ch.id) AS unique_cardholders, MIN(t.date) AS first_txn, MAX(t.date) AS last_txn
FROM transaction t
JOIN credit_card cc ON t.card = cc.card
JOIN card_holder ch ON cc.id_card_holder = ch.id
JOIN merchant m ON t.id_merchant = m.id
GROUP BY m.name
HAVING COUNT(DISTINCT ch.id) > 5 AND MAX(t.date) - MIN(t.date) < INTERVAL '1 hour';


--Cross-check: card used by two cardholders (data breach / cloning)
SELECT t.card, COUNT(DISTINCT ch.id) AS cardholders
FROM transaction t
JOIN credit_card cc ON t.card = cc.card
JOIN card_holder ch ON cc.id_card_holder = ch.id
GROUP BY t.card
HAVING COUNT(DISTINCT ch.id) > 1;
