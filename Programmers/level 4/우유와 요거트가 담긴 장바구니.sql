-- https://programmers.co.kr/learn/courses/30/lessons/62284
SELECT DISTINCT a.CART_ID FROM CART_PRODUCTS a, CART_PRODUCTS b
    WHERE (a.NAME = '요거트'
        AND b.NAME = '우유'
        AND a.CART_ID = b.CART_ID) ORDER BY CART_ID;