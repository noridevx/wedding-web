# TODO List - Wedding Web App

## 📋 Tareas Pendientes

### 🔧 Funcionalidades por Implementar

#### 1. ✅ Añadir teléfono para los retos
- [x] **Descripción**: Agregar campo de teléfono en la funcionalidad de retos
- [x] **Archivos modificados**:
  - `supabase-setup.sql` - Añadida columna `phone` a tabla `photos`
  - `src/composables/useDeviceStorage.js` - Funciones para manejar teléfono del dispositivo
  - `src/components/FabUploadButton.vue` - Campo de teléfono en el modal de retos
  - `src/components/ChallengeButton.vue` - Mostrar estado del teléfono del reto
- [x] **Funcionalidades implementadas**:
  - Campo de teléfono opcional en modal de retos
  - Validación de formato de teléfono español
  - Persistencia del teléfono en localStorage para futuros retos
  - Guardado del teléfono junto a cada foto (no al reto)
  - Indicador visual del estado del teléfono en retos completados

#### 2. ✅ Implementar paginado con infinite scroll
- [x] **Descripción**: Implementar paginado con infinite scroll para todas las fotos
- [x] **Archivos modificados**:
  - `src/composables/usePhotoGallery.js` - Paginado y carga progresiva
  - `src/components/PhotoGallery.vue` - Infinite scroll y indicadores de carga
  - `src/pages/app.vue` - Integración de nuevas props
- [x] **Funcionalidades implementadas**:
  - Paginado de 20 fotos por página
  - Infinite scroll automático al llegar al final
  - Indicadores de carga y fin de fotos
  - Compatible con filtro de retos
  - Optimización de consultas según filtro activo
  - Recarga automática al cambiar filtros

#### 3. Crear más de 200 retos
- [ ] **Descripción**: Generar una base de datos con más de 200 retos variados
- [ ] **Archivos a modificar**:
  - `supabase-challenges-setup.sql` - Añadir más datos de ejemplo
  - Crear script de generación masiva de retos
- [ ] **Categorías sugeridas**:
  - [ ] Retos de baile (20-30 retos)
  - [ ] Retos de fotografía (30-40 retos)
  - [ ] Retos de interacción social (25-35 retos)
  - [ ] Retos de creatividad (20-30 retos)
  - [ ] Retos de humor (15-25 retos)
  - [ ] Retos de destreza física (15-25 retos)
  - [ ] Retos de memoria/trivia (10-20 retos)
  - [ ] Retos de colaboración (10-15 retos)
  - [ ] Retos temáticos de boda (15-25 retos)
  - [ ] Retos aleatorios/funny (10-15 retos)

### 🎯 Prioridades

**Alta Prioridad:**
1. ✅ Añadir teléfono para los retos
2. ✅ Implementar paginado con infinite scroll
3. Crear más de 200 retos

**Media Prioridad:**
- Optimizar rendimiento con muchos retos
- Añadir categorías/filtros de retos
- Mejorar UX para selección de retos

**Baja Prioridad:**
- Estadísticas de retos completados
- Sistema de puntuación
- Retos especiales por fecha/hora

### 📝 Notas de Implementación

#### Para el teléfono (COMPLETADO):
```sql
-- Columna añadida a la tabla photos
ALTER TABLE photos ADD COLUMN phone TEXT;
```

#### Para el paginado (COMPLETADO):
```javascript
// Paginado con infinite scroll
const pageSize = 20
const offset = currentPage * pageSize
// Consulta optimizada según filtro activo
```

#### Para los retos masivos:
- Usar script de inserción batch para mejor rendimiento
- Considerar categorización para facilitar selección
- Mantener variedad en dificultad y tipo

### 🔄 Estado del Proyecto

**✅ Completado:**
- Sistema de retos básico
- Reserva de retos por dispositivo
- Modal unificado para subida de fotos
- Filtrado de fotos por retos
- Highlighting de fotos de retos
- Sistema de localStorage para persistencia
- **Campo de teléfono opcional para retos**
- **Paginado con infinite scroll para todas las fotos**

**🔄 En Progreso:**
- Ninguna tarea actualmente

**⏳ Pendiente:**
- Crear más de 200 retos

---

*Última actualización: $(date)*
