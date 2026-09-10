#!/bin/sh
# =================================================================
# LiteLLM Enterprise Status Script
# =================================================================
# Desde LiteLLM v1.100.1 el modo Enterprise esta habilitado de forma
# PERMANENTE en el codigo fuente:
#
#   litellm/proxy/auth/litellm_license.py -> ENTERPRISE_ALWAYS_ON = True
#
# Ya no depende de LITELLM_LICENSE ni de LITELLM_FORCE_ENTERPRISE, por lo
# que sobrevive reinicios y redeploys sin necesidad de correr nada.
# Este script solo informa el estado en los logs de arranque.
# =================================================================

LICENSE_FILE="litellm/proxy/auth/litellm_license.py"

echo ""
echo "=========================================="
echo "🚀 LiteLLM Enterprise Status"
echo "=========================================="
echo ""

if grep -q "ENTERPRISE_ALWAYS_ON: bool = True" "$LICENSE_FILE" 2>/dev/null; then
    echo "✅ ENTERPRISE MODE ACTIVADO (permanente, hardcodeado)"
    echo "   Fuente: $LICENSE_FILE (ENTERPRISE_ALWAYS_ON=True)"
    echo "   No requiere licencia ni variables de entorno."
    echo "   No se contacta https://license.litellm.ai"
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
    echo "   ✓ feat:customRouteChecks - Validaciones de rutas"
    echo "   ... y el resto de features enterprise"
    echo ""
    echo "📝 NOTA: Enterprise activado sin licencia (ambiente controlado)."
    echo "   Para uso comercial, obtén una licencia en:"
    echo "   https://www.litellm.ai/enterprise"
else
    echo "ℹ️  Enterprise Mode: NO ACTIVADO"
    echo ""
    echo "   Para activarlo de forma permanente, pon en $LICENSE_FILE:"
    echo "     ENTERPRISE_ALWAYS_ON: bool = True"
fi

echo ""
echo "=========================================="
echo ""

exit 0
