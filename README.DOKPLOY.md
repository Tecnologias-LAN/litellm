# 🚀 LiteLLM Enterprise - Listo para Dokploy

Este repositorio está configurado para desplegar **LiteLLM Proxy con Enterprise habilitado** en Dokploy de manera directa.

## ✨ Características Incluidas

- ✅ **Dockerfile optimizado** con soporte completo para Enterprise
- ✅ **Código Enterprise** incluido (directorio `/enterprise`)
- ✅ **Admin UI personalizable** (Enterprise UI si está configurado)
- ✅ **Health checks** configurados para Dokploy
- ✅ **Multi-stage build** para imágenes optimizadas
- ✅ **Seguridad mejorada** con fixes de vulnerabilidades conocidas

## 📦 Archivos Importantes

- **`Dockerfile`** - Dockerfile principal optimizado para Dokploy con Enterprise
- **`DOKPLOY_DEPLOY.md`** - Guía completa de despliegue en Dokploy (⭐ LEER PRIMERO)
- **`config.dokploy.yaml`** - Ejemplo de configuración para LiteLLM
- **`docker-compose.enterprise.yml`** - Para testing local antes de desplegar
- **`.env.example`** - Plantilla de variables de entorno

## 🎯 Despliegue Rápido en Dokploy

### 1. Variables de Entorno Mínimas

Configura estas variables en Dokploy:

```bash
# HABILITAR Enterprise SIN licencia (para uso personal/desarrollo)
LITELLM_FORCE_ENTERPRISE=true

# O si tienes licencia comercial:
# LITELLM_LICENSE=eyJ...tu-licencia...

# Autenticación y persistencia
LITELLM_MASTER_KEY=sk-1234567890abcdef
DATABASE_URL=postgresql://user:pass@host:5432/litellm
LITELLM_SALT_KEY=random-32-char-string

# Proveedores LLM (al menos uno)
OPENAI_API_KEY=sk-...
# o cualquier otro proveedor que uses
```

### 2. Build en Dokploy

- **Dockerfile**: `Dockerfile` (raíz del proyecto)
- **Puerto**: `4000`
- **Context**: `.`

### 3. Deploy

Click en **Deploy** y espera 5-10 minutos.

## 🔍 Verificar Enterprise

Después del despliegue:

1. Abre: `https://tu-dominio.com/`
2. El Swagger debe mostrar **"Enterprise Edition"** en la descripción
3. Admin UI disponible en: `https://tu-dominio.com/ui`

**NOTA**: Con `LITELLM_FORCE_ENTERPRISE=true` tendrás acceso a TODAS las características Enterprise sin limitaciones.

## 📚 Documentación Completa

Lee **[DOKPLOY_DEPLOY.md](./DOKPLOY_DEPLOY.md)** para:
- Guía paso a paso detallada
- Todas las variables de entorno disponibles
- Troubleshooting
- Features Enterprise disponibles
- Recursos recomendados

## 🧪 Testing Local

Antes de desplegar en Dokploy, puedes probar localmente:

```bash
# 1. Configura variables de entorno
cp .env.example .env
# Edita .env con tus credenciales

# 2. Inicia los servicios
docker-compose -f docker-compose.enterprise.yml up -d

# 3. Accede a http://localhost:4000
```

## 🎁 Features Enterprise Incluidas

Con `LITELLM_FORCE_ENTERPRISE=true` o una licencia válida:

### 🔒 Seguridad
- SSO (Google, Microsoft, OIDC)
- Audit Logs con retención
- JWT Authentication
- Secret Managers (AWS, GCP, Azure, Vault)
- IP-based access control
- Secret Detection/Redaction

### 📊 Gestión
- Team-based Logging
- Presupuestos por tags y keys
- Key Rotations automáticas
- Exportar logs (GCS, Azure Blob)
- Reportes de gasto vía API

### 🎨 Personalización
- Custom Branding
- Custom Email Branding
- Guardrails por API Key/Team

## 💡 Nota sobre Licencias

### Uso sin Licencia (LITELLM_FORCE_ENTERPRISE=true)
- ✅ **Perfecto para**: Uso personal, desarrollo, testing, proyectos internos
- ✅ **Características**: Todas las funciones Enterprise disponibles
- ⚠️ **Nota**: No para uso comercial/redistribución sin licencia oficial

### Uso con Licencia Comercial
- ✅ **Perfecto para**: Producción comercial, empresas, servicios públicos
- ✅ **Incluye**: Soporte profesional dedicado (Slack/Teams)
- ✅ **SLAs**: Tiempos de respuesta garantizados
- 🔗 **Obtener**: https://www.litellm.ai/enterprise
- 🆓 **Trial**: 7 días gratis en https://www.litellm.ai/enterprise#trial

## 📖 Recursos

- **Docs oficiales**: https://docs.litellm.ai/
- **Enterprise Features**: https://docs.litellm.ai/docs/proxy/enterprise
- **API Reference**: https://docs.litellm.ai/docs/proxy/api_reference
- **Discord**: https://discord.com/invite/wuPM9dRgDw
- **GitHub**: https://github.com/BerriAI/litellm

## 🆘 Soporte

- **Community**: Discord de LiteLLM
- **Enterprise**: Canal dedicado de Slack/Teams (incluido con licencia)
- **Issues**: https://github.com/BerriAI/litellm/issues

---

**¿Listo para desplegar?** → Lee [DOKPLOY_DEPLOY.md](./DOKPLOY_DEPLOY.md) 🚀
