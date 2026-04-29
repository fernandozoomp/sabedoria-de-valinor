# 🧙‍♂️ Sabedoria de Valinor

> **Um agente de IA que pesquisa, cria e publica documentários curtos sobre a Terra Média no TikTok.**

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![OpenClaw Powered](https://img.shields.io/badge/powered%20by-OpenClaw-purple.svg)](https://github.com/openclaw/openclaw)

## O que é?

**Sabedoria de Valinor** é um agente de conteúdo totalmente automatizado (com aprovação humana) focado no universo de J.R.R. Tolkien. Ele:

- 🔍 **Pesquisa** novidades, curiosidades e lore da Terra Média
- ✍️ **Escreve** roteiros documentais otimizados para TikTok
- 🎨 **Gera** cenas cinematográficas com IA e infográficos
- 🎬 **Produz** vídeos curtos (30-60s) prontos para publicar
- ✅ **Envia** pra aprovação via Telegram ou Discord antes de postar

Tudo open source. Fork, customize e crie seu próprio agente de conteúdo.

## Como funciona

```
┌─────────────┐     ┌──────────────┐     ┌───────────────┐     ┌──────────┐
│  Research    │────▶│   Content    │────▶│  Production   │────▶│ Publish  │
│  Agent       │     │   Agent      │     │  Agent        │     │ TikTok   │
│              │     │              │     │               │     │          │
│ • Web search │     │ • Roteiro    │     │ • Imagens IA  │     │          │
│ • Fontes     │     │ • Copy review│     │ • Infográficos│     │          │
│ • Ranking    │     │ • Cena a cena│     │ • Narração    │     │          │
│ • Brief diário│    │ • TTS script │     │ • Montagem    │     │          │
└──────┬───────┘     └──────┬───────┘     └──────┬────────┘     └──────────┘
       │                    │                     │
       ▼                    ▼                     ▼
  ┌──────────────────────────────────────────────────┐
  │              Aprovação Humana                     │
  │         (Telegram / Discord)                      │
  │  "Qual tema seguir?" → "Vídeo pronto, aprova?"   │
  └──────────────────────────────────────────────────┘
```

## Stack

| Função | Tecnologia |
|--------|-----------|
| Orquestração | OpenClaw (cron + sub-agentes) |
| Pesquisa | AutoGLM Web Search + Web Fetch |
| Geração de imagem | AutoGLM Image Generation |
| Narração | TTS (OpenClaw / ElevenLabs) |
| Montagem | FFmpeg |
| Legendas | Python (moviepy) |
| Infográficos | HTML/CSS → imagem |
| Aprovação | Telegram / Discord via OpenClaw |
| Versionamento | GitHub |

## Estrutura do Projeto

```
├── agents/              # Prompts e instruções dos agentes
├── prompts/             # Templates de imagem, roteiro e copy
├── content/             # Briefs, packs de vídeo e histórico
├── templates/           # Templates HTML pra infográficos
├── scripts/             # Scripts de automação (FFmpeg, upload)
└── docs/                # Documentação do projeto
```

## Começando

Veja o [Guia de Setup](docs/setup-guide.md) para instruções completas de instalação e configuração.

## Contribuindo

Contribuições são bem-vindas! Veja o [Guia de Contribuição](docs/contributing.md).

Ideias de contribuição:
- 🌍 Novos idiomas (espanhol, inglês, etc.)
- 📰 Novas fontes de pesquisa
- 🎨 Novos templates de infográfico
- 🎵 Novos estilos musicais de referência
- 📱 Suporte a novas redes sociais (Reels, Shorts)

## Licença

MIT — use, modifique e distribua livremente.

---

*Feito com 🧙‍♂️ e sabedoria élfica.*
