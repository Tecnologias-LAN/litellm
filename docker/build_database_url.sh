#!/bin/bash
# =================================================================
# Script Helper: Construir DATABASE_URL desde variables separadas
# =================================================================
# 
# Este script construye el DATABASE_URL a partir de variables
# individuales de base de datos, útil para Dokploy y otros sistemas
# que prefieren variables separadas.
#
# Uso:
#   source docker/build_database_url.sh
#   echo $DATABASE_URL
# =================================================================

# Verificar si las variables individuales están definidas
if [ -n "$DB_POSTGRESDB_HOST" ] && [ -n "$DB_POSTGRESDB_USER" ]; then
    # Construir DATABASE_URL desde variables individuales
    DB_HOST="${DB_POSTGRESDB_HOST:-localhost}"
    DB_PORT="${DB_POSTGRESDB_PORT:-5432}"
    DB_NAME="${DB_POSTGRESDB_DATABASE:-litellm}"
    DB_USER="${DB_POSTGRESDB_USER:-litellm}"
    DB_PASS="${DB_POSTGRESDB_PASSWORD:-}"
    
    # Agregar password solo si está definida
    if [ -n "$DB_PASS" ]; then
        export DATABASE_URL="postgresql://${DB_USER}:${DB_PASS}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
    else
        export DATABASE_URL="postgresql://${DB_USER}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
    fi
    
    echo "✅ DATABASE_URL construido desde variables individuales"
    echo "   Host: $DB_HOST:$DB_PORT"
    echo "   Database: $DB_NAME"
    echo "   User: $DB_USER"
elif [ -n "$DATABASE_URL" ]; then
    # DATABASE_URL ya está definida, usarla directamente
    echo "✅ Usando DATABASE_URL existente"
else
    echo "⚠️  ADVERTENCIA: No se encontró configuración de base de datos"
    echo "   Define DATABASE_URL o las variables DB_POSTGRESDB_*"
fi
