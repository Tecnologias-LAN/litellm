#!/bin/sh

# Ejecutar init script enterprise en background (no bloqueante)
if [ -f "docker/init-enterprise.sh" ]; then
    (sleep 30 && sh docker/init-enterprise.sh) > /dev/null 2>&1 &
fi

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