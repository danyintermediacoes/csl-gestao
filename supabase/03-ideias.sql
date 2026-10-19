-- =====================================================================
-- CSL Gestão · área de Ideias (pública, privada ou compartilhada com alguém)
-- Cole tudo no SQL Editor do Supabase e clique em "Run". Pode rodar de novo.
-- =====================================================================

create table if not exists public.ideias (
  id                text primary key,
  autor             uuid not null default auth.uid() references auth.users(id) on delete cascade,
  visibilidade      text not null default 'publica' check (visibilidade in ('publica', 'privada')),
  compartilhada_com text[] not null default '{}',
  dados             jsonb not null,
  atualizado_em     timestamptz not null default now()
);

-- Nome (Legat / Ricardo Romão) de quem está logado
create or replace function public.meu_nome() returns text
language sql stable security definer set search_path = public as $$
  select nome from public.perfis where id = auth.uid()
$$;

alter table public.ideias enable row level security;

-- Ver: pública para os sócios; privada só para o autor e para quem ele escolheu
drop policy if exists "ver ideias" on public.ideias;
create policy "ver ideias" on public.ideias
  for select to authenticated using (
    public.eh_socio() and (
      visibilidade = 'publica'
      or autor = auth.uid()
      or public.meu_nome() = any (compartilhada_com)
    )
  );

-- Criar, editar e apagar: só o autor
drop policy if exists "criar ideias" on public.ideias;
create policy "criar ideias" on public.ideias
  for insert to authenticated with check (public.eh_socio() and autor = auth.uid());

drop policy if exists "editar ideias" on public.ideias;
create policy "editar ideias" on public.ideias
  for update to authenticated using (autor = auth.uid()) with check (autor = auth.uid());

drop policy if exists "apagar ideias" on public.ideias;
create policy "apagar ideias" on public.ideias
  for delete to authenticated using (autor = auth.uid());

-- Tempo real
do $$
begin
  if not exists (select 1 from pg_publication_tables
                 where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'ideias') then
    alter publication supabase_realtime add table public.ideias;
  end if;
end $$;
