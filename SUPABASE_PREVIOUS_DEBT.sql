-- اجرای یک‌باره برای قابلیت «بدهی پیشین»
ALTER TABLE units
ADD COLUMN IF NOT EXISTS has_previous_debt BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE units
ADD COLUMN IF NOT EXISTS opening NUMERIC(14,2) NOT NULL DEFAULT 0;

UPDATE units
SET has_previous_debt = (COALESCE(opening,0) > 0)
WHERE has_previous_debt IS NULL;

-- بررسی
SELECT unit_no, name, has_previous_debt, opening
FROM units
ORDER BY id
LIMIT 10;
