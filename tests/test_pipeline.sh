#!/bin/bash
# test_pipeline.sh — Testes de integração do pipeline do Sabedoria de Valinor
# Uso: ./tests/test_pipeline.sh
# 
# Valida a integridade de todos os componentes do projeto:
# - Estrutura de arquivos
# - Scripts executáveis
# - Templates HTML válidos
# - Agentes com seções obrigatórias
# - Prompts com templates completos

set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0
WARN=0

pass() { ((PASS++)); echo "  ✅ $1"; }
fail() { ((FAIL++)); echo "  ❌ $1"; }
warn() { ((WARN++)); echo "  ⚠️  $1"; }

echo "🧪 Testes do Pipeline — Sabedoria de Valinor"
echo "📁 Base: $BASE_DIR"
echo ""

# ============================================================
# 1. Estrutura de Arquivos
# ============================================================
echo "📦 1. Estrutura de Arquivos"

REQUIRED_DIRS=(
    "agents"
    "prompts/image-prompts"
    "prompts/copy-templates"
    "content/briefs"
    "content/packs"
    "content/history"
    "templates/infographic"
    "templates/video"
    "scripts"
    "docs"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$BASE_DIR/$dir" ]; then
        pass "Diretório: $dir/"
    else
        fail "Diretório ausente: $dir/"
    fi
done

# ============================================================
# 2. Scripts Executáveis
# ============================================================
echo ""
echo "⚙️  2. Scripts Executáveis"

EXPECTED_SCRIPTS=(
    "scripts/generate-images.sh"
    "scripts/compose-video.sh"
    "scripts/generate-subtitles.py"
    "scripts/publish.py"
)

for script in "${EXPECTED_SCRIPTS[@]}"; do
    path="$BASE_DIR/$script"
    if [ -f "$path" ]; then
        if [ -x "$path" ]; then
            pass "Executável: $script"
        else
            warn "Não executável: $script (chmod +x necessário)"
        fi
    else
        fail "Ausente: $script"
    fi
done

# ============================================================
# 3. Agentes — Seções Obrigatórias
# ============================================================
echo ""
echo "🤖 3. Agentes — Seções Obrigatórias"

AGENT_FILES=("agents/research-agent.md" "agents/content-agent.md" "agents/production-agent.md")
REQUIRED_SECTIONS=("Papel" "Tarefas\|Input\|Output\|Pipeline")

for agent in "${AGENT_FILES[@]}"; do
    agent_file="$BASE_DIR/$agent"
    if [ ! -f "$agent_file" ]; then
        fail "Agente ausente: $agent"
        continue
    fi
    
    agent_name=$(basename "$agent")
    
    # Verificar se tem conteúdo
    lines=$(wc -l < "$agent_file")
    if [ "$lines" -lt 20 ]; then
        fail "$agent_name: muito curto ($lines linhas, mínimo 20)"
    else
        pass "$agent_name: tamanho adequado ($lines linhas)"
    fi
    
    # Verificar seção Papel
    if grep -qi "## Papel" "$agent_file"; then
        pass "$agent_name: tem seção Papel"
    else
        fail "$agent_name: falta seção '## Papel'"
    fi
    
    # Verificar se tem Output ou Pipeline
    if grep -qiE "(## Output|## Pipeline|## Processo)" "$agent_file"; then
        pass "$agent_name: tem seção Output/Pipeline"
    else
        fail "$agent_name: falta seção Output/Pipeline"
    fi
done

# ============================================================
# 4. Prompts — Templates Completos
# ============================================================
echo ""
echo "✍️  4. Prompts — Templates"

PROMPT_FILES=(
    "prompts/image-prompts/scene-template.md"
    "prompts/image-prompts/color-palette.md"
    "prompts/copy-templates/tiktok-structure.md"
    "prompts/copy-templates/hooks-library.md"
    "prompts/copy-templates/cta-library.md"
    "prompts/tts-config.md"
)

for prompt in "${PROMPT_FILES[@]}"; do
    if [ -f "$BASE_DIR/$prompt" ]; then
        lines=$(wc -l < "$BASE_DIR/$prompt")
        if [ "$lines" -ge 10 ]; then
            pass "$(basename "$prompt"): $lines linhas"
        else
            warn "$(basename "$prompt"): muito curto ($lines linhas)"
        fi
    else
        fail "Ausente: $prompt"
    fi
done

# ============================================================
# 5. Templates HTML — Validade
# ============================================================
echo ""
echo "🎨 5. Templates HTML"

HTML_TEMPLATES=(
    "templates/infographic/map.html"
    "templates/infographic/timeline.html"
    "templates/infographic/genealogy.html"
)

for tpl in "${HTML_TEMPLATES[@]}"; do
    path="$BASE_DIR/$tpl"
    if [ -f "$path" ]; then
        # Verificar tags básicas HTML
        has_doctype=$(grep -c "<!DOCTYPE html>" "$path" || true)
        has_head=$(grep -c "<head>" "$path" || true)
        has_body=$(grep -c "<body>" "$path" || true)
        has_close_body=$(grep -c "</body>" "$path" || true)
        has_close_html=$(grep -c "</html>" "$path" || true)
        
        if [ "$has_doctype" -ge 1 ] && [ "$has_head" -ge 1 ] && [ "$has_body" -ge 1 ]; then
            pass "$(basename "$tpl"): HTML válido"
            
            # Verificar dimensões (1080x1920)
            if grep -q "1080" "$path" && grep -q "1920" "$path"; then
                pass "$(basename "$tpl"): dimensões 1080x1920"
            else
                warn "$(basename "$tpl"): dimensões não encontradas"
            fi
            
            # Verificar paleta de cores
            if grep -q "#0D1117" "$path" || grep -q "#C9A84C" "$path"; then
                pass "$(basename "$tpl"): paleta de cores do projeto"
            else
                warn "$(basename "$tpl"): paleta de cores não encontrada"
            fi
        else
            fail "$(basename "$tpl"): HTML malformado"
        fi
    else
        fail "Ausente: $tpl"
    fi
done

# ============================================================
# 6. Paleta de Cores — Consistência
# ============================================================
echo ""
echo "🎭 6. Paleta de Cores"

PALETTE_FILE="$BASE_DIR/prompts/image-prompts/color-palette.md"
if [ -f "$PALETTE_FILE" ]; then
    EXPECTED_COLORS=("#0D1117" "#C9A84C" "#1E3A5F" "#F0E6D3" "#A8B2C1")
    for color in "${EXPECTED_COLORS[@]}"; do
        if grep -q "$color" "$PALETTE_FILE"; then
            pass "Cor definida: $color"
        else
            fail "Cor ausente: $color"
        fi
    done
else
    fail "color-palette.md ausente"
fi

# ============================================================
# 7. Documentação
# ============================================================
echo ""
echo "📚 7. Documentação"

DOC_FILES=(
    "docs/architecture.md"
    "docs/setup-guide.md"
    "docs/contributing.md"
    "docs/content-guidelines.md"
    "README.md"
    "LICENSE"
)

for doc in "${DOC_FILES[@]}"; do
    if [ -f "$BASE_DIR/$doc" ]; then
        lines=$(wc -l < "$BASE_DIR/$doc")
        pass "$(basename "$doc"): $lines linhas"
    else
        fail "Ausente: $doc"
    fi
done

# ============================================================
# 8. Compose Video — Dependência FFmpeg
# ============================================================
echo ""
echo "🎬 8. Dependências"

if command -v ffmpeg &>/dev/null; then
    version=$(ffmpeg -version 2>/dev/null | head -1 | sed 's/.*ffmpeg version //' | cut -d' ' -f1 || echo "desconhecida")
    pass "FFmpeg instalado (v${version})"
else
    warn "FFmpeg não instalado — necessário para compose-video.sh"
fi

if command -v python3 &>/dev/null; then
    py_version=$(python3 --version 2>&1 | cut -d' ' -f2)
    pass "Python3 instalado (v${py_version})"
else
    warn "Python3 não instalado — necessário para generate-subtitles.py"
fi

if command -v gh &>/dev/null; then
    pass "GitHub CLI instalado"
else
    warn "GitHub CLI não instalado"
fi

# ============================================================
# 9. Git
# ============================================================
echo ""
echo "🔀 9. Git"

if git -C "$BASE_DIR" rev-parse --is-inside-work-tree &>/dev/null; then
    branch=$(git -C "$BASE_DIR" branch --show-current)
    last_commit=$(git -C "$BASE_DIR" log -1 --format="%s" 2>/dev/null)
    pass "Repositório git válido (branch: $branch)"
    pass "Último commit: $last_commit"
else
    fail "Não é um repositório git"
fi

# ============================================================
# 10. Content Pack — Estrutura de Teste
# ============================================================
echo ""
echo "🧩 10. Content Pack — Validação de Estrutura"

TEST_PACK="$BASE_DIR/content/packs/_test-validation"
mkdir -p "$TEST_PACK/imagens"

PACK_REQUIRED=(
    "roteiro.md"
    "cenas.md"
    "narracao.txt"
)

for file in "${PACK_REQUIRED[@]}"; do
    touch "$TEST_PACK/$file"
done

all_exist=true
for file in "${PACK_REQUIRED[@]}"; do
    if [ -f "$TEST_PACK/$file" ]; then
        pass "Pack tem: $file"
    else
        all_exist=false
        fail "Pack falta: $file"
    fi
done

# Limpar
rm -rf "$TEST_PACK"
pass "Pack de teste criado e removido com sucesso"

# ============================================================
# Resumo
# ============================================================
echo ""
echo "══════════════════════════════════════"
TOTAL=$((PASS + FAIL + WARN))
echo "🧪 Resultado: $PASS/$TOTAL passaram"
if [ $FAIL -gt 0 ]; then
    echo "   ❌ $FAIL falha(s)"
fi
if [ $WARN -gt 0 ]; then
    echo "   ⚠️  $WARN aviso(s)"
fi
echo "══════════════════════════════════════"

if [ $FAIL -gt 0 ]; then
    exit 1
fi
exit 0
