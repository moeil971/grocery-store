-- این فایل را یک بار در SQL Editor سوپابیس اجرا کن
-- ستون slot ترتیب ثابت ردیف‌ها را نگه می‌دارد حتی اگر شماره واحد عوض شود.
alter table units add column if not exists slot integer;
update units set slot = sub.rn from (select id, row_number() over(order by id)-1 as rn from units) sub where units.id=sub.id and units.slot is null;

alter table units enable row level security;
alter table charges enable row level security;
alter table payments enable row level security;
drop policy if exists "public_units_all" on units;
create policy "public_units_all" on units for all to anon, authenticated using (true) with check (true);
drop policy if exists "public_charges_all" on charges;
create policy "public_charges_all" on charges for all to anon, authenticated using (true) with check (true);
drop policy if exists "public_payments_all" on payments;
create policy "public_payments_all" on payments for all to anon, authenticated using (true) with check (true);
