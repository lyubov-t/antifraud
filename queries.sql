# 1. Поиск транзакций с аномально высокой суммой (превышающей средний чек в 3 раза)
SELECT transaction_id, amount, transaction_time
FROM transactions
WHERE amount > (SELECT AVG(amount) * 3 FROM transactions)
ORDER BY amount DESC;

# 2. Velocity Check: поиск всплесков активности (серия транзакций за короткий промежуток времени)
# Использование оконной функции для подсчета количества транзакций пользователя подряд
SELECT user_id, 
       transaction_time,
       COUNT(transaction_id) OVER (PARTITION BY user_id 
ORDER BY transaction_time ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS tx_count
FROM transactions;

# 3. Анализ ночной активности (с 2:00 до 5:00 утра)
SELECT EXTRACT(HOUR FROM transaction_time) AS hour_of_day,
       COUNT(*) AS total_transactions,
       SUM(amount) AS total_amount
FROM transactions
GROUP BY hour_of_day
ORDER BY hour_of_day;
