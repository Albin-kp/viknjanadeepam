create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.magazine_volumes (
  id uuid primary key default gen_random_uuid(),
  year integer not null check (year between 1900 and 2200),
  volume_number integer not null check (volume_number > 0),
  title text not null check (length(trim(title)) > 0),
  subtitle text not null default '',
  description text not null default '',
  reading_minutes integer not null default 30 check (reading_minutes > 0),
  chapters jsonb not null default '[]'::jsonb,
  published boolean not null default false,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (year, volume_number)
);

create index if not exists magazine_volumes_public_order_idx
  on public.magazine_volumes (year desc, volume_number desc)
  where published = true;

create or replace function public.is_magazine_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.admin_users
    where user_id = (select auth.uid())
  );
$$;

create or replace function public.set_magazine_updated_at()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at = now();
  if new.created_by is null then
    new.created_by = (select auth.uid());
  end if;
  return new;
end;
$$;

drop trigger if exists set_magazine_updated_at on public.magazine_volumes;
create trigger set_magazine_updated_at
before insert or update on public.magazine_volumes
for each row execute function public.set_magazine_updated_at();

alter table public.admin_users enable row level security;
alter table public.magazine_volumes enable row level security;

drop policy if exists "admins can view themselves" on public.admin_users;
create policy "admins can view themselves"
on public.admin_users for select
to authenticated
using (user_id = (select auth.uid()));

drop policy if exists "published volumes are public" on public.magazine_volumes;
create policy "published volumes are public"
on public.magazine_volumes for select
to anon, authenticated
using (published or public.is_magazine_admin());

drop policy if exists "admins can insert volumes" on public.magazine_volumes;
create policy "admins can insert volumes"
on public.magazine_volumes for insert
to authenticated
with check (public.is_magazine_admin());

drop policy if exists "admins can update volumes" on public.magazine_volumes;
create policy "admins can update volumes"
on public.magazine_volumes for update
to authenticated
using (public.is_magazine_admin())
with check (public.is_magazine_admin());

drop policy if exists "admins can delete volumes" on public.magazine_volumes;
create policy "admins can delete volumes"
on public.magazine_volumes for delete
to authenticated
using (public.is_magazine_admin());

grant select on public.magazine_volumes to anon;
grant select, insert, update, delete on public.magazine_volumes to authenticated;
grant select on public.admin_users to authenticated;

-- After creating your administrator in Authentication > Users, run:
-- insert into public.admin_users (user_id) values ('YOUR-AUTH-USER-UUID');
