# Guía de Almacenamiento y Sincronización - qkomo-ui

## 🔧 enableCloudSync

| Estado | Almacenamiento | Sincronización | Backup Nube | Multi-dispositivo |
|--------|---------------|----------------|-------------|-------------------|
| `false` (default) | ✅ Hive local | ❌ No | ❌ No | ❌ No |
| `true` | ✅ Hive local | ✅ Backend API | ✅ Sí | ✅ Sí |

**Activar:** `flutter run --dart-define=ENABLE_CLOUD_SYNC=true`

**Qué sincroniza cuando está activado:**
- ✅ Entry (registros de comida)
- ✅ Meal (planificación de menú semanal)
- ✅ UserSettings (alérgenos, restricciones dietéticas)

---

## 💾 Persistencia de Hive

| Evento | ¿Se borran datos de Hive? |
|--------|---------------------------|
| Borrar caché del sistema | ❌ No |
| Cerrar/reiniciar app | ❌ No |
| Actualizar app | ❌ No |
| **Desinstalar app** | ✅ **Sí** |
| **Borrar datos de app** | ✅ **Sí** |

**Ubicación:** Directorio de documentos de la app (no caché)
**Duración:** Permanente hasta desinstalar

---

## 📦 Tipos de Datos y Almacenamiento

| Tipo | Box Hive | Propósito | Cloud Sync | Endpoints API |
|------|----------|-----------|------------|---------------|
| **Entry** | `entries` | Registro de comida consumida (captura/barcode) | ✅ Sí | `/v1/entries` |
| **Meal** | `meals` | Planificación de menú semanal | ✅ Sí | `/v1/meals` |
| **UserSettings** | `user_settings_box` | Alérgenos, restricciones dietéticas | ✅ Sí | `/v1/preferences` |
| **UserRecipe** | `user_recipes` | Recetas personalizadas reutilizables | ❌ No | - |
| **CaptureResult** | `captureResults` | Resultados de análisis de captura | ❌ No | - |
| **FeatureToggle** | `feature_toggles` | Feature flags del backend | ❌ No | `/v1/feature-toggles` |

---

## 🆚 Entry vs Meal (Diferencia Clave)

| Aspecto | Entry | Meal |
|---------|-------|------|
| **Propósito** | Registro de lo que comiste | Planificación de lo que vas a comer |
| **Temporal** | Pasado/presente (`savedAt`) | Presente/futuro (`scheduledFor`) |
| **Fuente** | Foto, barcode, manual | Usuario planifica desde UI |
| **UI** | "Registros Recientes" (Home) | "Menú Semanal" (Home) |
| **Cloud Sync** | ✅ Sí (con enableCloudSync) | ✅ Sí (con enableCloudSync) |
| **Hive Box** | `entries` | `meals` |
| **Vista Semanal** | - | Derivada dinámicamente por `scheduledFor` |

---

## 📅 Meal y Menú Semanal (Cómo Funciona)

**¿Qué se sincroniza?**
- Se sincronizan **Meals individuales** con todos sus campos
- Cada Meal tiene un campo `scheduledFor` (fecha/hora programada)

**¿Cómo funciona el menú semanal?**
- El "menú semanal" NO es un objeto separado en la base de datos
- Es una **vista derivada** que filtra Meals por rango de fechas
- Cuando un Meal se crea con `scheduledFor: 2025-12-27T14:00`, automáticamente aparece en el menú semanal de esa fecha en todos los dispositivos del usuario

**¿Qué NO se sincroniza?**
- Estado UI local (semana actual visualizada, día seleccionado)
- Navegación local del calendario

**Arquitectura:**
```
Device A: Meal(scheduledFor: 2025-12-27) → Cloud → Device B
                    ↓
Ambos dispositivos filtran: meals.where(scheduledFor >= lunes && scheduledFor < domingo)
                    ↓
Vista semanal idéntica en todos los dispositivos
```

---

## 🔄 Estados de Sincronización (Entry & Meal)

| SyncStatus | Significado | Acción |
|------------|-------------|--------|
| `pending` | Esperando sincronizar | Se enviará en próximo sync |
| `synced` | Sincronizado OK | Nada pendiente |
| `failed` | Falló sincronización | Se reintenta automáticamente |
| `conflict` | Conflicto detectado (409) | Requiere resolución manual |

**Nota:** Entry y Meal usan el mismo patrón de sincronización offline-first con los mismos estados.

---

## 🌐 Endpoints API (cuando enableCloudSync = true)

| Endpoint | Método | Usado por | Función |
|----------|--------|-----------|---------|
| `/v1/entries` | GET | Entry | Obtener registros |
| `/v1/entries/{id}` | PUT | Entry | Crear/actualizar registro |
| `/v1/entries/{id}` | DELETE | Entry | Borrar registro (soft delete) |
| `/v1/meals?from=&to=` | GET | Meal | Obtener comidas planificadas por rango de fechas |
| `/v1/meals/{id}` | PUT | Meal | Crear/actualizar comida planificada |
| `/v1/meals/{id}` | DELETE | Meal | Borrar comida planificada (soft delete) |
| `/v1/preferences` | GET | UserSettings | Obtener preferencias |
| `/v1/preferences` | PUT | UserSettings | Guardar preferencias |
| `/v1/preferences` | DELETE | UserSettings | Borrar preferencias |

---

## 📝 Resumen Rápido

**Hive:**
- Almacenamiento local permanente
- Se borra solo al desinstalar app
- NO se borra con caché

**enableCloudSync:**
- Default: `false` (app 100% offline)
- Si `true`: sincroniza Entry, Meal y UserSettings
- Background sync cada 15 minutos
- Patrón offline-first: guarda local → sincroniza en background

**Datos:**
- **Entry** = lo que comiste (CON sync)
- **Meal** = lo que planeas comer (CON sync, vista semanal derivada)
- **UserSettings** = alérgenos/dietas (CON sync)

---

## 🔄 Migración de Datos (Meal V1 → V2)

**Para usuarios existentes:**

Cuando se actualiza la app a la versión con cloud sync de Meal, se ejecuta automáticamente una migración:

| Aspecto | Meal V1 (typeId: 5) | Meal V2 (typeId: 6) |
|---------|---------------------|---------------------|
| **Sync fields** | ❌ No tiene | ✅ Sí (syncStatus, lastModifiedAt, etc.) |
| **Freezed** | ❌ Clase plain | ✅ Immutable @freezed |
| **Hive Adapter** | Manual | Auto-generado |

**Proceso de migración:**
1. Al iniciar la app, se detecta si la migración es necesaria
2. Lee todos los Meals con el adapter antiguo (V1)
3. Convierte cada Meal al nuevo formato con valores por defecto:
   - `syncStatus`: `pending` (se sincronizará en el próximo sync)
   - `lastModifiedAt`: `updatedAt ?? createdAt`
   - `isDeleted`: `false`
   - `lastSyncedAt`: `null`
4. Guarda los Meals convertidos con el nuevo adapter (V2)
5. Marca la migración como completada en `app_preferences`

**Garantías:**
- ✅ Zero data loss: Todos los Meals existentes se preservan
- ✅ Transparent: El usuario no ve ningún cambio en la UI
- ✅ Automatic: No requiere acción del usuario
- ✅ One-time: Solo se ejecuta una vez por instalación

**Ubicación:** `lib/features/menu/data/meal_migration_service.dart`
