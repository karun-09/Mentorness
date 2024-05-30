--What is the total number of reservations in the dataset?
SELECT COUNT(*) AS total_reservations FROM htable;


--Which meal plan is the most popular among guests? 
SELECT type_of_meal_plan, total_guests
FROM (
    SELECT type_of_meal_plan, COUNT(*) AS total_guests
    FROM htable 
    GROUP BY type_of_meal_plan 
    ORDER BY COUNT(*) DESC
) 
WHERE ROWNUM = 1;

--What is the average price per room for reservations involving children? 
SELECT round(AVG(avg_price_per_room),2) AS average_price_per_room
FROM htable
WHERE no_of_children > 0;

--How many reservations were made for the year 20XX (replace XX with the desired year)? 
SELECT COUNT(*) AS total_reservations
FROM htable
WHERE EXTRACT(YEAR FROM arrival_date) = '2017';

--What is the most commonly booked room type? 
SELECT room_type_reserved, total_bookings
FROM (
    SELECT room_type_reserved, COUNT(*) AS total_bookings
    FROM htable
    GROUP BY room_type_reserved
    ORDER BY COUNT(*) DESC
)
WHERE ROWNUM = 1;

--How many reservations fall on a weekend (no_of_weekend_nights > 0)?
SELECT COUNT(*) AS weekend_reservations
FROM htable
WHERE no_of_weekend_nights > 0;

--What is the highest and lowest lead time for reservations?
SELECT MAX(lead_time) AS highest_lead_time, MIN(lead_time) AS lowest_lead_time
FROM htable;


--What is the most common market segment type for reservations? 
SELECT market_segment_type, segment_count
FROM (
    SELECT market_segment_type, COUNT(*) AS segment_count
    FROM htable
    GROUP BY market_segment_type
    ORDER BY COUNT(*) DESC
)
WHERE ROWNUM = 1;

--How many reservations have a booking status of "Confirmed"?
SELECT COUNT(*) AS confirmed_reservations
FROM htable
WHERE booking_status = 'Not_Canceled';

--What is the total number of adults and children across all reservations?
SELECT 
    SUM(no_of_adults) AS total_adults,
    SUM(no_of_children) AS total_children
FROM htable;

--What is the average number of weekend nights for reservations involving children?
SELECT AVG(no_of_weekend_nights) AS average_weekend_nights
FROM htable
WHERE no_of_children > 0;

--How many reservations were made in each month of the year?
SELECT 
    EXTRACT(MONTH FROM arrival_date) AS month,
    COUNT(*) AS reservations_count
FROM htable
GROUP BY EXTRACT(MONTH FROM arrival_date)
ORDER BY month;

--What is the average number of nights (both weekend and weekday) spent by guests for each room type?
SELECT 
    room_type_reserved,
    round(AVG(no_of_weekend_nights + no_of_week_nights),2) AS avg_nights
FROM htable
GROUP BY room_type_reserved;

--For reservations involving children, what is the most common room type, and what is the average price for that room type? 
SELECT room_type_reserved, average_price
FROM (
    SELECT 
        room_type_reserved,
        AVG(avg_price_per_room) AS average_price,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rn
    FROM htable
    WHERE no_of_children > 0
    GROUP BY room_type_reserved
    ORDER BY COUNT(*) DESC
)
WHERE rn = 1;

--Find the market segment type that generates the highest average price per room. 
SELECT market_segment_type, average_price_per_room
FROM (
    SELECT 
        market_segment_type,
        round(AVG(avg_price_per_room),2) AS average_price_per_room,
        ROW_NUMBER() OVER (ORDER BY AVG(avg_price_per_room) DESC) AS rn
    FROM htable
    GROUP BY market_segment_type
    ORDER BY AVG(avg_price_per_room) DESC
)
WHERE rn = 1;