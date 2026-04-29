# Guia de Setup — Sabedoria de Valinor

## Pré-requisitos

- [OpenClaw](https://github.com/openclaw/openclaw) instalado e configurado
- [FFmpeg](https://ffmpeg.org/) 6.0+
- [Python](https://python.org/) 3.10+
- Conta no GitHub (para versionamento)
- Telegram ou Discord (para aprovação)
- (Opcional) Conta no TikTok (para publicação automática)

## 1. Clonar o Repositório

```bash
git clone https://github.com/fernandozoomp/sabedoria-de-valinor.git
cd sabedoria-de-valinor
```

## 2. Configurar o OpenClaw

### Conectar Telegram ou Discord

Siga a documentação do OpenClaw para configurar o canal de mensagens:
- Telegram: crie um bot via @BotFather e conecte ao OpenClaw
- Discord: crie um bot e adicione ao servidor

### Configurar Skills

Certifique-se de que as seguintes skills estão disponíveis:
- `autoglm-websearch` — pesquisa web
- `autoglm-open-link` — leitura de páginas
- `autoglm-generate-image` — geração de imagens
- `tts` — narração

### Configurar Cron Jobs

No OpenClaw, crie os seguintes cron jobs:

**Research Morning (08:00):**
```json
{
  "name": "research-morning",
  "schedule": { "kind": "cron", "expr": "0 8 * * *", "tz": "America/Sao_Paulo" },
  "payload": { "kind": "agentTurn", "message": "Execute o Research Agent. Leia agents/research-agent.md, busque novidades sobre Tolkien/Terra Média e gere o brief diário. Salve em content/briefs/ e envie via Telegram/Discord." },
  "sessionTarget": "isolated",
  "delivery": { "mode": "announce" }
}
```

**Research Night (20:00):**
```json
{
  "name": "research-night",
  "schedule": { "kind": "cron", "expr": "0 20 * * *", "tz": "America/Sao_Paulo" },
  "payload": { "kind": "agentTurn", "message": "Execute o Research Agent. Leia agents/research-agent.md, busque novidades sobre Tolkien/Terra Média e gere o brief diário. Salve em content/briefs/ e envie via Telegram/Discord." },
  "sessionTarget": "isolated",
  "delivery": { "mode": "announce" }
}
```

## 3. Instalar Dependências

### FFmpeg
```bash
# macOS
brew install ffmpeg

# Ubuntu
sudo apt install ffmpeg
```

### Python
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## 4. Configurar Variáveis de Ambiente (Opcional)

```bash
export TIKTOK_ACCESS_TOKEN="your_token_here"
export ELEVENLABS_API_KEY="your_key_here"  # Se usar ElevenLabs para TTS
```

## 5. Testar o Pipeline

### Teste de Pesquisa
```
"Execute o Research Agent manualmente. Gere um brief de teste."
```

### Teste de Criação
```
"Pegue o brief mais recente e crie um Content Pack de teste sobre o primeiro tema."
```

### Teste de Produção
```bash
# Gerar imagens (requer skill configurada)
./scripts/generate-images.sh content/packs/test-tema

# Montar vídeo
./scripts/compose-video.sh content/packs/test-tema

# Gerar legendas
python3 scripts/generate-subtitles.py content/packs/test-tema/narracao.txt content/packs/test-tema/narracao.mp3
```

## 6. Primeiro Vídeo

1. Aguarde o brief diário no Telegram/Discord
2. Escolha um tema respondendo com o número
3. Revise o roteiro quando chegar
4. Aprove o vídeo final
5. Publique no TikTok

## Troubleshooting

| Problema | Solução |
|----------|---------|
| Skill não encontrada | Verifique `openclaw skills check` |
| FFmpeg erro de codec | `brew install ffmpeg --with-libvpx --with-libvorbis` |
| Imagens cortadas | Verifique resolução 1080x1920 no prompt |
| Vídeo muito longo | Reduza cenas ou duração no roteiro |
| TTS não funciona | Teste com `tts` diretamente no OpenClaw |

## Suporte

Abra uma [issue](https://github.com/fernandozoomp/sabedoria-de-valinor/issues) para problemas ou sugestões.
