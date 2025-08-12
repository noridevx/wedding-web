# Componentes de la Aplicación

Esta carpeta contiene todos los componentes reutilizables de la aplicación de fotos de boda.

## Estructura de Componentes

### 📱 AppHeader.vue
**Propósito**: Header principal de la aplicación con indicador de refresh
**Props**:
- `isRefreshing` (Boolean): Estado de actualización

### 📤 PhotoUploader.vue
**Propósito**: Componente para subir fotos a Supabase Storage
**Props**: Ninguna
**Events**:
- `upload-success`: Emitido cuando la subida es exitosa
- `upload-error`: Emitido cuando hay un error en la subida

### 🖼️ PhotoGallery.vue
**Propósito**: Galería de fotos con grid responsive
**Props**:
- `photos` (Array): Array de URLs de fotos

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
- `photos`: Array reactivo de fotos
- `isRefreshing`: Estado de actualización
- `listPhotos()`: Función para cargar fotos
- `refresh()`: Función para actualizar la galería

## Uso

```vue
<template>
  <div class="app">
    <AppHeader :is-refreshing="isRefreshing" />
    
    <PullToRefresh @refresh="refresh">
      <PhotoUploader 
        @upload-success="handleUploadSuccess"
        @upload-error="handleUploadError"
      />
      <PhotoGallery :photos="photos" />
    </PullToRefresh>
  </div>
</template>

<script setup>
import { usePhotoGallery } from '@/composables/usePhotoGallery'

const { photos, isRefreshing, refresh } = usePhotoGallery()
</script>
```

## Beneficios de esta Arquitectura

1. **Reutilización**: Los componentes pueden usarse en otras partes de la app
2. **Mantenibilidad**: Cada componente tiene una responsabilidad específica
3. **Testabilidad**: Es más fácil testear componentes pequeños
4. **Escalabilidad**: Fácil agregar nuevas funcionalidades
5. **Separación de Concerns**: UI separada de la lógica de negocio
