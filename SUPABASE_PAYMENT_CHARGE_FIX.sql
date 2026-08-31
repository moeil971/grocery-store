-- اصلاح قطعی پرداخت و شارژ
-- این فایل را بعد از ورود به Supabase SQL Editor اجرا کنید.
-- اطلاعات واحدها و مبالغ معتبر حفظ می‌شوند.

-- 1) حذف پرداخت‌های تکراری هر واحد/ماه؛ فقط آخرین رکورد نگه داشته می‌شود.
WITH ranked AS (
  SELECT id,
         ROW_NUMBER() OVER (
           PARTITION BY unit_id, month
           ORDER BY id DESC
         ) AS rn
  FROM payments
  WHERE month IS NOT NULL AND month <> ''
)
DELETE FROM payments p
USING ranked r
WHERE p.id = r.id AND r.rn > 1;

-- 2) جلوگیری دائمی از ایجاد پرداخت تکراری برای یک واحد در یک ماه.
CREATE UNIQUE INDEX IF NOT EXISTS uq_payments_unit_month
ON payments(unit_id, month)
WHERE month IS NOT NULL AND month <> '';

-- 3) اطمینان از یکتا بودن شارژ هر واحد در هر ماه.
CREATE UNIQUE INDEX IF NOT EXISTS uq_charges_unit_month
ON charges(unit_id, month);

-- 4) بررسی نتیجه
SELECT 'units' AS table_name, COUNT(*) AS row_count FROM units
UNION ALL
SELECT 'charges', COUNT(*) FROM charges
UNION ALL
SELECT 'payments', COUNT(*) FROM payments;

SELECT unit_id, month, amount
FROM charges
ORDER BY unit_id, CASE month
  WHEN 'تیر' THEN 1 WHEN 'مرداد' THEN 2 WHEN 'شهریور' THEN 3
  WHEN 'مهر' THEN 4 WHEN 'آبان' THEN 5 WHEN 'آذر' THEN 6
  WHEN 'دی' THEN 7 WHEN 'بهمن' THEN 8 WHEN 'اسفند' THEN 9
  ELSE 99 END
LIMIT 50;
