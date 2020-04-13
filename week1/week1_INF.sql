-- TBL_LT_INF�� PK (FA_ID, LT_ID, PROD_ID)
/*
-- UNION (NOT EXISTS) (76000�� �� ���)
SELECT COUNT(*) FROM (
SELECT * FROM TEST01.TBL_LT_INF a
    UNION ALL
SELECT * FROM TEST02.TBL_LT_INF b
    WHERE NOT EXISTS (SELECT a.* FROM TEST01.TBL_LT_INF a
    WHERE a.FA_ID = b.FA_ID
    AND a.LT_ID = b.LT_ID
    AND a.PROD_ID = b.PROD_ID));

-- PK�ߺ��� ���� TEST01�� ������ Ȯ�� (�ߺ� 1000�� �����ϰ� 37000�� �� ���)
SELECT a.*
    FROM TEST01.TBL_LT_INF a
    WHERE NOT EXISTS (SELECT b.* FROM TEST02.TBL_LT_INF b
        WHERE a.FA_ID = b.FA_ID
        AND a.LT_ID = b.LT_ID
        AND a.PROD_ID = b.PROD_ID)
;
-- PK�ߺ��� ���� TEST02�� ������ Ȯ�� (�ߺ� 1000�� �����ϰ� 38000�� �� ���)
SELECT COUNT(*) FROM (
SELECT b.*
    FROM TEST02.TBL_LT_INF b
    WHERE NOT EXISTS (SELECT a.* FROM TEST01.TBL_LT_INF a
        WHERE a.FA_ID = b.FA_ID
        AND a.LT_ID = b.LT_ID
        AND a.PROD_ID = b.PROD_ID))
;
*/

-- PK�ߺ��� ���� TEST01�� �÷��� PK�ߺ��� ���� TEST02�� �÷��� F12�� ��� F11�� ��ȯ�ؼ�,
-- PK�ߺ��� �÷��� TEST01�� �����ͷ� TEST03�� INSERT
-- 76000�� ������ INSERT

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
-- PK �ߺ� ���� FA_ID = 'F12'�� ���
-- TEST01�� ���� 2�� ��, TEST02�� ���� 2�� ��, �� 2������ ���� ��ȯ ������� ����Ȯ��
SELECT COUNT(*) 
  FROM TEST02.TBL_LT_INF b
  WHERE b.FA_ID = 'F12'
  AND NOT EXISTS (SELECT a.* FROM TEST01.TBL_LT_INF a
  WHERE a.FA_ID = b.FA_ID
  AND a.LT_ID = b.LT_ID
  AND a.PROD_ID = b.PROD_ID)
  ; 
*/