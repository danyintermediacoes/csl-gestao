-- =====================================================================
-- CSL Gestão · ligar os logins a Legat e Ricardo Romão
-- Rode DEPOIS de criar os dois usuários em Authentication > Users.
-- Troque os dois e-mails abaixo pelos e-mails que vocês usaram lá.
-- =====================================================================

insert into public.perfis (id, nome)
select id, 'Legat' from auth.users where email = 'EMAIL-DO-LEGAT@exemplo.com'
on conflict (id) do update set nome = excluded.nome;

insert into public.perfis (id, nome)
select id, 'Ricardo Romão' from auth.users where email = 'EMAIL-DO-RICARDO@exemplo.com'
on conflict (id) do update set nome = excluded.nome;

-- Conferência: deve mostrar 2 linhas, uma para cada um
select p.nome, u.email from public.perfis p join auth.users u on u.id = p.id;
