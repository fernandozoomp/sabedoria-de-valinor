# Arquitetura — Sabedoria de Valinor

## Visão Geral

O sistema é composto por 3 agentes especializados, orquestrados pelo OpenClaw, que operam em um pipeline sequencial com pontos de aprovação humana.

## Componentes

```
┌─────────────────────────────────────────────────────────────────┐
│                      ORQUESTRAÇÃO (OpenClaw)                     │
│                                                                  │
│  ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐     │
│  │  Cron    │──▶│ Research │──▶│ Content  │──▶│Production│     │
│  │  Jobs    │   │  Agent   │   │  Agent   │   │  Agent   │     │
│  └──────────┘   └──────────┘   └──────────┘   └──────────┘     │
│                      │              │              │            │
│                      ▼              ▼              ▼            │
│              ┌──────────────────────────────────────────┐       │
│              │         Aprovação (Telegram/Discord)       │       │
│              │    Brief ──▶ Tema ──▶ Roteiro ──▶ Vídeo    │       │
│              └──────────────────────────────────────────┘       │
└─────────────────────────────────────────────────────────────────┘
```

## 1. Research Agent

- **Trigger:** Cron job (2x/dia — 08:00 e 20:00)
- **Runtime:** Sub-agente isolado (OpenClaw)
- **Função:** Buscar, filtrar e classificar temas de conteúdo
- **Input:** Queries de busca rotativas
- **Output:** Brief diário em `content/briefs/YYYY-MM-DD.md`
- **Entrega:** Mensagem no Telegram/Discord com ranking de temas

## 2. Content Agent

- **Trigger:** Aprovação de tema pelo usuário
- **Runtime:** Sub-agente isolado (OpenClaw)
- **Função:** Criar roteiro, prompts de imagem e script de narração
- **Input:** Tema aprovado + brief
- **Output:** Content Pack em `content/packs/YYYY-MM-DD-tema/`
- **Entrega:** Roteiro completo + cena a cena no Telegram/Discord

## 3. Production Agent

- **Trigger:** Aprovação do roteiro pelo usuário
- **Runtime:** Sub-agente isolado (OpenClaw)
- **Função:** Gerar imagens, narração, montar vídeo
- **Input:** Content Pack aprovado
- **Output:** Vídeo final em `content/packs/YYYY-MM-DD-tema/video-final.mp4`
- **Entrega:** Vídeo pronto + resumo no Telegram/Discord

## Fluxo de Dados

```
Fontes Web → Research Agent → Brief → [Aprovação] → Content Agent
→ Roteiro + Cenas → [Aprovação] → Production Agent
→ Imagens + Narração + Vídeo → [Aprovação] → TikTok
```

## Armazenamento

- **GitHub:** Prompts, templates, scripts, histórico (open source)
- **Local (temp):** Imagens geradas, vídeos em produção, áudio
- **OpenClaw Memory:** Estado dos cron jobs, feedback de vídeos descartados

## Escalabilidade

- Novas fontes: adicionar ao `research-agent.md`
- Novos idiomas: criar variantes dos prompts em `prompts/`
- Novas redes: adaptar `publish.py` + dimensões em templates
- Novos estilos visuais: adicionar templates em `templates/`
