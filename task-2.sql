-- 1. Переконаємося, що країна "United States" існує
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM country WHERE country = 'United States') THEN
        INSERT INTO country (country) VALUES ('United States');
    END IF;
END $$;

-- 2. Переконаємося, що місто "San Francisco" існує
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

-- 3. Додавання адреси
INSERT INTO address (address, district, city_id, postal_code, phone)
VALUES (
    '123 Main St', 
    'Some District', 
    (SELECT city_id FROM city WHERE city = 'San Francisco' LIMIT 1), 
    '94101', 
    '123-456-7890'
);

-- 4. Додавання нового клієнта
INSERT INTO customer (store_id, first_name, last_name, email, address_id, create_date)
VALUES (
    1,  -- Заміни на реальний ID магазину
    'Alice', 
    'Cooper', 
    'alice.cooper@example.com', 
    (SELECT address_id FROM address WHERE address = '123 Main St' LIMIT 1), 
    NOW()
);

-- 5. Оновлення адреси клієнта (якщо це потрібно)
UPDATE address
SET address = '456 Elm St'
WHERE address = '123 Main St';

-- 6. Видалення клієнта (якщо це потрібно)
DELETE FROM customer
WHERE first_name = 'Alice' AND last_name = 'Cooper';
