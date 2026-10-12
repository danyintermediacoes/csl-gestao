# CSL Gestão · versão 2 (com Supabase)

## Arquivos
- `index.html`: o app inteiro. Abra com dois cliques no navegador (Chrome ou Edge).
- `CONFIGURAR-SUPABASE.md`: passo a passo para ligar o banco e os logins.
- `supabase/`: os dois scripts SQL usados nesse passo a passo.
- `plano-exemplo.json`: exemplo do formato padrão de plano, para testar o botão "Importar plano".

## Onde ficam os dados
Com o Supabase configurado (ver `CONFIGURAR-SUPABASE.md`), cada um entra com o seu login e os dados
ficam no banco, aparecendo para os dois em tempo real. Sem configurar, o app funciona no modo local,
com dados de exemplo e tudo salvo só no navegador.

## Hospedar grátis no GitHub Pages (quando quiser)
1. Criar um repositório no GitHub e enviar o `index.html`.
2. Em Settings > Pages, escolher a branch `main` e salvar.
3. O endereço fica no formato `https://SEU-USUARIO.github.io/NOME-DO-REPOSITORIO/`.
