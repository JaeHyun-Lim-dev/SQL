-- https://programmers.co.kr/learn/courses/30/lessons/59041
SELECT * FROM (
    SELECT NAME, COUNT(*) AS count FROM ANIMAL_INS
        WHERE NAME IS NOT NULL
        GROUP BY NAME ORDER BY NAME)
    WHERE count >= 2;
