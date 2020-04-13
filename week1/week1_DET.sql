-- TBL_LT_DET의 PK (FA_ID, LT_ID, PROD_ID)
/*
-- UNION (NOT EXISTS)
-- TEST02의 모든 데이터(1000개)가 TEST01(총 38000개)의 특정 행과 PK가 일치함을 확인 가능 (UNION 후 총 38000개)
SELECT * FROM TEST01.TBL_LT_DET a
    UNION ALL
SELECT * FROM TEST02.TBL_LT_DET b
    WHERE NOT EXISTS (SELECT a.* FROM TEST01.TBL_LT_DET a
    WHERE a.FA_ID = b.FA_ID
    AND a.LT_ID = b.LT_ID
    AND a.PROD_ID = b.PROD_ID);

-- PK중복이 없는 TEST01의 데이터 확인 (37000개 행 출력)
SELECT a.*
    FROM TEST01.TBL_LT_DET a
    WHERE NOT EXISTS (SELECT b.* FROM TEST02.TBL_LT_DET b
        WHERE a.FA_ID = b.FA_ID
        AND a.LT_ID = b.LT_ID
        AND a.PROD_ID = b.PROD_ID);
        
-- PK중복이 없는 TEST02의 데이터 확인(0개 행 출력)
SELECT b.*
    FROM TEST02.TBL_LT_DET b
    WHERE NOT EXISTS (SELECT a.* FROM TEST01.TBL_LT_DET a
        WHERE a.FA_ID = b.FA_ID
        AND a.LT_ID = b.LT_ID
        AND a.PROD_ID = b.PROD_ID);
*/

-- PK중복이 없는 TEST01의 컬럼과 PK중복이 없는 TEST02의 컬럼은 F12인 경우 F11로 변환해서,
-- PK중복인 컬럼은 TEST01의 데이터로 TEST03에 INSERT
-- 38000개 행 INSERT
INSERT INTO TEST03.TBL_LT_DET c
    (SELECT CASE FA_ID
        WHEN 'F12' THEN 'F11' ELSE a.FA_ID END,
        LT_ID, PROD_ID, PROD_DESC, FL_ID, FL_DESC, OP_ID, OP_DESC, EVENT_DESC, USER_ID
        FROM TEST01.TBL_LT_DET a
        WHERE NOT EXISTS (SELECT b.* FROM TEST02.TBL_LT_DET b
        WHERE (a.FA_ID = b.FA_ID
        AND a.LT_ID = b.LT_ID
        AND a.PROD_ID = b.PROD_ID))
    )
    UNION ALL
    (SELECT CASE FA_ID
        WHEN 'F12' THEN 'F11' ELSE b.FA_ID END, 
        LT_ID, PROD_ID, PROD_DESC, FL_ID, FL_DESC, OP_ID, OP_DESC, EVENT_DESC, USER_ID
        FROM TEST02.TBL_LT_DET b
        WHERE NOT EXISTS (SELECT a.* FROM TEST01.TBL_LT_DET a
        WHERE (a.FA_ID = b.FA_ID
        AND a.LT_ID = b.LT_ID
        AND a.PROD_ID = b.PROD_ID))
    )
    UNION ALL
    (SELECT a.* FROM TEST01.TBL_LT_DET a, TEST02.TBL_LT_DET b
        WHERE (a.FA_ID = b.FA_ID
        AND a.LT_ID = b.LT_ID
        AND a.PROD_ID = b.PROD_ID)
    );

/*
-- PK 중복 없이 FA_ID = 'F12'인 경우
-- TEST01에 대해 2만건, TEST02에 대해 0건, 총 2만개의 행이 변환 대상임을 교차확인
SELECT COUNT(*) 
  FROM TEST01.TBL_LT_DET a
  WHERE a.FA_ID = 'F12'
  AND NOT EXISTS (SELECT b.* FROM TEST02.TBL_LT_DET b
  WHERE a.FA_ID = b.FA_ID
  AND a.LT_ID = b.LT_ID
  AND a.PROD_ID = b.PROD_ID); 
*/