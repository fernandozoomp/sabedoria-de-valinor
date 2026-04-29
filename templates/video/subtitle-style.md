# Estilo de Legendas — Sabedoria de Valinor

## Estilo Principal: Karaoke (Palavra-por-palavra)

Legendas que aparecem palavra por palavra, sincronizadas com a narração. Este é o estilo mais engajante para TikTok.

## Especificações

| Propriedade | Valor |
|-------------|-------|
| Fonte | Montserrat Bold ou Impact |
| Tamanho | 72px |
| Cor do texto | #FFFFFF (branco) |
| Contorno | #000000 (preto), 4px |
| Sombra | #000000, 2px offset, blur 4px |
| Posição | Centro inferior, 15% do fundo |
| Cor de destaque | #C9A84C (palavra atual) |
| Animação entrada | Scale 0.8 → 1.0 (0.1s ease-out) |

## Formato SRT

```
1
00:00:00,000 --> 00:00:00,500
Imagine
<00:00:00,000><c.c2>Imagine</c>

2
00:00:00,500 --> 00:00:01,000
se
<00:00:00,500>se

3
00:00:01,000 --> 00:00:01,800
os
<00:00:01,000>os

4
00:00:01,800 --> 00:00:02,500
<font color="#C9A84C">guardiões</font>
<00:00:01,800><c.c2>guardiões</c>
```

## Regras

- Uma palavra por linha idealmente (karaoke)
- Máximo 2 palavras por linha em frases rápidas
- Quebra de linha natural (não cortar palavras)
- Nomes próprios e termos élficos sempre com cor dourada (#C9A84C)
- Números destacados em dourado
- Pausas narrativas (silêncio) = sem legenda na tela

## Estilo Alternativo: Frase-por-Frase

Para produção mais rápida, legenda aparece frase completa:

| Propriedade | Valor |
|-------------|-------|
| Fonte | Montserrat ExtraBold |
| Tamanho | 64px |
| Duração na tela | sincronizada com a frase narrada |
| Animação | Slide up + fade in |
