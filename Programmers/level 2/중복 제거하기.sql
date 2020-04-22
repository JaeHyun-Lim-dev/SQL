-- https://programmers.co.kr/learn/courses/30/lessons/59408
SELECT COUNT(*) FROM (
    SELECT DISTINCT NAME FROM ANIMAL_INS a
        WHERE a.NAME IS NOT NULL
);
