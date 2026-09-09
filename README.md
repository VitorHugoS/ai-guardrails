# AI Guardrails CLI

O **AI Guardrails** é um facilitador CLI (Command Line Interface) leve e modular, projetado para simplificar e validar a execução de tarefas tanto para desenvolvedores quanto para assistentes de Inteligência Artificial. 

Escrito em **Bash** com foco em zero dependências, o projeto permite criar fluxos de validação rápidos e estruturados.

## 🚀 Como instalar (Uso Global)

Para facilitar o uso por você e pela IA, você pode instalar o script globalmente. Isso permite que você digite `ai ...` em qualquer diretório.

Clone o repositório e execute o script de instalação:

```bash
git clone https://github.com/VitorHugoS/ai-guardrails.git
cd ai-guardrails
./install.sh
```

*(O script criará um link simbólico do executável `ai` no seu diretório `~/.local/bin`)*

**Certifique-se de que `~/.local/bin` está no seu `PATH`:**
```bash
# Adicione isso ao seu ~/.bashrc ou ~/.zshrc se já não estiver:
export PATH="$HOME/.local/bin:$PATH"
```

## 🛠 Como Usar

A estrutura de uso segue o formato:
`ai <modulo> <comando> [argumentos]`

### Exemplos:

- **Java**: Validar e compilar um projeto Maven.
  `ai java finish-task`
- **Java (Parsers)**: Extrair contexto enxuto de relatórios (JaCoCo e PITest).
  `ai java summary jacoco`
  `ai java summary pitest`
- **Python**: Rodar validações em um projeto Python.
  `ai python finish-task`
- **Ambiente**: Checar o diretório atual e status do Git.
  `ai common check-cd`

## 📁 Arquitetura de Módulos

O projeto usa roteamento baseado em arquivos para ser extremamente extensível. Cada pasta dentro de `modules/` é tratada como um **módulo**, e cada script `.sh` dentro dessa pasta é um **comando**.

```text
.
├── ai                          # CLI principal (ponto de entrada)
├── install.sh                  # Script para instalação global
└── modules/
    ├── common/                 # Módulo: common
    │   └── check-cd.sh         # Comando: ai common check-cd
    ├── java/                   # Módulo: java
    │   └── finish-task.sh      # Comando: ai java finish-task
    └── python/                 # Módulo: python
        └── finish-task.sh      # Comando: ai python finish-task
```

### Como criar um novo módulo/comando?

1. Crie uma pasta para o novo módulo dentro de `modules/` (ex: `modules/docker/`).
2. Crie um arquivo Bash `.sh` com o nome do comando (ex: `modules/docker/limpar.sh`).
3. Dê permissão de execução ao seu script: `chmod +x modules/docker/limpar.sh`.
4. Pronto! O comando já estará disponível executando `ai docker limpar`.

## 🤖 Interação com a Inteligência Artificial

- **Logs Detalhados:** A saída dos comandos é impressa diretamente no terminal (`stdout`/`stderr`). Isso fornece o contexto completo de compilação ou execução que a IA precisa para ler e corrigir problemas.
- **Fail-Fast (Exit Codes):** Todos os scripts (`task-finish`, etc) emitem exit codes corretos (`exit 0` para sucesso, `exit 1` para falha). Se o código falhar, o processo alerta a IA imediatamente para corrigir o erro antes de declarar a tarefa como pronta.
