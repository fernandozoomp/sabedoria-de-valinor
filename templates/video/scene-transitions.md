# Transições de Cena — Sabedoria de Valinor

## Tipos de Transição

### 1. Ken Burns (Zoom Lento)
- Zoom in suave 100% → 110% durante 3-5 segundos
- **Uso:** cenas de paisagem, establishing shots
- **FFmpeg:** `zoompan=z='min(zoom+0.001,1.1)':d=150:s=1080x1920`

### 2. Pan Horizontal
- Movimento lento da esquerda pra direita
- **Uso:** mapas, panoramas, batalhas
- **FFmpeg:** `crop` filter com posição animada

### 3. Fade In/Out
- Fade preto entre cenas (0.5s entrada + 0.5s saída)
- **Uso:** transição entre cenas diferentes
- **FFmpeg:** `fade=t=in:st=0:d=0.5,fade=t=out:st=4.5:d=0.5`

### 4. Crossfade
- Mistura suave entre duas imagens (1s overlap)
- **Uso:** sequências narrativas fluidas
- **FFmpeg:** `xfade=transition=fade:duration=1:offset=X`

### 5. Zoom In (Dramático)
- Zoom rápido no centro da imagem
- **Uso:** clímax, revelações, dados impactantes
- **FFmpeg:** `zoompan=z='1+0.005*in':d=90:s=1080x1920`

### 6. Parallax
- Camada de texto se move em velocidade diferente da imagem
- **Uso:** citações, títulos de seção
- **FFmpeg:** overlay com position animada

## Ordem Recomendada por Tipo de Vídeo

| Tipo de vídeo | Sequência de transições |
|--------------|------------------------|
| Documentário padrão | Ken Burns → Crossfade → Pan → Ken Burns → Fade |
| Mistério/suspense | Zoom In → Fade → Ken Burns lento → Zoom In |
| Batalha/épico | Pan rápido → Crossfade → Zoom In → Crossfade |
| Lore/paisagem | Ken Burns → Pan → Crossfade → Ken Burns |

## Regras

- Jamais usar mais de 2 tipos de transição diferentes em sequência
- Transições nunca devem ser o foco — são suportes visuais
- Duração máxima de transição: 1 segundo
- Manter consistência dentro de um mesmo vídeo
