#!/bin/sh

# Función para ejecutar el script de inicialización enterprise
run_enterprise_init() {
    # Esperar un poco para que el servidor inicie completamente
    sleep 5
    
    # Solo ejecutar si no está desactivado
    if [ "${LITELLM_DISABLE_ENTERPRISE_INIT:-false}" != "true" ]; then
        if [ -f "docker/init-enterprise.sh" ]; then
            echo "🚀 Ejecutando script de inicialización Enterprise..."
            sh docker/init-enterprise.sh
        fi
    fi
}

# Ejecutar init script en background
run_enterprise_init &

if [ "$SEPARATE_HEALTH_APP" = "1" ]; then
    export LITELLM_ARGS="$@"
    export SUPERVISORD_STOPWAITSECS="${SUPERVISORD_STOPWAITSECS:-3600}"
    exec supervisord -c /etc/supervisord.conf
fi

if [ "$USE_DDTRACE" = "true" ]; then
    export DD_TRACE_OPENAI_ENABLED="False"
    exec ddtrace-run litellm "$@"
else
    exec litellm "$@"
fi