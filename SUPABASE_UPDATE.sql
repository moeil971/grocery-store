-- این فایل را فقط یک بار روی دیتابیس فعلی اجرا کن.
-- اطلاعات قبلی حذف نمی‌شود.

ALTER TABLE units
ADD COLUMN IF NOT EXISTS tenant_name TEXT NOT NULL DEFAULT '';

-- اطمینان از اینکه تاریخ پرداخت می‌تواند خالی باشد.
ALTER TABLE payments
ALTER COLUMN payment_date DROP NOT NULL;

-- اگر RLS فعال است، دسترسی فعلی را نگه می‌داریم؛ در صورت نبودن policy آن را ایجاد می‌کنیم.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname='public' AND tablename='units' AND policyname='public_units_all'
  ) THEN
    CREATE POLICY "public_units_all" ON units
    FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname='public' AND tablename='charges' AND policyname='public_charges_all'
  ) THEN
    CREATE POLICY "public_charges_all" ON charges
    FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname='public' AND tablename='payments' AND policyname='public_payments_all'
  ) THEN
    CREATE POLICY "public_payments_all" ON payments
    FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
  END IF;
END $$;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema='public' AND table_name IN ('units','payments')
ORDER BY table_name, ordinal_position;
