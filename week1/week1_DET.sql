-- TBL_LT_DET�� PK (FA_ID, LT_ID, PROD_ID)
/*
-- UNION (NOT EXISTS)
-- TEST02�� ��� ������(1000��)�� TEST01(�� 38000��)�� Ư�� ��� PK�� ��ġ���� Ȯ�� ���� (UNION �� �� 38000��)
SELECT * FROM TEST01.TBL_LT_DET a
    UNION ALL
SELECT * FROM TEST02.TBL_LT_DET b
    WHERE NOT EXISTS (SELECT a.* FROM TEST01.TBL_LT_DET a
    WHERE a.FA_ID = b.FA_ID
    AND a.LT_ID = b.LT_ID
    AND a.PROD_ID = b.PROD_ID);

-- PK�ߺ��� ���� TEST01�� ������ Ȯ�� (37000�� �� ���)
SELECT a.*
    FROM TEST01.TBL_LT_DET a
    WHERE NOT EXISTS (SELECT b.* FROM TEST02.TBL_LT_DET b
        WHERE a.FA_ID = b.FA_ID
        AND a.LT_ID = b.LT_ID
        AND a.PROD_ID = b.PROD_ID);
        
-- PK�ߺ��� ���� TEST02�� ������ Ȯ��(0�� �� ���)
SELECT b.*
    FROM TEST02.TBL_LT_DET b
    WHERE NOT EXISTS (SELECT a.* FROM TEST01.TBL_LT_DET a
        WHERE a.FA_ID = b.FA_ID
        AND a.LT_ID = b.LT_ID
        AND a.PROD_ID = b.PROD_ID);
*/

-- PK�ߺ��� ���� TEST01�� �÷��� PK�ߺ��� ���� TEST02�� �÷��� F12�� ��� F11�� ��ȯ�ؼ�,
-- PK�ߺ��� �÷��� TEST01�� �����ͷ� TEST03�� INSERT
-- 38000�� �� INSERT
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
-- PK �ߺ� ���� FA_ID = 'F12'�� ���
-- TEST01�� ���� 2����, TEST02�� ���� 0��, �� 2������ ���� ��ȯ ������� ����Ȯ��
SELECT COUNT(*) 
  FROM TEST01.TBL_LT_DET a
  WHERE a.FA_ID = 'F12'
  AND NOT EXISTS (SELECT b.* FROM TEST02.TBL_LT_DET b
  WHERE a.FA_ID = b.FA_ID
  AND a.LT_ID = b.LT_ID
  AND a.PROD_ID = b.PROD_ID); 
*/