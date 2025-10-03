
create extension if not exists "pgcrypto";

create table if not exists profiles (
  id uuid references auth.users not null primary key,
  username text,
  full_name text,
  avatar_url text,
  bio text,
  points int default 0,
  created_at timestamptz default now()
);

create table if not exists posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles(id),
  content text,
  image_url text,
  likes int default 0,
  created_at timestamptz default now()
);

create table if not exists habits (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles(id),
  title text not null,
  description text,
  streak int default 0,
  completed boolean default false,
  reminder timestamptz
);
