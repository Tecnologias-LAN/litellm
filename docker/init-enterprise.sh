#!/bin/sh
# =================================================================
# LiteLLM Enterprise Initialization Script
# =================================================================

echo ""
echo "=========================================="
echo "🚀 LiteLLM Enterprise Status"
echo "=========================================="
echo ""

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
fi

echo ""
echo "=========================================="
echo ""

exit 0
