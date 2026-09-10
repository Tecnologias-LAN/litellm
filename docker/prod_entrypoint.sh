#!/bin/sh

# Ejecutar init script enterprise en background (no bloqueante)
if [ -f "docker/init-enterprise.sh" ]; then
    echo "🔍 Enterprise init script encontrado, se ejecutará en 30 segundos..."
    (sleep 30 && sh docker/init-enterprise.sh) &
else
    echo "⚠️  No se encontró docker/init-enterprise.sh"
fi

# NOTA: LiteLLM v1.100.x elimino supervisord y el modo SEPARATE_HEALTH_APP
# del Dockerfile oficial, por eso ya no se invoca aqui.

if [ "$USE_DDTRACE" = "true" ]; then
    export DD_TRACE_OPENAI_ENABLED="False"
    exec ddtrace-run litellm "$@"
else
    exec litellm "$@"
fi
