CREATE OR REPLACE  PROCEDURE top_service_report (
    p_service_id   OUT NUMBER,
    p_service_name OUT VARCHAR2,
    p_total_usage  OUT NUMBER
)
AS
BEGIN

    SELECT 
        s.service_id,
        s.service_name,
        COUNT(*) AS total_usage
    INTO 
        p_service_id,
        p_service_name,
        p_total_usage
    FROM one_time_transactions ott
    JOIN services s
        ON ott.service_id = s.service_id
    GROUP BY 
        s.service_id, 
        s.service_name
    ORDER BY total_usage DESC
    FETCH FIRST 1 ROW ONLY;

    INSERT INTO audit_logs (
        log_id,
        action_type,
        message
    )
    VALUES (
        seq_log.NEXTVAL,
        'REPORT',
        'En çok kullanılan servis raporu üretildi.'
    );

END;
