-- =====================================================================
-- CSL Gestão · banco de dados no Supabase
-- Cole tudo no SQL Editor do Supabase e clique em "Run". Pode rodar de novo
-- sem problema: nada é apagado.
-- =====================================================================

-- Quem é quem: liga cada login a "Legat" ou "Ricardo Romão"
create table if not exists public.perfis (
  id   uuid primary key references auth.users(id) on delete cascade,
  nome text not null unique check (nome in ('Legat', 'Ricardo Romão'))
);

-- Tarefas avulsas (cada linha guarda a tarefa inteira, com os registros)
create table if not exists public.tarefas (
  id            text primary key,
  dados         jsonb not null,
  atualizado_em timestamptz not null default now()
);

-- Projetos (cada linha guarda o projeto com todas as etapas)
create table if not exists public.projetos (
  id            text primary key,
  dados         jsonb not null,
  atualizado_em timestamptz not null default now()
);

-- Histórico de atividades ("Ricardo concluiu a etapa X às 14h32")
create table if not exists public.historico (
  id    text primary key,
  dados jsonb not null,
  em    timestamptz not null default now()
);
create index if not exists historico_em_idx on public.historico (em desc);

-- Ajustes compartilhados (horas por dia, avisos já vistos)
create table if not exists public.config (
  chave         text primary key,
  valor         jsonb not null,
  atualizado_em timestamptz not null default now()
);

-- Só quem está na tabela "perfis" (vocês dois) acessa os dados.
create or replace function public.eh_socio() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.perfis where id = auth.uid())
$$;

alter table public.perfis    enable row level security;
alter table public.tarefas   enable row level security;
alter table public.projetos  enable row level security;
alter table public.historico enable row level security;
alter table public.config    enable row level security;

drop policy if exists "socios leem perfis" on public.perfis;
create policy "socios leem perfis" on public.perfis
  for select to authenticated using (id = auth.uid() or public.eh_socio());

drop policy if exists "socios tudo" on public.tarefas;
create policy "socios tudo" on public.tarefas
  for all to authenticated using (public.eh_socio()) with check (public.eh_socio());

drop policy if exists "socios tudo" on public.projetos;
create policy "socios tudo" on public.projetos
  for all to authenticated using (public.eh_socio()) with check (public.eh_socio());

drop policy if exists "socios tudo" on public.historico;
create policy "socios tudo" on public.historico
  for all to authenticated using (public.eh_socio()) with check (public.eh_socio());

drop policy if exists "socios tudo" on public.config;
create policy "socios tudo" on public.config
  for all to authenticated using (public.eh_socio()) with check (public.eh_socio());

-- Tempo real: o que um faz aparece na tela do outro na hora
do $$
declare t text;
begin
  foreach t in array array['tarefas', 'projetos', 'historico', 'config'] loop
    if not exists (select 1 from pg_publication_tables
                   where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = t) then
      execute format('alter publication supabase_realtime add table public.%I', t);
    end if;
  end loop;
end $$;

-- Prints: pasta privada, só vocês dois enxergam
insert into storage.buckets (id, name, public)
values ('prints', 'prints', false)
on conflict (id) do nothing;

drop policy if exists "socios leem prints" on storage.objects;
create policy "socios leem prints" on storage.objects
  for select to authenticated using (bucket_id = 'prints' and public.eh_socio());

drop policy if exists "socios enviam prints" on storage.objects;
create policy "socios enviam prints" on storage.objects
  for insert to authenticated with check (bucket_id = 'prints' and public.eh_socio());

drop policy if exists "socios apagam prints" on storage.objects;
create policy "socios apagam prints" on storage.objects
  for delete to authenticated using (bucket_id = 'prints' and public.eh_socio());
