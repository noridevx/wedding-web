<template>
  <div class="app-page">
    <AppHeader :is-refreshing="isRefreshing" />
    
    <main class="app-content">
      <PhotoGallery :photos="photos" />
    </main>
    
    <!-- FAB Button para subir fotos -->
    <FabUploadButton 
      @upload-success="handleUploadSuccess"
      @upload-error="handleUploadError"
    />
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import AppHeader from '@/components/AppHeader.vue'
import PhotoGallery from '@/components/PhotoGallery.vue'
import FabUploadButton from '@/components/FabUploadButton.vue'
import { usePhotoGallery } from '@/composables/usePhotoGallery'

const { photos, isRefreshing, listPhotos, refresh } = usePhotoGallery()

function handleRefresh() {
  refresh()
}

function handleUploadSuccess() {
  // Refrescar la galería después de una subida exitosa
  listPhotos()
}

function handleUploadError(errorMessage) {
  console.error('Upload error:', errorMessage)
}

onMounted(() => {
  listPhotos()
})
</script>

<style scoped lang="scss">
.app-page {
  display: grid;
  grid-template-rows: auto 1fr;
  min-height: 100vh;
  background: #0F0F23; /* Coincide con el nuevo tema */
  color: #F1F5F9;
  position: relative; // Necesario para el v-fab
  overflow: hidden; // Restaurar para evitar scroll del body
}

.app-content {
  padding: 8px 12px 24px;
  overflow: hidden; // Contener el scroll dentro del área de contenido
  
  // Mejoras para dispositivos móviles
  @media (max-width: 768px) {
    padding: 4px 8px 16px;
  }
}
</style>


