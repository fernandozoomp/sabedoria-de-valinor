# Guia de Contribuição — Sabedoria de Valinor

Obrigado pelo interesse em contribuir! 🧙‍♂️

## Como Contribuir

### 1. Fork o Repositório

```bash
gh repo fork fernandozoomp/sabedoria-de-valinor --clone
cd sabedoria-de-valinor
```

### 2. Crie uma Branch

```bash
git checkout -b feat/sua-feature
```

### 3. Faça suas Alterações

### 4. Commit e Push

```bash
git add .
git commit -m "feat: descrição da alteração"
git push origin feat/sua-feature
```

### 5. Abra um Pull Request

```bash
gh pr create --title "feat: sua feature" --body "Descrição"
```

## Tipos de Contribuição

### 📰 Novas Fontes de Pesquisa
Adicione novas fontes ao `agents/research-agent.md`:
- Site, feed RSS ou subreddit
- Tipo de conteúdo que oferece
- Frequência de atualização

### 🌍 Novos Idiomas
Crie variantes dos prompts:
- Copie `prompts/copy-templates/` e traduza
- Adapte hooks e CTAs para o idioma
- Atualize `prompts/tts-config.md` com o novo idioma

### 🎨 Novos Templates Visuais
Adicione em `templates/infographic/`:
- Template HTML/CSS 1080x1920
- Siga a paleta de cores em `color-palette.md`
- Inclua exemplos de uso

### 📱 Novas Redes Sociais
- Atualize dimensões nos templates
- Adapte `scripts/publish.py`
- Ajuste duração ideal dos vídeos

### ✍️ Melhorias de Copy
- Adicione hooks testados em `hooks-library.md`
- Adicione CTAs em `cta-library.md`
- Compartilhe resultados (views, engagement)

## Padrões

- **Commits:** Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`)
- **Código:** Python (PEP 8), Bash (Google Shell Style)
- **Documentação:** Markdown, em PT-BR
- **Imagens:** 1080x1920 (9:16 vertical)
- **Vídeos:** H.264, MP4, 1080x1920, 30fps

## Código de Conduta

- Seja respeitoso
- Foque no conteúdo de Tolkien — sem tópicos divisivos
- Dê crédito às fontes de informação
- Respeite a obra de J.R.R. Tolkien

## Licença

MIT — suas contribuições também serão MIT.

---

*Dúvidas? Abra uma [issue](https://github.com/fernandozoomp/sabedoria-de-valinor/issues).*
