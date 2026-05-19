create or replace NONEDITIONABLE PROCEDURE top_service_report (
    p_service_id OUT NUMBER
)
AS
BEGIN
    SELECT service_id
    INTO p_service_id
    FROM one_time_transactions
    GROUP BY service_id
    ORDER BY COUNT(*) DESC
    FETCH FIRST 1 ROW ONLY;
    
     INSERT INTO audit_logs (
    log_id,
    action_type,
    message
)
VALUES (
    seq_log.NEXTVAL,
    'REPORT',
    'En çok satan servis hesaplandı.'
);
END;