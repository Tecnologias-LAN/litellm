# 🚀 Activación de Enterprise en LiteLLM

## 📋 Descripción

Este documento explica cómo se activa el modo Enterprise en LiteLLM, similar a como se implementó en n8n. LiteLLM incluye características enterprise que pueden activarse de dos formas:

1. **Con licencia comercial** - Para uso en producción
2. **Sin licencia (modo desarrollo)** - Para desarrollo y pruebas locales

## 🎯 Características Enterprise Habilitadas

Cuando Enterprise está activado, se habilitan automáticamente:

### Autenticación y Seguridad
- ✅ **feat:sso** - Single Sign-On (SSO)
- ✅ **feat:customAuth** - Autenticación personalizada
- ✅ **feat:auditLogs** - Logs de auditoría detallados

### Gestión de Recursos
- ✅ **feat:budgets** - Presupuestos avanzados por usuario/equipo
- ✅ **feat:teamBudgets** - Presupuestos granulares por equipo
- ✅ **feat:modelMaxBudget** - Límites de presupuesto por modelo
- ✅ **feat:virtualKeys** - Llaves virtuales y gestión avanzada

### Infraestructura
- ✅ **feat:loadBalancing** - Balanceo de carga entre múltiples deployments
- ✅ **feat:fallbacks** - Fallbacks automáticos entre modelos
- ✅ **feat:routing** - Enrutamiento avanzado de peticiones

### Observabilidad y Guardrails
- ✅ **feat:customCallbacks** - Callbacks personalizados
- ✅ **feat:customGuardrails** - Guardrails personalizados
- ✅ **feat:llmGuard** - Integración con LLM Guard para seguridad
- ✅ **feat:customRouteChecks** - Validaciones personalizadas de rutas

### Control de Endpoints
- ✅ **feat:disableManagementEndpoints** - Desactivar endpoints de administración
- ✅ **feat:disableLLMEndpoints** - Desactivar endpoints LLM selectivamente

### UI y Personalización
- ✅ **feat:enterpriseUI** - UI Enterprise personalizable
- ✅ **feat:customBranding** - Branding personalizado

## 🔧 Implementación Técnica

### 1. Variable de Entorno en Dockerfile

```dockerfile
ENV LITELLM_FORCE_ENTERPRISE=true
ENV LITELLM_DISABLE_ENTERPRISE_INIT=false
```

Esto activa el modo Enterprise sin necesidad de licencia. La lógica está implementada en:

**Archivo**: [`litellm/proxy/auth/litellm_license.py`](litellm/proxy/auth/litellm_license.py)

```python
def is_premium(self) -> bool:
    """
    Verifica si el usuario tiene acceso a características premium/enterprise
    """
    # Permitir forzar Enterprise mode sin licencia
    force_enterprise = os.getenv("LITELLM_FORCE_ENTERPRISE", "false").lower() == "true"
    if force_enterprise:
        verbose_proxy_logger.info(
            "ENTERPRISE FORZADO activado vía LITELLM_FORCE_ENTERPRISE=true"
        )
        return True
    
    # Luego verifica licencia si está configurada
    # ...
```

### 2. Script de Inicialización `docker/init-enterprise.sh`

Similar al script de n8n, este script:

1. ✅ Espera a que LiteLLM esté listo
2. ✅ Verifica el estado de la licencia
3. ✅ Muestra en consola todas las features activadas
4. ✅ Proporciona información sobre endpoints disponibles

**Ejecución**: El script se ejecuta automáticamente en background después de que el servidor inicia.

### 3. Modificación de `docker/prod_entrypoint.sh`

```bash
# Función para ejecutar el script de inicialización enterprise
run_enterprise_init() {
    sleep 5  # Esperar a que el servidor inicie
    
    if [ "${LITELLM_DISABLE_ENTERPRISE_INIT:-false}" != "true" ]; then
        if [ -f "docker/init-enterprise.sh" ]; then
            echo "🚀 Ejecutando script de inicialización Enterprise..."
            sh docker/init-enterprise.sh
        fi
    fi
}

# Ejecutar init script en background
run_enterprise_init &
```

### 4. Flujo Completo

```mermaid
graph TD
    A[Docker Container Inicia] --> B[prod_entrypoint.sh]
    B --> C[Verifica LITELLM_FORCE_ENTERPRISE]
    C --> D[Inicia servidor LiteLLM]
    D --> E[Ejecuta init-enterprise.sh en background]
    E --> F[Espera que /health responda]
    F --> G[Verifica /health/license]
    G --> H[Muestra features activadas]
    H --> I[✅ Enterprise Activo]
```

## 📦 Uso en Dokploy

### Opción 1: Enterprise sin Licencia (Desarrollo)

Variables de entorno ya configuradas por defecto:

```bash
LITELLM_FORCE_ENTERPRISE=true  # ✅ Ya configurado en Dockerfile
```

**✨ No necesitas hacer nada más, Enterprise está activado por defecto.**

### Opción 2: Enterprise con Licencia (Producción)

Si tienes una licencia comercial de LiteLLM:

```bash
LITELLM_LICENSE=tu-licencia-aqui
# LITELLM_FORCE_ENTERPRISE=false  # Se desactiva automáticamente al usar licencia
```

### Opción 3: Desactivar Enterprise

Si por alguna razón necesitas desactivar Enterprise:

```bash
LITELLM_FORCE_ENTERPRISE=false
```

### Variables Recomendadas para Producción

```bash
# Base de datos para persistencia
DATABASE_URL=postgresql://user:pass@host:5432/litellm

# Seguridad
LITELLM_MASTER_KEY=sk-1234567890abcdef
LITELLM_SALT_KEY=random-32-character-string-here

# Modo de operación
LITELLM_MODE=PRODUCTION

# Almacenamiento de configuración
STORE_MODEL_IN_DB=True

# Protección del UI Admin
UI_USERNAME=admin
UI_PASSWORD=your-secure-password-here

# Enterprise (ya configurado por defecto)
LITELLM_FORCE_ENTERPRISE=true
```

## 🔍 Verificación

### Durante el inicio, verás en los logs:

```
==========================================
🚀 LiteLLM Enterprise Initialization
==========================================
⏳ Esperando que LiteLLM esté listo...
✅ LiteLLM está listo!

🔍 Verificando estado de Enterprise...

📋 Estado de la licencia:
{
  "has_license": true,
  "license_type": "enterprise",
  ...
}

==========================================
✅ ENTERPRISE MODE ACTIVADO

🎯 Features Enterprise habilitadas:
   ✓ feat:sso - Single Sign-On (SSO)
   ✓ feat:budgets - Presupuestos avanzados
   ✓ feat:teamBudgets - Presupuestos por equipo
   ... y más features enterprise

📝 NOTA: Enterprise activado sin licencia (modo desarrollo)
   Para uso comercial, obtén una licencia en:
   https://www.litellm.ai/enterprise
==========================================
```

### Verificar manualmente el estado:

```bash
# Health check general
curl http://localhost:4000/health

# Estado específico de la licencia
curl http://localhost:4000/health/license
```

## 🚨 Consideraciones Importantes

### ⚠️ Uso sin Licencia (LITELLM_FORCE_ENTERPRISE=true)

- ✅ **Perfecto para**: Desarrollo local, pruebas, uso personal
- ⚠️ **NO recomendado para**: Uso comercial en producción
- 💡 **Alternativa**: Obtener una licencia oficial en https://www.litellm.ai/enterprise

### ✅ Uso con Licencia Comercial

- ✅ Soporte oficial
- ✅ Actualizaciones prioritarias
- ✅ Cumplimiento legal para uso comercial
- ✅ Características adicionales y límites más altos

## 📊 Comparación con n8n

| Aspecto | n8n | LiteLLM |
|---------|-----|---------|
| Variable de activación | `E2E_TESTS=true` | `LITELLM_FORCE_ENTERPRISE=true` |
| Script de init | `docker-init-enterprise.sh` | `docker/init-enterprise.sh` |
| Verificación de estado | Endpoints `/e2e/*` | `/health/license` |
| Implementación | Custom en startup | Integrado en `is_premium()` |
| Features habilitadas | ~30 features | ~20+ features enterprise |

## 🎉 Resultado

Cuando despliegues en Dokploy, verás:

1. ✅ El mensaje "**✅ All enterprise features enabled!**" en los logs
2. ✅ Lista completa de features activadas
3. ✅ Confirmación visual del modo Enterprise
4. ✅ Información de endpoints disponibles

## 📚 Referencias

- [Documentación oficial de LiteLLM Enterprise](https://docs.litellm.ai/docs/proxy/enterprise)
- [Código fuente de license check](litellm/proxy/auth/litellm_license.py)
- [Enterprise features](enterprise/README.md)

## 💡 Tips

1. **Logs detallados**: Usa `--detailed_debug` en CMD para ver más información
2. **Verificar UI**: Accede a `http://localhost:4000/ui` para ver el Admin UI enterprise
3. **Monitoreo**: Verifica `/health/license` periódicamente para el estado
4. **Desactivar init script**: Si no quieres ver los mensajes, configura `LITELLM_DISABLE_ENTERPRISE_INIT=true`

---

**Creado**: 20 de marzo de 2026  
**Autor**: Basado en implementación similar de n8n  
**Versión**: LiteLLM 2.x  
