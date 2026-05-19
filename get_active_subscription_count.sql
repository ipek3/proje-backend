CREATE OR REPLACE PROCEDURE get_active_subscription_count (
    p_count OUT NUMBER
)
AS
BEGIN
    SELECT COUNT(*)
    INTO p_count
    FROM subscriptions
    WHERE status = 'ACTIVE';

 INSERT INTO audit_logs (
    log_id,
    action_type,
    message
)
VALUES (
    seq_log.NEXTVAL,
    'REPORT',
    'Aktif subscription sayısı hesaplandı.'
);
    COMMIT;
END;
