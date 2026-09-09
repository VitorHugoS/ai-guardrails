#!/bin/bash

echo "======================================================"
echo "🚀 Instalando o AI Guardrails CLI globalmente..."
echo "======================================================"

INSTALL_DIR="$HOME/.local/bin"
AI_EXECUTABLE="$(pwd)/ai"

# Cria o diretório de destino se não existir
mkdir -p "$INSTALL_DIR"

# Cria o symlink (link simbólico)
ln -sf "$AI_EXECUTABLE" "$INSTALL_DIR/ai"

echo "✅ Instalado com sucesso!"
echo "📍 Caminho do link: $INSTALL_DIR/ai -> $AI_EXECUTABLE"
echo ""
echo "⚠️  IMPORTANTE:"
echo "Certifique-se de que '$INSTALL_DIR' está no seu PATH."
echo "Você pode adicionar a seguinte linha no seu ~/.bashrc ou ~/.zshrc:"
echo 'export PATH="$HOME/.local/bin:$PATH"'
echo "======================================================"
