-- TBL_LT_INF의 PK (FA_ID, LT_ID, PROD_ID)
/*
-- UNION (NOT EXISTS) (76000개 행 출력)
SELECT COUNT(*) FROM (
SELECT * FROM TEST01.TBL_LT_INF a
    UNION ALL
SELECT * FROM TEST02.TBL_LT_INF b
    WHERE NOT EXISTS (SELECT a.* FROM TEST01.TBL_LT_INF a
    WHERE a.FA_ID = b.FA_ID
    AND a.LT_ID = b.LT_ID
    AND a.PROD_ID = b.PROD_ID));

-- PK중복이 없는 TEST01의 데이터 확인 (중복 1000개 제외하고 37000개 행 출력)
SELECT a.*
    FROM TEST01.TBL_LT_INF a
    WHERE NOT EXISTS (SELECT b.* FROM TEST02.TBL_LT_INF b
        WHERE a.FA_ID = b.FA_ID
        AND a.LT_ID = b.LT_ID
        AND a.PROD_ID = b.PROD_ID)
;
-- PK중복이 없는 TEST02의 데이터 확인 (중복 1000개 제외하고 38000개 행 출력)
SELECT COUNT(*) FROM (
SELECT b.*
    FROM TEST02.TBL_LT_INF b
    WHERE NOT EXISTS (SELECT a.* FROM TEST01.TBL_LT_INF a
        WHERE a.FA_ID = b.FA_ID
        AND a.LT_ID = b.LT_ID
        AND a.PROD_ID = b.PROD_ID))
;
*/

-- PK중복이 없는 TEST01의 컬럼과 PK중복이 없는 TEST02의 컬럼은 F12인 경우 F11로 변환해서,
-- PK중복인 컬럼은 TEST01의 데이터로 TEST03에 INSERT
-- 76000개 데이터 INSERT

INSERT INTO TEST03.TBL_LT_INF c
SELECT CASE FA_ID
        WHEN 'F12' THEN 'F11' ELSE a.FA_ID END,
        LT_ID, PROD_ID, FL_ID, OP_ID, TIMEKEY, CHG_TM, CRT_TM
        FROM TEST01.TBL_LT_INF a
        WHERE NOT EXISTS (SELECT b.* FROM TEST02.TBL_LT_INF b
        WHERE a.FA_ID = b.FA_ID
        AND a.LT_ID = b.LT_ID
        AND a.PROD_ID = b.PROD_ID)

    UNION ALL
SELECT CASE FA_ID
        WHEN 'F12' THEN 'F11' ELSE b.FA_ID END, 
        LT_ID, PROD_ID, FL_ID, OP_ID, TIMEKEY, CHG_TM, CRT_TM
        FROM TEST02.TBL_LT_INF b
        WHERE NOT EXISTS (SELECT a.* FROM TEST01.TBL_LT_INF a
        WHERE a.FA_ID = b.FA_ID
        AND a.LT_ID = b.LT_ID
        AND a.PROD_ID = b.PROD_ID)

    UNION ALL
SELECT a.* FROM TEST01.TBL_LT_INF a, TEST02.TBL_LT_INF b
        WHERE a.FA_ID = b.FA_ID
        AND a.LT_ID = b.LT_ID
        AND a.PROD_ID = b.PROD_ID
;

/*
-- PK 중복 없이 FA_ID = 'F12'인 경우
-- TEST01에 대해 2만 건, TEST02에 대해 2만 건, 총 2만개의 행이 변환 대상임을 교차확인
SELECT COUNT(*) 
  FROM TEST02.TBL_LT_INF b
  WHERE b.FA_ID = 'F12'
  AND NOT EXISTS (SELECT a.* FROM TEST01.TBL_LT_INF a
  WHERE a.FA_ID = b.FA_ID
  AND a.LT_ID = b.LT_ID
  AND a.PROD_ID = b.PROD_ID)
  ; 
*/