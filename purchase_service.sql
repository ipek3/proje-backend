create or replace  PROCEDURE purchase_service (
    p_subscriber_id NUMBER,
    p_service_id NUMBER
)
IS
    v_balance NUMBER;
    v_sub_status VARCHAR2(20);

    v_service_type VARCHAR2(20);
    v_service_price NUMBER;
    v_service_status VARCHAR2(20);

    v_duplicate_count NUMBER;

BEGIN

    --------------------------------
    -- Abone kontrolü
    --------------------------------
    SELECT balance, status
    INTO v_balance, v_sub_status
    FROM subscriber
    WHERE subscriber_id = p_subscriber_id;

    IF v_sub_status <> 'ACTIVE' THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Abone aktif değil');
    END IF;

    --------------------------------
    -- Servis kontrolü
    --------------------------------
    SELECT service_type, price, status
    INTO v_service_type,
         v_service_price,
         v_service_status
    FROM services
    WHERE service_id = p_service_id;

    IF v_service_status <> 'ACTIVE' THEN
        RAISE_APPLICATION_ERROR(-20002,
            'Servis bulunamadı');
    END IF;


    --------------------------------
    -- Bakiye kontrolü
    --------------------------------
    IF v_balance < v_service_price THEN
        RAISE_APPLICATION_ERROR(-20003,
            'Yetersiz bakiye.Gerekli:'||v_service_price||'TL, Mevcut:'|| v_balance || 'TL');
    END IF;


    --------------------------------
    -- Subscription logic
    --------------------------------
    IF v_service_type = 'SUBSCRIPTION' THEN

        SELECT COUNT(*)
        INTO v_duplicate_count
        FROM subscriptions
        WHERE subscriber_id = p_subscriber_id
        AND service_id = p_service_id
        AND status = 'ACTIVE';

        IF v_duplicate_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20004,
                'Abonelik zaten mevcut.');
        END IF;

        INSERT INTO subscriptions (
            subscription_id,
            subscriber_id,
            service_id,
            status
        )
        VALUES (
            seq_subscription.NEXTVAL,
            p_subscriber_id,
            p_service_id,
            'ACTIVE'
        );

    ELSE

        --------------------------------
        -- One time logic
        --------------------------------
        INSERT INTO one_time_transactions (
            transaction_id,
            subscriber_id,
            service_id,
            amount
        )
        VALUES (
            seq_onetime.NEXTVAL,
            p_subscriber_id,
            p_service_id,
            v_service_price
        );

    END IF;


    --------------------------------
    -- Bakiye düşürme
    --------------------------------
    UPDATE subscriber
    SET balance = balance - v_service_price
    WHERE subscriber_id = p_subscriber_id;


    --------------------------------
    -- Logging
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
    'PURCHASE',
    'SERVICE',
    p_service_id,
    'Servis başarıyla satın alındı.'
);
   
    COMMIT;

EXCEPTION

    WHEN OTHERS THEN

        ROLLBACK;


  RAISE;

END;