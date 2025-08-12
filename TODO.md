# TODO List - Wedding Web App

## 📋 Tareas Pendientes

### 🔧 Funcionalidades por Implementar

#### 1. Añadir teléfono para los retos
- [ ] **Descripción**: Agregar campo de teléfono en la funcionalidad de retos
- [ ] **Archivos a modificar**:
  - `supabase-challenges-setup.sql` - Añadir columna `phone` a tabla `challenges`
  - `src/composables/useChallenges.js` - Actualizar funciones para manejar teléfono
  - `src/components/FabUploadButton.vue` - Añadir campo de teléfono en el modal
  - `src/components/ChallengeButton.vue` - Mostrar teléfono del reto
- [ ] **Consideraciones**:
  - Validación de formato de teléfono
  - Opcional u obligatorio según requerimientos
  - Mostrar en la información del reto

#### 2. Crear más de 200 retos
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
1. Añadir teléfono para los retos
2. Crear más de 200 retos

**Media Prioridad:**
- Optimizar rendimiento con muchos retos
- Añadir categorías/filtros de retos
- Mejorar UX para selección de retos

**Baja Prioridad:**
- Estadísticas de retos completados
- Sistema de puntuación
- Retos especiales por fecha/hora

### 📝 Notas de Implementación

#### Para el teléfono:
```sql
-- Ejemplo de modificación en supabase-challenges-setup.sql
ALTER TABLE challenges ADD COLUMN phone TEXT;
-- O si se añade desde el inicio:
phone TEXT,
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

**🔄 En Progreso:**
- Ninguna tarea actualmente

**⏳ Pendiente:**
- Las tareas listadas arriba

---

*Última actualización: $(date)*
