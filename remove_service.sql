CREATE OR REPLACE PROCEDURE remove_service (
    p_subscriber_id NUMBER,
    p_service_id    NUMBER
)
IS
    v_service_type VARCHAR2(20);
    v_sub_count NUMBER;
BEGIN

    --------------------------------
    -- Servis tipi kontrolü
    --------------------------------
    SELECT service_type
    INTO v_service_type
    FROM services
    WHERE service_id = p_service_id;


    --------------------------------
    -- SUBSCRIPTION ise kaldır
    --------------------------------
    IF v_service_type = 'SUBSCRIPTION' THEN

        SELECT COUNT(*)
        INTO v_sub_count
        FROM subscriptions
        WHERE subscriber_id = p_subscriber_id
        AND service_id = p_service_id
        AND status = 'ACTIVE';

        IF v_sub_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20010,
                'Aktif abonelik bulunamadı');
        END IF;

        UPDATE subscriptions
        SET status = 'PASSIVE'
        WHERE subscriber_id = p_subscriber_id
        AND service_id = p_service_id;

    ELSE

        --------------------------------
        -- ONE-TIME: silinmez, sadece loglanır
        --------------------------------
        RAISE_APPLICATION_ERROR(-20011,
            'One-time servisler iptal edilemez');

    END IF;


    --------------------------------
    -- Log
    --------------------------------
    INSERT INTO audit_logs (
        log_id,
        subscriber_id,
        action_type,
        entity_type,
        entity_id,
        message
    )
    VALUES (
        seq_log.NEXTVAL,
        p_subscriber_id,
        'CANCEL',
        'SERVICE',
        p_service_id,
        'Servis başarıyla kaldırıldı.'
    );

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
