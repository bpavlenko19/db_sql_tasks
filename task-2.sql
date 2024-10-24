-- Частина 1: Запити на вибірку даних (SELECT)
-- 1.1. Отримання списку фільмів та їх категорій
SELECT f.title AS film_title, f.length AS duration, c.name AS category
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id;

-- 1.2. Фільми, орендовані певним клієнтом (заміни ім'я клієнта на реальне):
SELECT f.title AS film_title, r.rental_date AS rental_start  -- Замінив на rental_date
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE c.first_name = 'John' AND c.last_name = 'Doe';  -- Заміни на реальне ім'я клієнта

-- 1.3. Топ-5 найпопулярніших фільмів
SELECT f.title AS film_title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 5;

-- Частина 2: Маніпуляції з даними (INSERT, UPDATE, DELETE)

-- 2.1. Переконаємося, що країна "United States" існує
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM country WHERE country = 'United States') THEN
        INSERT INTO country (country) VALUES ('United States');
    END IF;
END $$;

-- 2.2. Переконаємося, що місто "San Francisco" існує
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM city WHERE city = 'San Francisco') THEN
        INSERT INTO city (city, country_id)
        VALUES (
            'San Francisco', 
            (SELECT country_id FROM country WHERE country = 'United States' LIMIT 1)
        );
    END IF;
END $$;

-- 2.3. Додавання адреси
INSERT INTO address (address, district, city_id, postal_code, phone)
VALUES (
    '123 Main St', 
    'Some District', 
    (SELECT city_id FROM city WHERE city = 'San Francisco' LIMIT 1), 
    '94101', 
    '123-456-7890'
);

-- 2.4. Додавання нового клієнта
INSERT INTO customer (store_id, first_name, last_name, email, address_id, create_date)
VALUES (
    1,  -- Заміни на реальний ID магазину
    'Alice', 
    'Cooper', 
    'alice.cooper@example.com', 
    (SELECT address_id FROM address WHERE address = '123 Main St' LIMIT 1), 
    NOW()
);

-- 2.5. Оновлення адреси клієнта (якщо це потрібно)
UPDATE address
SET address = '456 Elm St'
WHERE address = '123 Main St';

-- 2.6. Видалення клієнта (якщо це потрібно)
DELETE FROM customer
WHERE first_name = 'Alice' AND last_name = 'Cooper';
