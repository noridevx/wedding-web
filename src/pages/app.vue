<template>
  <div class="app-page">
    <AppHeader :is-refreshing="isRefreshing" />
    
    <main class="app-content">
      <PullToRefresh 
        :is-refreshing="isRefreshing" 
        @refresh="handleRefresh"
      >
        <PhotoUploader 
          @upload-success="handleUploadSuccess"
          @upload-error="handleUploadError"
        />
        
        <PhotoGallery :photos="photos" />
      </PullToRefresh>
    </main>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import AppHeader from '@/components/AppHeader.vue'
import PhotoUploader from '@/components/PhotoUploader.vue'
import PhotoGallery from '@/components/PhotoGallery.vue'
import PullToRefresh from '@/components/PullToRefresh.vue'
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
  alert(`Error uploading: ${errorMessage}`)
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
  background: #0f0f10; /* distinto al sitio principal */
  color: #fff;
  overflow: hidden; // Prevenir scroll del body
}

.app-content {
  padding: 8px 12px 24px;
  
  // Mejoras para dispositivos móviles
  @media (max-width: 768px) {
    padding: 4px 8px 16px;
  }
}
</style>


