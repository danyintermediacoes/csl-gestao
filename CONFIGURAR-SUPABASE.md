# Ligar o CSL Gestão ao Supabase

São 5 passos, todos no site do Supabase. Nenhum precisa de programação.

## Passo 1 · Criar o projeto
1. Entre em https://supabase.com e crie uma conta (pode ser com o GitHub ou e-mail).
2. Clique em **New project**.
3. Nome: `csl-gestao`. Crie uma senha do banco e guarde (não é a senha de login do app).
4. Região: **South America (São Paulo)**. Plano: **Free**.
5. Espere um ou dois minutos até o projeto ficar pronto.

## Passo 2 · Criar as tabelas
1. No menu da esquerda, abra **SQL Editor** e clique em **New query**.
2. Cole todo o conteúdo do arquivo `supabase/01-criar-banco.sql` e clique em **Run**.
3. Deve aparecer "Success. No rows returned".

## Passo 3 · Criar os dois logins
1. Abra **Authentication > Users** e clique em **Add user > Create new user**.
2. Coloque o e-mail e uma senha do Legat e marque **Auto Confirm User**. Repita para o Ricardo.
3. Em **Authentication > Sign In / Providers**, desligue **Allow new users to sign up**.
   Assim ninguém mais consegue criar conta no app de vocês.

## Passo 4 · Dizer ao banco quem é quem
1. Volte ao **SQL Editor**, abra uma nova query e cole o arquivo `supabase/02-ligar-usuarios.sql`.
2. Troque os dois e-mails de exemplo pelos e-mails do passo 3 e clique em **Run**.
3. O resultado deve mostrar duas linhas: Legat e Ricardo Romão com os e-mails.

## Passo 5 · Ligar o app ao banco
1. Abra **Project Settings > API** (ou **Data API**).
2. Copie a **Project URL** e a chave **anon public**.
3. Mande as duas para o Claude no projeto, ou cole no `index.html`, nas linhas
   `const SUPABASE_URL = '';` e `const SUPABASE_CHAVE_PUBLICA = '';`.

A chave "anon public" pode ficar no código, porque as regras do banco só deixam vocês dois
lerem e gravarem. **Nunca** coloque nem mande a chave "service_role".

## Passo 6 · Área de Ideias
1. No **SQL Editor**, abra uma nova query, cole o conteúdo de `supabase/03-ideias.sql` e clique em **Run**.
2. Ideias públicas aparecem para os dois. Privadas só para quem criou e para quem ele marcar.
   Só o autor edita ou apaga a própria ideia.

## Depois de ligado
- Ao abrir o app aparece a tela de login. Cada um entra com o seu e-mail; os dois veem e editam tudo.
- O canto de cima mostra "Sincronizado". Se a internet cair, aparece "Sem conexão" e o app tenta de novo sozinho.
- Prints vão para uma pasta privada no Supabase (Storage > prints).
- Se já criaram tarefas na versão sem login: lá, Ajustes > Exportar backup; aqui, Ajustes > Importar backup.
- Esqueceu a senha: em Authentication > Users, clique no usuário e use "Send password recovery"
  ou defina uma senha nova.
