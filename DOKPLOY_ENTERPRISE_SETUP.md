# 🚀 Guía de Deployment en Dokploy - LiteLLM Enterprise

## 📋 Variables de Entorno Requeridas

### ✅ Enterprise (Ya Activado por Defecto)

```bash
# ✅ ESTAS VARIABLES YA ESTÁN CONFIGURADAS EN EL DOCKERFILE
# No necesitas configurarlas a menos que quieras cambiar el comportamiento
LITELLM_FORCE_ENTERPRISE=true
LITELLM_MODE=PRODUCTION
```

### 🔐 Seguridad (REQUERIDO para producción)

```bash
# Master Key para autenticación de administrador
LITELLM_MASTER_KEY=sk-1234567890abcdefghijklmnopqrstuvwxyz

# Salt key para encriptar keys en la base de datos (32+ caracteres)
LITELLM_SALT_KEY=your-random-32-character-salt-key-here

# Protección del UI Admin (opcional pero recomendado)
UI_USERNAME=admin
UI_PASSWORD=your-secure-password-here
```

### 💾 Base de Datos (REQUERIDO para persistencia)

```bash
# PostgreSQL - Recomendado para producción
DATABASE_URL=postgresql://user:password@host:5432/litellm

# Guardar configuración de modelos en DB
STORE_MODEL_IN_DB=True
```

### 🤖 Proveedores LLM (Configura los que uses)

```bash
# OpenAI
OPENAI_API_KEY=sk-...
OPENAI_BASE_URL=https://api.openai.com/v1

# Anthropic
ANTHROPIC_API_KEY=sk-ant-...

# Cohere
COHERE_API_KEY=...

# Azure OpenAI
AZURE_API_BASE=https://your-resource.openai.azure.com
AZURE_API_VERSION=2024-02-15-preview
AZURE_API_KEY=...

# Google Vertex AI
VERTEX_PROJECT=your-project-id
VERTEX_LOCATION=us-central1
GOOGLE_APPLICATION_CREDENTIALS=/path/to/credentials.json

# Hugging Face
HUGGINGFACE_API_KEY=hf_...

# OpenRouter
OR_API_KEY=sk-or-...
OR_SITE_URL=https://yourdomain.com
OR_APP_NAME=YourApp
```

### ⚙️ Configuración Opcional

```bash
# Puerto (default: 4000)
PORT=4000

# Nivel de logs
LOG_LEVEL=INFO

# Timeout para requests (segundos)
REQUEST_TIMEOUT=600

# Max parallel requests
MAX_PARALLEL_REQUESTS=100

# Rate limiting
RATE_LIMIT_PER_USER=100  # requests per minute

# Desactivar telemetría (opcional)
LITELLM_TELEMETRY=False

# Desactivar el script de inicialización enterprise (opcional)
LITELLM_DISABLE_ENTERPRISE_INIT=false
```

## 📝 Ejemplo Completo para Dokploy

```bash
# ============================================
# LITELLM - CONFIGURACIÓN DOKPLOY
# ============================================

# --- Enterprise (Ya configurado por defecto) ---
LITELLM_FORCE_ENTERPRISE=true
LITELLM_MODE=PRODUCTION

# --- Seguridad (CAMBIAR ESTOS VALORES) ---
LITELLM_MASTER_KEY=sk-litellm-master-key-123456789
LITELLM_SALT_KEY=random-salt-key-32-characters-min
UI_USERNAME=admin
UI_PASSWORD=AdminPassword123!

# --- Base de Datos ---
DATABASE_URL=postgresql://litellm:litellm_password@postgres-host:5432/litellm
STORE_MODEL_IN_DB=True

# --- Proveedores LLM (Configura solo los que uses) ---
OPENAI_API_KEY=sk-proj-...
ANTHROPIC_API_KEY=sk-ant-...
COHERE_API_KEY=...

# --- Configuración Opcional ---
PORT=4000
LOG_LEVEL=INFO
REQUEST_TIMEOUT=600
LITELLM_TELEMETRY=False
```

## 🎯 Pasos para Desplegar en Dokploy

### 1. Crear Aplicación en Dokploy

1. Ve a tu proyecto en Dokploy
2. Click en "Create Application" o "Nueva Aplicación"
3. Selecciona "Docker" como tipo

### 2. Configuración del Repositorio

```
Repository URL: https://github.com/tu-usuario/litellm
Branch: main
Dockerfile Path: ./Dockerfile
Build Context: .
```

### 3. Variables de Entorno

Copia y pega las variables de arriba en la sección de "Environment Variables" en Dokploy.

**⚠️ IMPORTANTE**: Cambia estos valores por seguridad:
- `LITELLM_MASTER_KEY`
- `LITELLM_SALT_KEY`
- `UI_PASSWORD`
- `DATABASE_URL`

### 4. Configurar Base de Datos PostgreSQL

#### Opción A: Usar base de datos de Dokploy

1. En Dokploy, crea una nueva base de datos PostgreSQL
2. Copia el connection string que te proporciona
3. Úsalo como valor para `DATABASE_URL`

#### Opción B: Base de datos externa

Usa el connection string de tu proveedor (Neon, Supabase, AWS RDS, etc.)

### 5. Port Mapping

```
Container Port: 4000
Public Port: 80 (o el que prefieras)
```

### 6. Health Check

Dokploy debería detectar automáticamente el health check del Dockerfile:

```
Endpoint: /health
Interval: 30s
Timeout: 10s
Start Period: 40s
Retries: 3
```

### 7. Deploy

1. Click en "Deploy" o "Desplegar"
2. Espera a que el build termine
3. Verifica los logs

## 📊 Verificación del Deployment

### Logs que deberías ver:

```
==========================================
🚀 LiteLLM Enterprise Initialization
==========================================
⏳ Esperando que LiteLLM esté listo...
✅ LiteLLM está listo!

🔍 Verificando estado de Enterprise...

==========================================
✅ ENTERPRISE MODE ACTIVADO

🎯 Features Enterprise habilitadas:
   ✓ feat:sso - Single Sign-On (SSO)
   ✓ feat:budgets - Presupuestos avanzados
   ✓ feat:teamBudgets - Presupuestos por equipo
   ... (más features)

📝 NOTA: Enterprise activado sin licencia (modo desarrollo)
==========================================

✨ Inicialización completada
   LiteLLM Proxy está listo en http://localhost:4000
==========================================
```

### Endpoints para probar:

```bash
# Health check
curl https://tu-dominio.com/health

# Información de licencia
curl https://tu-dominio.com/health/license

# Admin UI (en el navegador)
https://tu-dominio.com/ui

# API Documentation
https://tu-dominio.com/docs
```

## 🐛 Troubleshooting

### Error: "Bad Gateway"

**Causas comunes**:

1. **Puerto incorrecto**: Verifica que el container port sea 4000
2. **Base de datos no conecta**: Verifica DATABASE_URL
3. **Migraciones pendientes**: Los logs deberían mostrar "Migration script ran successfully!"
4. **Health check falla**: Aumenta el `start-period` en health check

**Solución**:

```bash
# Ver logs del contenedor en Dokploy
# Busca errores específicos:
# - "Migration script failed!"
# - "Unable to connect to database"
# - "Failed to start server"
```

### No se ve el mensaje de Enterprise activado

**Causa**: El script de inicialización puede estar desactivado o no ejecutándose.

**Solución**:

1. Verifica que `LITELLM_DISABLE_ENTERPRISE_INIT` no esté en `true`
2. Verifica los logs del contenedor
3. Ejecuta manualmente: `docker exec -it <container> sh docker/init-enterprise.sh`

### Errores de licencia

**Mensaje**: `"You need an Enterprise license for this feature"`

**Solución**: Verifica que `LITELLM_FORCE_ENTERPRISE=true` esté configurado.

```bash
# Verificar dentro del contenedor
docker exec -it <container> env | grep LITELLM_FORCE_ENTERPRISE
# Debería mostrar: LITELLM_FORCE_ENTERPRISE=true
```

## 📚 Referencias Útiles

- [Documentación oficial de LiteLLM](https://docs.litellm.ai/)
- [Enterprise Activation Guide](ENTERPRISE_ACTIVATION.md)
- [Dokploy Documentation](https://docs.dokploy.com/)
- [LiteLLM Proxy Docs](https://docs.litellm.ai/docs/proxy/quick_start)

## 💡 Tips Pro

1. **Usa PostgreSQL**: Es más robusto que SQLite para producción
2. **Configura CORS**: Si vas a acceder desde frontend
3. **Monitoreo**: Integra con Prometheus usando el endpoint `/metrics`
4. **Backups**: Haz backups regulares de la base de datos
5. **SSL/TLS**: Configura certificados SSL en Dokploy para HTTPS
6. **Rate Limiting**: Ajusta según tu uso esperado
7. **Logging**: Usa un servicio de logs centralizado

## 🎉 ¡Listo!

Ahora tienes LiteLLM corriendo con todas las características Enterprise activadas sin necesidad de licencia (para desarrollo/uso personal).

Para uso comercial en producción, considera obtener una licencia oficial en:
👉 https://www.litellm.ai/enterprise

---

**Última actualización**: 20 de marzo de 2026  
**Versión compatible**: LiteLLM 2.x  
