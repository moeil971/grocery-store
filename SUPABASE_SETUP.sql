-- راه‌اندازی تمیز Supabase برای مجتمع اندیشه
-- فقط اطلاعات ساکن: نام، تلفن، مالک/مستأجر و رمز
-- شارژ: تیر تا اسفند

DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS charges CASCADE;
DROP TABLE IF EXISTS units CASCADE;

CREATE TABLE units (
  id BIGSERIAL PRIMARY KEY,
  unit_no INTEGER NOT NULL UNIQUE,
  name TEXT NOT NULL DEFAULT '',
  phone TEXT NOT NULL DEFAULT '',
  password TEXT NOT NULL DEFAULT '',
  is_owner BOOLEAN NOT NULL DEFAULT FALSE,
  opening NUMERIC(14,2) NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE charges (
  id BIGSERIAL PRIMARY KEY,
  unit_id BIGINT NOT NULL REFERENCES units(id) ON DELETE CASCADE,
  month TEXT NOT NULL CHECK (month IN ('تیر','مرداد','شهریور','مهر','آبان','آذر','دی','بهمن','اسفند')),
  amount NUMERIC(14,2) NOT NULL DEFAULT 0,
  UNIQUE(unit_id, month)
);

CREATE TABLE payments (
  id BIGSERIAL PRIMARY KEY, unit_id BIGINT NOT NULL REFERENCES units(id) ON DELETE CASCADE,
  month TEXT DEFAULT '', amount NUMERIC(14,2) NOT NULL DEFAULT 0, payment_date DATE, method TEXT DEFAULT '', reference TEXT DEFAULT '', created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO units (unit_no,password) SELECT generate_series(1,210),'';
INSERT INTO charges (unit_id,month,amount) SELECT u.id,m.month,0 FROM units u CROSS JOIN (VALUES ('تیر'),('مرداد'),('شهریور'),('مهر'),('آبان'),('آذر'),('دی'),('بهمن'),('اسفند')) m(month);

CREATE INDEX idx_units_unit_no ON units(unit_no);
CREATE INDEX idx_units_phone ON units(phone);
CREATE INDEX idx_charges_unit_id ON charges(unit_id);
CREATE INDEX idx_payments_unit_id ON payments(unit_id);

ALTER TABLE units ENABLE ROW LEVEL SECURITY;
ALTER TABLE charges ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_units_all" ON units FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
CREATE POLICY "public_charges_all" ON charges FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
CREATE POLICY "public_payments_all" ON payments FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

SELECT COUNT(*) AS total_units FROM units;
SELECT COUNT(*) AS total_charges FROM charges;
