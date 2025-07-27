#!/bin/bash

# =============================================================================
# SCRIPT DE SETUP PARA DESENVOLVIMENTO - DBT PROJECT
# =============================================================================

set -e  # Parar execução se houver erro

echo "🚀 Configurando ambiente de desenvolvimento para projeto dbt..."

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para log
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# =============================================================================
# 1. VERIFICAR PRÉ-REQUISITOS
# =============================================================================

log_info "Verificando pré-requisitos..."

# Verificar Python
if ! command -v python3 &> /dev/null; then
    log_error "Python 3 não encontrado. Instale Python 3.8+ antes de continuar."
    exit 1
fi

# Verificar pip
if ! command -v pip3 &> /dev/null; then
    log_error "pip3 não encontrado. Instale pip antes de continuar."
    exit 1
fi

# Verificar git
if ! command -v git &> /dev/null; then
    log_error "Git não encontrado. Instale git antes de continuar."
    exit 1
fi

log_success "Pré-requisitos verificados"

# =============================================================================
# 2. CONFIGURAR AMBIENTE VIRTUAL
# =============================================================================

log_info "Configurando ambiente virtual..."

if [ ! -d ".venv" ]; then
    log_info "Criando ambiente virtual..."
    python3 -m venv .venv
    log_success "Ambiente virtual criado"
else
    log_info "Ambiente virtual já existe"
fi

# Ativar ambiente virtual
source .venv/bin/activate
log_success "Ambiente virtual ativado"

# =============================================================================
# 3. INSTALAR DEPENDÊNCIAS
# =============================================================================

log_info "Instalando dependências de desenvolvimento..."

# Atualizar pip
pip install --upgrade pip

# Instalar dependências básicas
if [ -f "requirements-dev.txt" ]; then
    pip install -r requirements-dev.txt
    log_success "Dependências de desenvolvimento instaladas"
else
    log_warning "Arquivo requirements-dev.txt não encontrado, instalando dependências básicas..."
    pip install dbt-bigquery pre-commit sqlfluff yamllint
fi

# =============================================================================
# 4. CONFIGURAR PRE-COMMIT
# =============================================================================

log_info "Configurando pre-commit hooks..."

if [ -f ".pre-commit-config.yaml" ]; then
    # Instalar hooks
    pre-commit install
    log_success "Pre-commit hooks instalados"
    
    # Executar em todos os arquivos pela primeira vez
    log_info "Executando pre-commit em todos os arquivos..."
    pre-commit run --all-files || {
        log_warning "Alguns hooks falharam. Isso é normal na primeira execução."
        log_info "Execute 'pre-commit run --all-files' novamente após corrigir os problemas."
    }
else
    log_warning "Arquivo .pre-commit-config.yaml não encontrado"
fi

# =============================================================================
# 5. CONFIGURAR GIT (SE NECESSÁRIO)
# =============================================================================

log_info "Verificando configuração do Git..."

if [ ! -d ".git" ]; then
    log_info "Inicializando repositório Git..."
    git init
    git add .
    git commit -m "Initial commit: dbt project setup with dev tools"
    log_success "Repositório Git inicializado"
else
    log_info "Repositório Git já existe"
fi

# =============================================================================
# 6. VERIFICAR CONFIGURAÇÃO DBT
# =============================================================================

log_info "Verificando configuração do dbt..."

cd dbt_core

if [ -f "profiles.yml" ]; then
    log_info "Testando conexão com dbt..."
    dbt debug || {
        log_warning "Teste de conexão falhou. Verifique suas credenciais."
    }
else
    log_warning "Arquivo profiles.yml não encontrado"
fi

cd ..

# =============================================================================
# 7. CRIAR ARQUIVOS DE EXEMPLO (SE NECESSÁRIO)
# =============================================================================

log_info "Verificando arquivos de configuração..."

# Criar .env.example se não existir
if [ ! -f ".env.example" ]; then
    log_info "Criando arquivo .env.example..."
    cat > .env.example << EOF
# =============================================================================
# ENVIRONMENT VARIABLES - DBT PROJECT
# =============================================================================

# Google Cloud Configuration
GOOGLE_APPLICATION_CREDENTIALS=path/to/your/service-account-key.json
GCP_PROJECT_ID=your-project-id

# DBT Configuration
DBT_PROFILES_DIR=./dbt_core
DBT_TARGET=dev

# BigQuery Configuration
BQ_DATASET=your_dataset_name
BQ_LOCATION=us-central1

# Development Configuration
DBT_LOG_LEVEL=info
DBT_PARTIAL_PARSE=true
EOF
    log_success "Arquivo .env.example criado"
fi

# =============================================================================
# 8. RESUMO FINAL
# =============================================================================

echo ""
echo "================================================================================"
echo -e "${GREEN}🎉 SETUP CONCLUÍDO COM SUCESSO!${NC}"
echo "================================================================================"
echo ""
echo -e "${BLUE}Próximos passos:${NC}"
echo ""
echo "1. 📝 Configure suas credenciais:"
echo "   - Copie seu service account key para o projeto"
echo "   - Atualize dbt_core/profiles.yml se necessário"
echo ""
echo "2. 🧪 Teste o projeto:"
echo "   cd dbt_core"
echo "   dbt debug"
echo "   dbt run"
echo "   dbt test"
echo ""
echo "3. 🔍 Comandos úteis de desenvolvimento:"
echo "   pre-commit run --all-files  # Executar todos os hooks"
echo "   sqlfluff lint dbt_core/     # Lint SQL files"
echo "   dbt docs generate && dbt docs serve  # Documentação"
echo ""
echo "4. 📚 Estrutura do projeto:"
echo "   ├── dbt_core/               # Projeto dbt principal"
echo "   ├── .pre-commit-config.yaml # Configuração dos hooks"
echo "   ├── .sqlfluff               # Configuração SQL linting"
echo "   ├── .yamllint.yml           # Configuração YAML linting"
echo "   └── requirements-dev.txt    # Dependências de desenvolvimento"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
echo "" 