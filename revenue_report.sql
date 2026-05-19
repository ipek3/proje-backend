CREATE OR REPLACE PROCEDURE revenue_report (
    p_last_24h OUT NUMBER,
    p_weekly OUT NUMBER,
    p_monthly OUT NUMBER
)
AS
BEGIN

    -- Last 24 Hours
    SELECT NVL(SUM(amount),0)
    INTO p_last_24h
    FROM one_time_transactions
    WHERE created_at >= SYSDATE - 1;

    -- Last 7 Days
    SELECT NVL(SUM(amount),0)
    INTO p_weekly
    FROM one_time_transactions
    WHERE created_at >= SYSDATE - 7;

    -- Last 1 Month
    SELECT NVL(SUM(amount),0)
    INTO p_monthly
    FROM one_time_transactions
    WHERE created_at >= ADD_MONTHS(SYSDATE, -1);

END;
