#!/bin/bash

# Verifica se o tipo de relatório foi passado
if [ -z "$1" ]; then
    echo "Uso: ai java summary <jacoco|pitest>"
    exit 1
fi

TYPE=$1

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -n "$PROJECT_ROOT" ]; then
  cd "$PROJECT_ROOT"
fi

if [ "$TYPE" == "jacoco" ]; then
    FILE="target/site/jacoco/jacoco.xml"
    if [ ! -f "$FILE" ]; then
        echo "❌ Arquivo não encontrado: $FILE (Você executou o build com o JaCoCo?)"
        exit 1
    fi
    echo "🔍 Analisando relatório JaCoCo..."
    
    # Utiliza Python embutido (biblioteca padrão) para parsear o XML com robustez (Zero Dependências externas)
    python3 -c '
import xml.etree.ElementTree as ET
import sys
import os

filepath = "'$FILE'"
try:
    tree = ET.parse(filepath)
    root = tree.getroot()
    fail_count = 0
    
    for pkg in root.findall("package"):
        for src in pkg.findall("sourcefile"):
            filename = src.get("name")
            for line in src.findall("line"):
                mi = int(line.get("mi", "0"))
                mb = int(line.get("mb", "0"))
                
                if mi > 0 or mb > 0:
                    ln = line.get("nr")
                    reason = []
                    if mb > 0:
                        reason.append(f"Branch parcialmente testado: mb={mb}")
                    if mi > 0:
                        reason.append(f"Linha não executada: mi={mi}")
                    
                    print(f"[JACOCO FAIL] {filename}: Line {ln} ({str.join(\", \", reason)})")
                    fail_count += 1
                    
    if fail_count == 0:
        print("✅ JACOCO PASS: Nenhuma linha ou branch descoberta encontrada.")
    else:
        print(f"❌ {fail_count} falha(s) de cobertura encontradas.")
        sys.exit(1)
        
except Exception as e:
    print(f"Erro ao analisar {filepath}: {e}")
    sys.exit(1)
'
    exit $?

elif [ "$TYPE" == "pitest" ]; then
    # O PITest costuma gerar pastas com timestamp ou na raiz dependendo da configuração.
    # Vamos buscar o arquivo mutations.xml mais recente.
    if [ ! -d "target/pit-reports" ]; then
        echo "❌ Diretório target/pit-reports não encontrado. (Você executou o build com PITest?)"
        exit 1
    fi
    
    FILE=$(find target/pit-reports -name "mutations.xml" | sort -r | head -n 1)
    
    if [ -z "$FILE" ]; then
        echo "❌ Arquivo mutations.xml não encontrado em target/pit-reports."
        echo "Certifique-se de que o <outputFormats><value>XML</value></outputFormats> está configurado no pom.xml."
        exit 1
    fi
    
    echo "🔍 Analisando relatório PITest ($FILE)..."
    
    python3 -c '
import xml.etree.ElementTree as ET
import sys

filepath = "'$FILE'"
try:
    tree = ET.parse(filepath)
    root = tree.getroot()
    survived_count = 0
    
    for mutation in root.findall("mutation"):
        status = mutation.get("status")
        if status == "SURVIVED":
            source_file = mutation.findtext("sourceFile", "UnknownFile")
            line_number = mutation.findtext("lineNumber", "?")
            mutated_method = mutation.findtext("mutatedMethod", "UnknownMethod")
            mutator = mutation.findtext("mutator", "UnknownMutator")
            
            # Remove o pacote do mutator para ficar enxuto (ex: org.pitest.mutationtest.engine.gregor.mutators.MathMutator -> MathMutator)
            mutator_short = mutator.split(".")[-1]
            
            print(f"[PITEST SURVIVED] {source_file}: Line {line_number} - Method: {mutated_method}() - Mutator: {mutator_short}")
            survived_count += 1
            
    if survived_count == 0:
        print("✅ PIT PASS: Nenhum mutante sobreviveu.")
    else:
        print(f"❌ {survived_count} mutante(s) sobreviveram.")
        sys.exit(1)
        
except Exception as e:
    print(f"Erro ao analisar {filepath}: {e}")
    sys.exit(1)
'
    exit $?

else
    echo "❌ Tipo desconhecido: $TYPE. Use 'jacoco' ou 'pitest'."
    exit 1
fi
