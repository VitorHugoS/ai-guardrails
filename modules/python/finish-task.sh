#!/bin/bash

echo "======================================================"
echo "🐍 INICIANDO GUARDRAIL DE VALIDAÇÃO PYTHON (TASK-FINISH)"
echo "======================================================"

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -n "$PROJECT_ROOT" ]; then
  cd "$PROJECT_ROOT"
fi

echo "--> Executando testes (pytest)..."
# Exemplo de comando Python
pytest -q

BUILD_STATUS=$?

if [ $BUILD_STATUS -ne 0 ]; then
    echo ""
    echo "======================================================"
    echo "❌ FALHA NA VALIDAÇÃO DO GUARDRAIL PYTHON!"
    echo "[INSTRUÇÃO PARA A IA]: Os testes falharam. Corrija o código"
    echo "e execute o comando 'ai python finish-task' novamente."
    echo "======================================================"
    exit 1
fi

echo ""
echo "======================================================"
echo "✅ GUARDRAIL PYTHON APROVADO! Todos os testes passaram."
echo "======================================================"
exit 0
