-- https://programmers.co.kr/learn/courses/30/lessons/59038
SELECT * FROM (SELECT DATETIME FROM ANIMAL_INS ORDER BY DATETIME ASC) a
    WHERE ROWNUM = 1;
