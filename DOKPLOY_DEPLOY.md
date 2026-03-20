# 🚀 Guía de Despliegue en Dokploy - LiteLLM Enterprise

Esta guía te ayudará a desplegar LiteLLM Proxy con Enterprise habilitado en Dokploy.

## 📋 Requisitos Previos

1. **Cuenta de Dokploy** activa y funcionando
2. **Licencia Enterprise de LiteLLM** (opcional pero recomendado)
   - Obtén una licencia aquí: https://www.litellm.ai/enterprise
   - Trial gratuito de 7 días: https://www.litellm.ai/enterprise#trial
3. **Base de datos PostgreSQL** (recomendado para producción)
4. **API Keys** de los proveedores LLM que vas a usar (OpenAI, Anthropic, Azure, etc.)

## 🏗️ Pasos para Desplegar

### 1. Crear una Nueva Aplicación en Dokploy

1. Accede a tu panel de Dokploy
2. Crea una nueva aplicación de tipo **Docker**
3. Conecta tu repositorio Git o sube el código de LiteLLM

### 2. Configurar el Build

En la configuración de Build de Dokploy:

- **Dockerfile**: `Dockerfile` (en la raíz del proyecto)
- **Context Path**: `.` (raíz del proyecto)
- **Puerto**: `4000`

### 3. Configurar Variables de Entorno

En la sección de Variables de Entorno de Dokploy, configura las siguientes variables:

#### ✨ Variables REQUERIDAS para Enterprise:

```bash
# Licencia Enterprise (IMPORTANTE)
LITELLM_LICENSE=eyJ...tu-licencia-aqui...

# Master Key para autenticación de admin
LITELLM_MASTER_KEY=sk-1234567890abcdef

# Base de datos PostgreSQL para persistencia
DATABASE_URL=postgresql://usuario:password@host:5432/litellm

# Salt key para encriptar keys en DB (string aleatorio de 32 caracteres)
LITELLM_SALT_KEY=tu-string-aleatorio-de-32-caracteres
```

#### 🔧 Variables OPCIONALES pero RECOMENDADAS:

```bash
# Modo de operación
LITELLM_MODE=PRODUCTION

# Guardar configuración de modelos en DB
STORE_MODEL_IN_DB=True

# Credenciales para Admin UI
UI_USERNAME=admin
UI_PASSWORD=tu-password-seguro

# Usar Prisma migrate en lugar de db push (recomendado para producción)
USE_PRISMA_MIGRATE=True
```

#### 🤖 Variables de PROVEEDORES LLM:

```bash
# OpenAI
OPENAI_API_KEY=sk-...

# Azure OpenAI
AZURE_API_KEY=...
AZURE_API_BASE=https://...

# Anthropic
ANTHROPIC_API_KEY=sk-ant-...

# Google AI (Gemini)
GEMINI_API_KEY=...

# AWS Bedrock
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION_NAME=us-east-1

# Agrega las que necesites para tus proveedores
```

#### 📊 Variables OPCIONALES para Observabilidad:

```bash
# Redis para rate limiting compartido
REDIS_HOST=tu-redis-host
REDIS_PASSWORD=tu-redis-password
REDIS_PORT=6379

# Langfuse para tracking
LANGFUSE_PUBLIC_KEY=pk-...
LANGFUSE_SECRET_KEY=sk-...
LANGFUSE_HOST=https://cloud.langfuse.com

# Slack para alertas
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...
```

### 4. Montar Archivo de Configuración (Opcional)

Si quieres usar un archivo `config.yaml` personalizado:

1. Crea tu archivo `config.yaml` basado en `config.dokploy.yaml`
2. En Dokploy, monta el archivo en: `/app/config.yaml`
3. Asegúrate de que el comando CMD incluya: `--config /app/config.yaml`

### 5. Configurar Base de Datos PostgreSQL

#### Opción A: Usar PostgreSQL de Dokploy

1. Crea una nueva base de datos PostgreSQL en Dokploy
2. Obtén la URL de conexión
3. Configúrala en `DATABASE_URL`

#### Opción B: Usar PostgreSQL externa

```bash
DATABASE_URL=postgresql://usuario:password@host:5432/nombre_db?sslmode=require
```

### 6. Desplegar la Aplicación

1. Guarda todas las configuraciones
2. Click en **Deploy** / **Desplegar**
3. Espera a que el build y deployment se completen (puede tomar 5-10 minutos la primera vez)

### 7. Verificar el Despliegue

Una vez desplegado, verifica que todo funcione:

#### A. Health Check

```bash
curl https://tu-dominio.com/health
```

Respuesta esperada:
```json
{
  "status": "healthy",
  ...
}
```

#### B. Verificar Enterprise Edition

1. Abre `https://tu-dominio.com/` en tu navegador
2. Deberías ver el Swagger UI
3. En la descripción debería aparecer **"Enterprise Edition"**

#### C. Probar el Admin UI

1. Accede a: `https://tu-dominio.com/ui`
2. Login con las credenciales que configuraste (UI_USERNAME y UI_PASSWORD)
3. Deberías ver el dashboard de administración

#### D. Test de API

```bash
curl -X POST 'https://tu-dominio.com/chat/completions' \
  -H 'Authorization: Bearer sk-1234567890abcdef' \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "gpt-4",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## 🔒 Características Enterprise Habilitadas

Una vez desplegado con `LITELLM_LICENSE`, tienes acceso a:

### Seguridad
- ✅ **SSO para Admin UI** (Google, Microsoft, OIDC genérico)
- ✅ **Audit Logs** con políticas de retención
- ✅ **JWT Authentication**
- ✅ **Control de rutas públicas/privadas**
- ✅ **Secret Managers** (AWS KMS, Google Secret Manager, Azure Key Vault, Hashicorp Vault)
- ✅ **IP-based access control**
- ✅ **Track de IP addresses**
- ✅ **Secret Detection/Redaction** en requests

### Gestión y Monitoreo
- ✅ **Team-based Logging** (proyectos Langfuse por equipo)
- ✅ **Presupuestos USD por tags personalizados**
- ✅ **Presupuestos de modelo por Virtual Key**
- ✅ **Exportar logs** a GCS Bucket, Azure Blob Storage
- ✅ **Key Rotations** automáticas
- ✅ **Reportes de gasto** vía API

### Personalización
- ✅ **Custom Branding** en Swagger Docs
- ✅ **Custom Email Branding**
- ✅ **Guardrails personalizados** por API Key/Team

## 📈 Recursos Recomendados para Producción

- **CPU**: Mínimo 4 cores (recomendado 8+ cores para alta carga)
- **RAM**: Mínimo 8 GB (recomendado 16+ GB)
- **Disco**: 20 GB mínimo
- **PostgreSQL**: DB dedicada con backups automáticos
- **Redis**: Para rate limiting compartido entre instancias (opcional pero recomendado)

## 🐛 Troubleshooting

### El Swagger no muestra "Enterprise Edition"

1. Verifica que `LITELLM_LICENSE` esté configurada correctamente
2. Verifica que la licencia no haya expirado
3. Reinicia el contenedor completamente
4. Revisa los logs: `docker logs <container-id>`

### Errores de Base de Datos

```bash
# Verifica la conexión a la DB
DATABASE_URL=postgresql://... poetry run python -c "from litellm.proxy.utils import prisma_client; print(prisma_client)"
```

### Logs de Debug

Para habilitar logs detallados, modifica el CMD en el Dockerfile:

```dockerfile
CMD ["--port", "4000", "--detailed_debug"]
```

O agrega en variables de entorno:

```bash
LITELLM_LOG=DEBUG
```

### Problemas de Memoria

Si el contenedor se queda sin memoria:

1. Aumenta los recursos en Dokploy
2. Configura límites de workers:
   ```bash
   UVICORN_NUM_WORKERS=2
   ```

## 📚 Recursos Adicionales

- **Documentación oficial**: https://docs.litellm.ai/
- **Enterprise Features**: https://docs.litellm.ai/docs/proxy/enterprise
- **Deployment Guide**: https://docs.litellm.ai/docs/proxy/deploy
- **API Reference**: https://docs.litellm.ai/docs/proxy/api_reference
- **Community Support**: https://discord.com/invite/wuPM9dRgDw
- **Enterprise Support**: Incluido con licencia enterprise (Slack/Teams dedicado)

## 🆘 Soporte

- **Community**: Discord de LiteLLM
- **Enterprise**: Canal dedicado de Slack/Teams (incluido con licencia)
- **Issues**: https://github.com/BerriAI/litellm/issues

---

¡Feliz despliegue! 🎉

Si tienes problemas o preguntas, consulta la documentación oficial o contacta al soporte de LiteLLM.
