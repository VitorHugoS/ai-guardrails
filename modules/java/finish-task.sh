#!/bin/bash

echo "======================================================"
echo "🛡️ INICIANDO GUARDRAIL DE VALIDAÇÃO (TASK-FINISH)"
echo "======================================================"

# Garante que o comando rode na raiz do projeto (evita que a IA rode na pasta errada)
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -n "$PROJECT_ROOT" ]; then
  cd "$PROJECT_ROOT"
fi

echo "--> Executando compilação e testes (Maven)..."
# A flag -B (Batch mode) previne logs interativos que podem confundir a IA
mvn clean install -B

# Captura o código de saída do Maven (0 = sucesso, diferente de 0 = erro)
BUILD_STATUS=$?

if [ $BUILD_STATUS -ne 0 ]; then
    echo ""
    echo "======================================================"
    echo "❌ FALHA NA VALIDAÇÃO DO GUARDRAIL!"
    echo "[INSTRUÇÃO PARA A IA]: O build ou os testes falharam."
    echo "Analise o stack trace acima, identifique o problema, corrija o"
    echo "código-fonte e execute o comando 'task-finish' novamente."
    echo "NÃO declare a tarefa como concluída até obter sucesso (exit 0)."
    echo "======================================================"
    exit 1
fi

echo ""
echo "======================================================"
echo "✅ GUARDRAIL APROVADO! Todos os testes passaram."
echo "O código está pronto e validado."
echo "======================================================"
exit 0
