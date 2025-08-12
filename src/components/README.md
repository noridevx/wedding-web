# Componentes de la Aplicación

Esta carpeta contiene todos los componentes reutilizables de la aplicación de fotos de boda.

## Estructura de Componentes

### 📱 AppHeader.vue
**Propósito**: Header principal de la aplicación con indicador de refresh
**Props**:
- `isRefreshing` (Boolean): Estado de actualización

### 🔘 FabUploadButton.vue
**Propósito**: FAB button con modal para subir fotos y comentarios
**Props**: Ninguna
**Events**:
- `upload-success`: Emitido cuando la subida es exitosa
- `upload-error`: Emitido cuando hay un error en la subida
**Características**:
- FAB button flotante con icono de plus
- Modal con vista previa de imagen
- Campo de comentario opcional
- Validación de archivos
- Notificaciones con snackbar

### 🖼️ PhotoGallery.vue
**Propósito**: Galería de fotos con grid responsive y comentarios
**Props**:
- `photos` (Array): Array de objetos de fotos con comentarios
**Características**:
- Grid responsive
- Tarjetas con hover effects
- Integración con PhotoDetailModal
- Visualización de comentarios en tarjetas

### 🔍 PhotoDetailModal.vue
**Propósito**: Modal de detalle con navegación entre fotos
**Props**:
- `modelValue` (Boolean): Control de visibilidad del modal
- `photos` (Array): Array de fotos para navegar
- `initialPhotoIndex` (Number): Índice inicial de la foto
**Events**:
- `update:modelValue`: Emitido para controlar visibilidad
**Características**:
- Modal fullscreen
- Navegación con flechas (izquierda/derecha)
- Navegación con teclado (flechas, Escape)
- Indicadores de posición (puntos)
- Contador de fotos (X / Y)
- Comentarios completos
- Diseño responsive

### 🔄 PullToRefresh.vue
**Propósito**: Componente reutilizable para pull-to-refresh
**Props**:
- `isRefreshing` (Boolean): Estado de actualización
**Events**:
- `refresh`: Emitido cuando se activa el pull-to-refresh
**Slots**: Contenido que se puede hacer pull-to-refresh

## Composable

### 📚 usePhotoGallery.js
**Propósito**: Lógica reutilizable para manejar la galería de fotos
**Returns**:
- `photos`: Array reactivo de fotos con comentarios
- `isRefreshing`: Estado de actualización
- `listPhotos()`: Función para cargar fotos desde la tabla
- `refresh()`: Función para actualizar la galería

## Estructura de Datos

### Objeto Foto
```javascript
{
  id: "uuid",
  url: "https://...",
  comment: "Comentario opcional",
  fileName: "imagen.jpg",
  fileSize: 1024000,
  uploadedAt: "2024-01-15T10:30:00Z"
}
```

## Uso

```vue
<template>
  <div class="app">
    <AppHeader :is-refreshing="isRefreshing" />
    
    <PullToRefresh @refresh="refresh">
      <PhotoGallery :photos="photos" />
    </PullToRefresh>
    
    <FabUploadButton 
      @upload-success="handleUploadSuccess"
      @upload-error="handleUploadError"
    />
  </div>
</template>

<script setup>
import { usePhotoGallery } from '@/composables/usePhotoGallery'

const { photos, isRefreshing, refresh } = usePhotoGallery()
</script>
```

## Configuración de Supabase

### Tabla `photos`
Ejecuta el script `supabase-setup.sql` en tu dashboard de Supabase para crear la tabla necesaria.

**Campos**:
- `id`: UUID primario
- `file_path`: Ruta en storage
- `file_name`: Nombre original
- `file_size`: Tamaño en bytes
- `file_type`: Tipo MIME
- `public_url`: URL pública
- `comment`: Comentario opcional
- `uploaded_at`: Fecha de subida
- `created_at`: Fecha de creación

## Navegación en el Modal

### Controles de Navegación
- **Flechas**: Botones izquierda/derecha en pantalla
- **Teclado**: 
  - `←` / `→`: Navegar entre fotos
  - `Escape`: Cerrar modal
- **Indicadores**: Puntos en la parte inferior para ir directamente a una foto
- **Contador**: Muestra posición actual (ej: "3 / 10")

### Características de UX
- **Fullscreen**: Modal ocupa toda la pantalla
- **Responsive**: Adaptado para móviles y desktop
- **Accesibilidad**: Controles de teclado y focus visible
- **Animaciones**: Transiciones suaves entre fotos
- **Loading**: Indicador de carga al cambiar fotos

## Beneficios de esta Arquitectura

1. **Reutilización**: Los componentes pueden usarse en otras partes de la app
2. **Mantenibilidad**: Cada componente tiene una responsabilidad específica
3. **Testabilidad**: Es más fácil testear componentes pequeños
4. **Escalabilidad**: Fácil agregar nuevas funcionalidades
5. **Separación de Concerns**: UI separada de la lógica de negocio
6. **UX Mejorada**: FAB button más intuitivo que formulario tradicional
7. **Persistencia**: Comentarios guardados en base de datos
8. **Feedback Visual**: Notificaciones y estados de carga claros
9. **Navegación Avanzada**: Modal con navegación completa entre fotos
10. **Accesibilidad**: Controles de teclado y navegación por puntos
