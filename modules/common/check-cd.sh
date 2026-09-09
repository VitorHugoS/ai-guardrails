#!/bin/bash

echo "======================================================"
echo "🔍 VERIFICANDO AMBIENTE (CHECK-CD)"
echo "======================================================"

echo "Diretório atual: $(pwd)"
echo "Versão do Git:"
git --version || echo "Git não instalado!"

# Pode-se adicionar validações como verificar se estamos na raiz de um repo git
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "⚠️  Aviso: Não estamos em um repositório Git."
else
    echo "✅ Repositório Git detectado."
    echo "Branch atual: $(git branch --show-current)"
fi

echo "======================================================"
