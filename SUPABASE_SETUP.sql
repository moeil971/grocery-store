-- اصلاح ساختار مجتمع اندیشه: شماره واحد از شناسه داخلی جدا می‌شود.
-- این فایل را فقط یک بار در Supabase SQL Editor اجرا کنید.

alter table units add column if not exists unit_no integer;
update units set unit_no = id where unit_no is null;
alter table units alter column unit_no set not null;
create unique index if not exists units_unit_no_unique on units(unit_no);

-- برای شارژ، هر واحد در هر ماه فقط یک رکورد داشته باشد.
delete from charges a using charges b where a.id < b.id and a.unit_id = b.unit_id and a.month = b.month;
create unique index if not exists charges_unit_month_unique on charges(unit_id, month);

alter table units enable row level security;
alter table charges enable row level security;
alter table payments enable row level security;

drop policy if exists "public_units_all" on units;
create policy "public_units_all" on units for all to anon, authenticated using (true) with check (true);
drop policy if exists "public_charges_all" on charges;
create policy "public_charges_all" on charges for all to anon, authenticated using (true) with check (true);
drop policy if exists "public_payments_all" on payments;
create policy "public_payments_all" on payments for all to anon, authenticated using (true) with check (true);
