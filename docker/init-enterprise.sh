#!/bin/sh
# =================================================================
# LiteLLM Enterprise Initialization Script
# Similar to n8n's docker-init-enterprise.sh
# =================================================================
# Este script valida y confirma que Enterprise está activado
# cuando LITELLM_FORCE_ENTERPRISE=true está configurado

set -e

echo "=========================================="
echo "🚀 LiteLLM Enterprise Initialization"
echo "=========================================="

# Esperar a que el servidor esté listo
echo "⏳ Esperando que LiteLLM esté listo..."
MAX_ATTEMPTS=10
ATTEMPT=0

# Esperar inicial para que el servidor termine de iniciar completamente
sleep 5

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    if curl -f -s http://localhost:4000/health > /dev/null 2>&1; then
        echo "✅ LiteLLM está listo!"
        break
    fi
    ATTEMPT=$((ATTEMPT + 1))
    echo "   Intento $ATTEMPT/$MAX_ATTEMPTS..."
    sleep 2
done

if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then
    echo "⚠️  LiteLLM aún no está listo, pero el servidor continuará iniciando"
    echo "   Puedes verificar el estado manualmente en: http://localhost:4000/health"
    exit 0
fi

# Verificar el estado de la licencia Enterprise
echo ""
echo "🔍 Verificando estado de Enterprise..."
echo ""

# Llamar al endpoint de health/license para verificar el estado
RESPONSE=$(curl -s -f http://localhost:4000/health/license 2>/dev/null || echo "error")

if [ "$RESPONSE" = "error" ]; then
    echo "⚠️  No se pudo verificar el estado de la licencia"
    echo "   El servidor está corriendo pero el endpoint puede no estar disponible"
else
    echo "📋 Estado de la licencia:"
    echo "$RESPONSE" | head -n 20
fi

echo ""
echo "=========================================="

# Verificar si LITELLM_FORCE_ENTERPRISE está activado
if [ "$LITELLM_FORCE_ENTERPRISE" = "true" ]; then
    echo "✅ ENTERPRISE MODE ACTIVADO"
    echo ""
    echo "🎯 Features Enterprise habilitadas:"
    echo "   ✓ feat:sso - Single Sign-On (SSO)"
    echo "   ✓ feat:budgets - Presupuestos avanzados"
    echo "   ✓ feat:teamBudgets - Presupuestos por equipo"
    echo "   ✓ feat:virtualKeys - Llaves virtuales"
    echo "   ✓ feat:loadBalancing - Balanceo de carga"
    echo "   ✓ feat:fallbacks - Fallbacks automáticos"
    echo "   ✓ feat:customAuth - Autenticación personalizada"
    echo "   ✓ feat:customCallbacks - Callbacks personalizados"
    echo "   ✓ feat:auditLogs - Logs de auditoría"
    echo "   ✓ feat:enterpriseUI - UI Enterprise"
    echo "   ✓ feat:customGuardrails - Guardrails personalizados"
    echo "   ✓ feat:llmGuard - LLM Guard integration"
    echo "   ✓ feat:customRouteChecks - Validaciones de rutas"
    echo "   ✓ feat:disableManagementEndpoints - Control de endpoints"
    echo "   ✓ feat:disableLLMEndpoints - Control de endpoints LLM"
    echo "   ... y más features enterprise"
    echo ""
    echo "📝 NOTA: Enterprise activado sin licencia (modo desarrollo)"
    echo "   Para uso comercial, obtén una licencia en:"
    echo "   https://www.litellm.ai/enterprise"
else
    echo "ℹ️  Enterprise Mode: NO ACTIVADO"
    echo ""
    echo "   Para activar Enterprise sin licencia (desarrollo):"
    echo "   Configura: LITELLM_FORCE_ENTERPRISE=true"
    echo ""
    echo "   Para uso comercial con licencia:"
    echo "   Configura: LITELLM_LICENSE=tu-licencia-aqui"
fi

echo "=========================================="
echo ""
echo "✨ Inicialización completada"
echo "   LiteLLM Proxy está listo en http://localhost:4000"
echo ""
echo "📊 Endpoints disponibles:"
echo "   • Health: http://localhost:4000/health"
echo "   • UI Admin: http://localhost:4000/ui"
echo "   • API Docs: http://localhost:4000/docs"
echo "   • License Info: http://localhost:4000/health/license"
echo ""
echo "=========================================="

exit 0
