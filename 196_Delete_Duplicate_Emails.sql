# Write your MySQL query statement below

DELETE FROM person
WHERE id IN (
    SELECT id
    FROM (
        SELECT id,
               ROW_NUMBER() OVER(
                   PARTITION BY email
                   ORDER BY id
               ) AS rn
        FROM person
    ) x
    WHERE rn > 1
);
