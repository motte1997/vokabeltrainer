-- Einmalig im Supabase SQL Editor ausführen (Project -> SQL Editor -> New query -> Run)

create table if not exists public.vt_state (
  user_id    uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  data       jsonb not null,
  rev        integer not null default 1,
  updated_at timestamptz not null default now()
);

alter table public.vt_state enable row level security;

-- Jeder Benutzer sieht und ändert ausschließlich seine eigene Zeile
create policy "own row select" on public.vt_state for select using (auth.uid() = user_id);
create policy "own row insert" on public.vt_state for insert with check (auth.uid() = user_id);
create policy "own row update" on public.vt_state for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own row delete" on public.vt_state for delete using (auth.uid() = user_id);
