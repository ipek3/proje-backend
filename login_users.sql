CREATE OR REPLACE PROCEDURE login_users (
    p_username IN VARCHAR2,
    p_password IN VARCHAR2,
    p_result   OUT VARCHAR2,
    p_user_id  OUT NUMBER
)
AS  
    v_count NUMBER;
BEGIN

    SELECT COUNT(*)
    INTO v_count
    FROM users
    WHERE username = p_username
    AND password = p_password
    AND status = 'ACTIVE';

    IF v_count = 1 THEN

        p_result := 'SUCCESS';

        -- USER_ID'yi çekiyoruz
        SELECT user_id
        INTO p_user_id
        FROM users
        WHERE username = p_username
        AND password = p_password;

        INSERT INTO audit_logs (
            log_id,
            action_type,
            message,
            created_at
        )
        VALUES (
            seq_log.NEXTVAL,
            'LOGIN',
            'Successful login for user: ' || p_username,
            SYSDATE
        );

    ELSE

        p_result := 'FAIL';
        p_user_id := NULL;

        INSERT INTO audit_logs (
            log_id,
            action_type,
            message,
            created_at
        )
        VALUES (
            seq_log.NEXTVAL,
            'LOGIN_FAILED',
            'Failed login attempt for user: ' || p_username,
            SYSDATE
        );

    END IF;

    COMMIT;

END;