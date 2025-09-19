USE airbnb;
-- Average price per room type and city --
SELECT city, room_type, ROUND(AVG(price),2) AS avg_price
FROM airbnb_listings
GROUP BY city, room_type;
-- Total listings per room type and city --
SELECT city, room_type, COUNT(*) AS total_listings
FROM airbnb_listings
GROUP BY city, room_type;
-- The most expensive listing --
SELECT city, name, room_type, price
FROM airbnb_listings
WHERE price = (SELECT MAX(price) FROM airbnb_listings WHERE city = airbnb_listings.city);
-- Top 5 listings with more reviews per city --
WITH city_avg AS (
    SELECT city, AVG(price) AS avg_price
    FROM airbnb_listings
    GROUP BY city
),
ranked AS (
    SELECT 
        l.name,
        l.city,
        l.room_type,
        l.price,
        l.number_of_reviews,
        ROW_NUMBER() OVER (PARTITION BY l.city ORDER BY l.number_of_reviews DESC) AS rn
    FROM airbnb_listings l
    JOIN city_avg a ON l.city = a.city
    WHERE l.price < a.avg_price
)
SELECT name, city, room_type, price, number_of_reviews
FROM ranked
WHERE rn <= 5
ORDER BY city, number_of_reviews DESC;
-- Avg price per room type and distance group --
WITH city_centers AS (
    SELECT 'Milan' AS city, 45.4642 AS lat, 9.1900 AS lon
    UNION ALL
    SELECT 'Porto', 41.1579, -8.6291
    UNION ALL
    SELECT 'Amsterdam', 52.3676, 4.9041
),
listings_with_distance AS (
    SELECT 
        l.city,
        l.room_type,
        l.price,
        6371 * acos(
            cos(radians(c.lat)) * cos(radians(l.latitude)) *
            cos(radians(l.longitude) - radians(c.lon)) +
            sin(radians(c.lat)) * sin(radians(l.latitude))
        ) AS distance_from_center_km
    FROM airbnb_listings l
    JOIN city_centers c
        ON l.city = c.city
),
listings_with_groups AS (
    SELECT
        city,
        room_type,
        price,
        CASE 
            WHEN distance_from_center_km < 2 THEN '0-2 km'
            WHEN distance_from_center_km BETWEEN 2 AND 5 THEN '2-5 km'
            ELSE '5+ km'
        END AS distance_group
    FROM listings_with_distance
)
SELECT
    city,
    distance_group,
    room_type,
    ROUND(AVG(price), 2) AS avg_price
FROM listings_with_groups
GROUP BY city, distance_group, room_type
ORDER BY city, room_type, distance_group;
-- Top 5 listings per city and highest number of reviews price < 100--
WITH ranked_listings AS (
    SELECT
		name,
        city,
        price,
        number_of_reviews,
        ROW_NUMBER() OVER (PARTITION BY city ORDER BY number_of_reviews DESC) AS rn
    FROM airbnb_listings
    WHERE price <= 100
)
SELECT
	name,
    city,
    price,
    number_of_reviews
FROM ranked_listings
WHERE rn <= 5
ORDER BY city, number_of_reviews DESC;
-- Top 5 cheapest listings per city --
WITH city_centers AS (
    SELECT 'Milan' AS city, 45.4642 AS lat, 9.1900 AS lon
    UNION ALL SELECT 'Porto', 41.1579, -8.6291
    UNION ALL SELECT 'Amsterdam', 52.3676, 4.9041
),
listings_with_distance AS (
    SELECT
		l.name,
        l.city,
        l.room_type,
        l.price,
        l.number_of_reviews,
        6371 * acos(
            cos(radians(c.lat)) * cos(radians(l.latitude)) *
            cos(radians(l.longitude) - radians(c.lon)) +
            sin(radians(c.lat)) * sin(radians(l.latitude))
        ) AS distance_km
    FROM airbnb_listings l
    JOIN city_centers c ON l.city = c.city
),
ranked_cheapest AS (
    SELECT
		name,
        city,
        room_type,
        price,
        number_of_reviews,
        ROUND(distance_km, 2) AS distance_km,
        ROW_NUMBER() OVER (PARTITION BY city ORDER BY price ASC) AS rn
    FROM listings_with_distance
)
SELECT *
FROM ranked_cheapest
WHERE rn <= 5
ORDER BY city, price ASC;
-- Top 5 most expensive listings per city --
WITH city_centers AS (
    SELECT 'Milan' AS city, 45.4642 AS lat, 9.1900 AS lon
    UNION ALL SELECT 'Porto', 41.1579, -8.6291
    UNION ALL SELECT 'Amsterdam', 52.3676, 4.9041
),
listings_with_distance AS (
    SELECT
		l.name,
        l.city,
        l.room_type,
        l.price,
        l.number_of_reviews,
        6371 * acos(
            cos(radians(c.lat)) * cos(radians(l.latitude)) *
            cos(radians(l.longitude) - radians(c.lon)) +
            sin(radians(c.lat)) * sin(radians(l.latitude))
        ) AS distance_km
    FROM airbnb_listings l
    JOIN city_centers c ON l.city = c.city
),
ranked_expensive AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY city ORDER BY price DESC) AS rn
    FROM listings_with_distance
)
SELECT
	name,
    city,
    room_type,
    price,
    number_of_reviews,
    ROUND(distance_km, 2) AS distance_km
FROM ranked_expensive
WHERE rn <= 5
ORDER BY city, price DESC;
-- Price Statistics per City --
SELECT 
    city,
    ROUND(MIN(price),2) AS min_price,
    ROUND(MAX(price),2) AS max_price,
    ROUND(AVG(price),2) AS avg_price,
    ROUND(STD(price),2) AS price_std
FROM airbnb_listings
GROUP BY city
ORDER BY avg_price DESC;
-- Minimum nights analysis --
SELECT 
    city,
    room_type,
    ROUND(AVG(minimum_nights),2) AS avg_min_nights,
    COUNT(*) AS total_listings
FROM airbnb_listings
GROUP BY city, room_type
ORDER BY city, avg_min_nights DESC;
-- Summary table for KPIs --
SELECT 
    city,
    COUNT(*) AS total_listings,
    ROUND(AVG(price),2) AS avg_price,
    ROUND(AVG(number_of_reviews),2) AS avg_reviews,
    COUNT(CASE WHEN room_type='Entire home/apt' THEN 1 END) AS entire_home_count,
    ROUND(100 * COUNT(CASE WHEN room_type='Entire home/apt' THEN 1 END)/COUNT(*),2) AS pct_entire_home
FROM airbnb_listings
GROUP BY city;
-- Top hosts per city --
SELECT
    city,
    COUNT(*) AS total_hosts,
    SUM(CASE WHEN top_host = 1 THEN 1 ELSE 0 END) AS tophost_count,
    ROUND(AVG(top_host) * 100, 2) AS percent_tophost
FROM airbnb_listings
GROUP BY city
ORDER BY percent_tophost DESC;


