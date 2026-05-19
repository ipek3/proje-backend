create or replace  PROCEDURE sales_performance_workdays (
    p_start_date IN DATE,
    p_end_date   IN DATE,
    p_total_sales OUT NUMBER
)
AS
BEGIN

    SELECT NVL(SUM(amount), 0)
    INTO p_total_sales
    FROM one_time_transactions
    WHERE created_at BETWEEN p_start_date AND p_end_date
    AND TO_CHAR(created_at, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') NOT IN ('SAT', 'SUN');

END;