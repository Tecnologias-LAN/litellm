#!/bin/sh

# Función para ejecutar el script de inicialización enterprise
run_enterprise_init() {
    # Esperar a que el servidor esté completamente listo (incluyendo migraciones)
    echo "⏳ Esperando a que el servidor LiteLLM esté listo..."
    sleep 20
    
    # Verificar que el servidor responda
    MAX_WAIT=20
    COUNT=0
    while [ $COUNT -lt $MAX_WAIT ]; do
        if curl -f -s http://127.0.0.1:4000/health > /dev/null 2>&1; then
            echo "✅ Servidor listo, ejecutando script de inicialización Enterprise..."
            break
        fi
        COUNT=$((COUNT + 1))
        sleep 1
    done
    
    # Solo ejecutar si no está desactivado
    if [ "${LITELLM_DISABLE_ENTERPRISE_INIT:-false}" != "true" ]; then
        if [ -f "docker/init-enterprise.sh" ]; then
            sh docker/init-enterprise.sh
        fi
    fi
}

# Ejecutar init script en background solo si el servidor inicia correctamente
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