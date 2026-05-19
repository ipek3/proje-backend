#  GSM Backend – Oracle PL/SQL Database Documentation

Bu doküman, Oracle SQL Developer üzerinde geliştirilen GSM backend sisteminin tablolarını ve prosedürlerini açıklar.

---

# Sistem Genel Mimarisi

- Users
- Subscriber
- Services
- Subscriptions
- One-Time Transactions
- Audit Logs

---

#  login_users

Kullanıcı giriş kontrolü yapar.

## Özellikler
- Kullanıcı doğrulama
- ACTIVE kontrolü
- Login loglama

## OUT Parametreler
- p_result
- p_user_id

---

#  top_service_report

En çok kullanılan servisi döndürür.

## Özellikler
- one_time_transactions analizi
- service bazlı grouping

## OUT Parametreler
- p_service_id
- p_service_name
- p_total_usage

---

#  get_active_subscription_count

Aktif abonelik sayısını döndürür.

## OUT Parametre
- p_count

---

#  purchase_service

Servis satın alma işlemini yönetir.

## Akış
1. Subscriber kontrol
2. Service kontrol
3. Balance kontrol
4. Subscription / One-time ayrımı
5. Balance düşme
6. Audit log

---
#  remove_service
servis type kontrolü yapar
subscription ise kaldırır
one-time ise kaldırılmaz
---
#  revenue_report

Gelir analizi yapar.

## Raporlar
- Son 24 saat
- Son 7 gün
- Son 1 ay

---

#  Audit Log Sistemi

Sistem hareketlerini kaydeder:
- LOGIN
- LOGIN_FAILED
- PURCHASE
- REPORT

---

#  Özet

Bu sistem:
Telekom servis yönetimi + abonelik + gelir analizi + audit logging içerir.