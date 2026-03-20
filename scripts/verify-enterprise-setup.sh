#!/bin/bash
# =================================================================
# Script de Verificación - Enterprise Activation
# =================================================================
# Este script verifica que la configuración de Enterprise esté
# correctamente implementada antes de desplegar.

set -e

echo "=========================================="
echo "🔍 LiteLLM Enterprise - Verificación Local"
echo "=========================================="
echo ""

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para verificar archivos
check_file() {
    local file=$1
    local description=$2
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅${NC} $description: $file"
        return 0
    else
        echo -e "${RED}❌${NC} $description: $file (NO ENCONTRADO)"
        return 1
    fi
}

# Función para verificar contenido en archivo
check_content() {
    local file=$1
    local search=$2
    local description=$3
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌${NC} $description: Archivo no encontrado"
        return 1
    fi
    
    if grep -q "$search" "$file"; then
        echo -e "${GREEN}✅${NC} $description"
        return 0
    else
        echo -e "${RED}❌${NC} $description (NO ENCONTRADO)"
        return 1
    fi
}

echo "📁 Verificando archivos necesarios..."
echo ""

# Verificar archivos principales
FILES_OK=true

check_file "Dockerfile" "Dockerfile principal" || FILES_OK=false
check_file "docker/prod_entrypoint.sh" "Entrypoint de producción" || FILES_OK=false
check_file "docker/init-enterprise.sh" "Script de inicialización Enterprise" || FILES_OK=false
check_file "litellm/proxy/auth/litellm_license.py" "Módulo de licencias" || FILES_OK=false
check_file ".env.example" "Archivo de ejemplo .env" || FILES_OK=false

echo ""
echo "🔎 Verificando configuraciones clave..."
echo ""

# Verificar Dockerfile
CONTENT_OK=true

check_content "Dockerfile" "LITELLM_FORCE_ENTERPRISE=true" "Variable LITELLM_FORCE_ENTERPRISE en Dockerfile" || CONTENT_OK=false
check_content "Dockerfile" "init-enterprise.sh" "Referencia al script de init en Dockerfile" || CONTENT_OK=false

# Verificar prod_entrypoint.sh
check_content "docker/prod_entrypoint.sh" "run_enterprise_init" "Función run_enterprise_init en entrypoint" || CONTENT_OK=false
check_content "docker/prod_entrypoint.sh" "init-enterprise.sh" "Llamada al script de init en entrypoint" || CONTENT_OK=false

# Verificar litellm_license.py
check_content "litellm/proxy/auth/litellm_license.py" "LITELLM_FORCE_ENTERPRISE" "Lógica de FORCE_ENTERPRISE en license.py" || CONTENT_OK=false
check_content "litellm/proxy/auth/litellm_license.py" "force_enterprise" "Variable force_enterprise en is_premium()" || CONTENT_OK=false

# Verificar script de init
check_content "docker/init-enterprise.sh" "ENTERPRISE MODE ACTIVADO" "Mensaje de confirmación en init script" || CONTENT_OK=false
check_content "docker/init-enterprise.sh" "/health/license" "Verificación de endpoint license" || CONTENT_OK=false

# Verificar .env.example
check_content ".env.example" "LITELLM_FORCE_ENTERPRISE" "Variable FORCE_ENTERPRISE en .env.example" || CONTENT_OK=false

echo ""
echo "🔐 Verificando permisos de ejecución..."
echo ""

# Verificar permisos
PERMS_OK=true

if [ -x "docker/init-enterprise.sh" ]; then
    echo -e "${GREEN}✅${NC} docker/init-enterprise.sh es ejecutable"
else
    echo -e "${YELLOW}⚠️${NC}  docker/init-enterprise.sh no es ejecutable localmente"
    echo "   (Se arreglará durante el build de Docker)"
fi

if [ -x "docker/prod_entrypoint.sh" ]; then
    echo -e "${GREEN}✅${NC} docker/prod_entrypoint.sh es ejecutable"
else
    echo -e "${YELLOW}⚠️${NC}  docker/prod_entrypoint.sh no es ejecutable localmente"
    echo "   (Se arreglará durante el build de Docker)"
fi

echo ""
echo "📚 Verificando documentación..."
echo ""

DOC_OK=true

check_file "ENTERPRISE_ACTIVATION.md" "Documentación de activación Enterprise" || DOC_OK=false
check_file "DOKPLOY_ENTERPRISE_SETUP.md" "Guía de deployment en Dokploy" || DOC_OK=false

echo ""
echo "=========================================="
echo "📊 RESUMEN"
echo "=========================================="
echo ""

if [ "$FILES_OK" = true ] && [ "$CONTENT_OK" = true ] && [ "$DOC_OK" = true ]; then
    echo -e "${GREEN}✅ TODAS LAS VERIFICACIONES PASARON${NC}"
    echo ""
    echo "🎉 Tu instalación está lista para desplegar!"
    echo ""
    echo "Próximos pasos:"
    echo "1. Revisa DOKPLOY_ENTERPRISE_SETUP.md para instrucciones de deployment"
    echo "2. Configura las variables de entorno en Dokploy"
    echo "3. Despliega y verifica los logs"
    echo ""
    echo "Cuando despliegues, deberías ver en los logs:"
    echo "   ✅ ENTERPRISE MODE ACTIVADO"
    echo ""
    exit 0
else
    echo -e "${RED}❌ ALGUNAS VERIFICACIONES FALLARON${NC}"
    echo ""
    if [ "$FILES_OK" = false ]; then
        echo "- Archivos necesarios faltantes"
    fi
    if [ "$CONTENT_OK" = false ]; then
        echo "- Configuraciones clave faltantes"
    fi
    if [ "$DOC_OK" = false ]; then
        echo "- Documentación faltante"
    fi
    echo ""
    echo "Por favor, verifica los errores anteriores y vuelve a ejecutar."
    exit 1
fi
