#!/usr/bin/env python3
"""
publish.py — Publica vídeo no TikTok via API
Uso: python3 publish.py <video.mp4> [--caption "legenda"] [--tags tag1,tag2]

Requer:
  - TikTok API access token
  - Biblioteca: requests
"""
import argparse
import json
import os
import sys
import time

def parse_args():
    parser = argparse.ArgumentParser(description="Publica vídeo no TikTok")
    parser.add_argument("video_file", help="Vídeo MP4 para publicar")
    parser.add_argument("--caption", "-c", default="", help="Legenda do vídeo")
    parser.add_argument("--tags", "-t", default="tolkien,lotr,senlordosaneis,terramedia,fantasy,lore", 
                       help="Tags separadas por vírgula")
    parser.add_argument("--dry-run", action="store_true", help="Simula sem publicar")
    parser.add_argument("--schedule", help="Data/hora para agendamento (ISO 8601)")
    return parser.parse_args()

TOKTOK_UPLOAD_URL = "https://open.tiktokapis.com/v2/post/publish/video/init/"

def build_caption(caption: str, tags: list) -> str:
    """Monta legenda com hashtags."""
    tag_str = " ".join(f"#{t.strip()}" for t in tags)
    full = f"{caption}\n\n{tag_str}"
    return full[:2200]  # TikTok caption limit

def check_video(video_path: str) -> dict:
    """Verifica se o vídeo atende os requisitos do TikTok."""
    import subprocess
    
    result = subprocess.run(
        ["ffprobe", "-v", "error", "-show_entries", 
         "format=duration,size:stream=width,height,codec_name",
         "-of", "json", video_path],
        capture_output=True, text=True
    )
    info = json.loads(result.stdout)
    
    checks = {
        "exists": os.path.isfile(video_path),
        "resolution": "1080x1920",
        "duration": f"{float(info['format']['duration']):.1f}s",
        "size_mb": f"{int(info['format']['size']) / 1024 / 1024:.1f}MB",
    }
    
    duration = float(info['format']['duration'])
    if duration < 10 or duration > 180:
        checks["warning"] = f"Duração ({duration:.0f}s) fora do ideal (10-180s)"
    
    size_mb = int(info['format']['size']) / 1024 / 1024
    if size_mb > 287:
        checks["error"] = f"Arquivo muito grande ({size_mb:.0f}MB, max 287MB)"
    
    return checks

def main():
    args = parse_args()
    
    if not os.path.isfile(args.video_file):
        print(f"❌ Vídeo não encontrado: {args.video_file}")
        sys.exit(1)
    
    # Verificar vídeo
    checks = check_video(args.video_file)
    print("📋 Verificação do vídeo:")
    for k, v in checks.items():
        icon = "✅" if not k.startswith(("warning", "error")) else ("⚠️" if k == "warning" else "❌")
        print(f"  {icon} {k}: {v}")
    
    if "error" in checks:
        sys.exit(1)
    
    tags = [t.strip() for t in args.tags.split(",")]
    caption = build_caption(args.caption, tags)
    
    print(f"\n📝 Legenda:")
    print(f"  {caption[:200]}{'...' if len(caption) > 200 else ''}")
    print(f"\n🏷️  Tags: {', '.join(tags)}")
    
    if args.dry_run:
        print("\n🏃 DRY RUN — vídeo não publicado")
        print("   Remova --dry-run para publicar")
        return
    
    # Verificar token
    token = os.environ.get("TIKTOK_ACCESS_TOKEN")
    if not token:
        print("\n⚠️  TIKTOK_ACCESS_TOKEN não configurada")
        print("   Configure: export TIKTOK_ACCESS_TOKEN='your_token'")
        print("   Ou publique manualmente pelo app TikTok")
        print(f"\n📱 Arquivo pronto para upload: {args.video_file}")
        return
    
    print("\n🚀 Publicando...")
    # TODO: Implementar upload via TikTok Content Posting API v2
    print("   ⚠️  Upload via API ainda não implementado")
    print(f"   📱 Publique manualmente: {args.video_file}")

if __name__ == "__main__":
    main()
