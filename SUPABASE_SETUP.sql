alter table units enable row level security;
alter table charges enable row level security;
alter table payments enable row level security;
drop policy if exists "public_units_all" on units;
create policy "public_units_all" on units for all to anon, authenticated using (true) with check (true);
drop policy if exists "public_charges_all" on charges;
create policy "public_charges_all" on charges for all to anon, authenticated using (true) with check (true);
drop policy if exists "public_payments_all" on payments;
create policy "public_payments_all" on payments for all to anon, authenticated using (true) with check (true);
