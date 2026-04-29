#!/usr/bin/env python3
"""
generate-subtitles.py — Gera legendas sincronizadas com narração
Uso: python3 generate-subtitles.py <narracao.txt> <narracao.mp3> [--output subtitles.srt] [--style karaoke|phrase]

Requer: whisper (pip install openai-whisper) ou whisper-timestamped
"""
import argparse
import re
import sys

def parse_args():
    parser = argparse.ArgumentParser(description="Gera legendas SRT a partir de narração")
    parser.add_argument("text_file", help="Arquivo de texto da narração (.txt)")
    parser.add_argument("audio_file", help="Arquivo de áudio da narração (.mp3)")
    parser.add_argument("--output", "-o", default="subtitles.srt", help="Arquivo SRT de saída")
    parser.add_argument("--style", choices=["karaoke", "phrase"], default="karaoke")
    parser.add_argument("--whisper-model", default="tiny", help="Modelo Whisper (tiny, base, small)")
    return parser.parse_args()

def clean_text(text: str) -> str:
    """Remove marcas de formatação do script de narração."""
    text = re.sub(r'\*\*(.+?)\*\*', r'\1', text)  # Bold
    text = re.sub(r'\*(.+?)\*', r'\1', text)       # Italic
    text = re.sub(r'\[PAUSA DRAMÁTICA\]', '', text)
    text = re.sub(r'\s+', ' ', text).strip()
    return text

def highlight_elvish_words(word: str) -> str:
    """Destaca termos élficos e nomes próprios em dourado."""
    elvish_terms = [
        "Valinor", "Taniquetil", "Mandos", "Varda", "Manwë", "Ulmo",
        "Aulë", "Yavanna", "Oromë", "Námo", "Irmo", "Nienna",
        "Lothlórien", "Rivendell", "Fangorn", "Isengard", "Mordor",
        "Gondor", "Rohan", "Arda", "Eä", "Ilúvatar", "Eru",
    ]
    tolkien_names = [
        "Tolkien", "Gandalf", "Sauron", "Frodo", "Aragorn", "Legolas",
        "Gimli", "Boromir", "Faramir", "Sam", "Merry", "Pippin",
        "Bilbo", "Galadriel", "Elrond", "Arwen", "Saruman",
        "Radagast", "Treebeard", "Tom Bombadil", "Gollum",
        "Isildur", "Anárion", "Elendil", "Gil-galad",
    ]
    if word.strip(".,!?;:") in elvish_terms + tolkien_names:
        return f'<font color="#C9A84C">{word}</font>'
    return word

def generate_karaoke_srt(segments, output_file):
    """Gera SRT no estilo karaoke (palavra por palavra)."""
    with open(output_file, 'w', encoding='utf-8') as f:
        idx = 1
        for seg in segments:
            words = seg['text'].strip().split()
            word_count = len(words)
            if word_count == 0:
                continue
            word_dur = (seg['end'] - seg['start']) / word_count
            
            for i, word in enumerate(words):
                start = seg['start'] + (i * word_dur)
                end = start + word_dur
                highlighted = highlight_elvish_words(word)
                
                f.write(f"{idx}\n")
                f.write(f"{format_timestamp(start)} --> {format_timestamp(end)}\n")
                f.write(f"{highlighted}\n")
                f.write("\n")
                idx += 1

def generate_phrase_srt(segments, output_file):
    """Gera SRT no estilo frase por frase."""
    with open(output_file, 'w', encoding='utf-8') as f:
        idx = 1
        current_phrase = ""
        phrase_start = 0
        
        for seg in segments:
            text = seg['text'].strip()
            if not current_phrase:
                phrase_start = seg['start']
            
            current_phrase += " " + text if current_phrase else text
            
            if text.endswith(('.', '!', '?', ':')):
                f.write(f"{idx}\n")
                f.write(f"{format_timestamp(phrase_start)} --> {format_timestamp(seg['end'])}\n")
                f.write(f"{current_phrase}\n")
                f.write("\n")
                idx += 1
                current_phrase = ""

def format_timestamp(seconds):
    hours = int(seconds // 3600)
    minutes = int((seconds % 3600) // 60)
    secs = int(seconds % 60)
    millis = int((seconds % 1) * 1000)
    return f"{hours:02d}:{minutes:02d}:{secs:02d},{millis:03d}"

def main():
    args = parse_args()
    
    # Ler texto de referência
    with open(args.text_file, 'r', encoding='utf-8') as f:
        reference_text = clean_text(f.read())
    
    print(f"📝 Texto de referência: {len(reference_text)} caracteres")
    print(f"🎙  Áudio: {args.audio_file}")
    print(f"🎨 Estilo: {args.style}")
    
    # Tentar usar Whisper para transcrição com timestamps
    try:
        import whisper
        print(f"🔊 Carregando modelo Whisper ({args.whisper_model})...")
        model = whisper.load_model(args.whisper_model)
        result = model.transcribe(args.audio_file, language="pt")
        segments = [{"start": s["start"], "end": s["end"], "text": s["text"]} for s in result["segments"]]
        print(f"✅ {len(segments)} segmentos transcritos")
    except ImportError:
        print("⚠️  Whisper não disponível. Use install-whisper skill para instalar.")
        print("   Gerando SRT simulado (timestamps estimados)...")
        words = reference_text.split()
        seg_dur = 2.0
        segments = []
        for i in range(0, len(words), 8):
            chunk = " ".join(words[i:i+8])
            start = i * (seg_dur / 8)
            segments.append({"start": start, "end": start + seg_dur, "text": chunk})
    
    if args.style == "karaoke":
        generate_karaoke_srt(segments, args.output)
    else:
        generate_phrase_srt(segments, args.output)
    
    print(f"✅ Legendas salvas em: {args.output}")

if __name__ == "__main__":
    main()
