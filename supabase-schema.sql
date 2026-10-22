-- Run this entire script in Supabase Dashboard -> SQL Editor -> New query.
create table if not exists public.reading_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  books jsonb not null default '[]'::jsonb,
  appearance jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.reading_data enable row level security;

-- Each signed-in user can read only their own row.
create policy "Users can read their own reading data"
  on public.reading_data for select
  to authenticated
  using (auth.uid() = user_id);

create policy "Users can insert their own reading data"
  on public.reading_data for insert
  to authenticated
  with check (auth.uid() = user_id);

create policy "Users can update their own reading data"
  on public.reading_data for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
