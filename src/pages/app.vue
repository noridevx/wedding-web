<template>
  <div class="app-page">
    <AppHeader :is-refreshing="isRefreshing" />

    <!-- Botón de reto -->
    <ChallengeButton 
      ref="challengeButtonRef"
      @refresh-photos="handleRefreshPhotos"
      @open-challenge-modal="openChallengeModal"
    />
    
    <main class="app-content">
      <PhotoGallery 
        :photos="photos" 
        :filtered-photos="filteredPhotos"
        :show-only-challenges="showOnlyChallenges"
        :toggle-challenge-filter="toggleChallengeFilter"
      />
    </main>
    
    <!-- FAB Button para subir fotos -->
    <FabUploadButton 
      ref="fabButtonRef"
      :force-challenge="forcedChallenge"
      @upload-success="handleUploadSuccess"
      @upload-error="handleUploadError"
      @refresh-photos="handleRefreshPhotos"
      @modal-opened="handleModalOpened"
    />
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import AppHeader from '@/components/AppHeader.vue'
import PhotoGallery from '@/components/PhotoGallery.vue'
import FabUploadButton from '@/components/FabUploadButton.vue'
import ChallengeButton from '@/components/ChallengeButton.vue'
import { usePhotoGallery } from '@/composables/usePhotoGallery'
import { useChallenges } from '@/composables/useChallenges'

const { photos, filteredPhotos, isRefreshing, showOnlyChallenges, listPhotos, toggleChallengeFilter } = usePhotoGallery()
const { fetchChallenges } = useChallenges()

const challengeButtonRef = ref(null)
const fabButtonRef = ref(null)
const forcedChallenge = ref(null)

function handleUploadSuccess() {
  // Refrescar la galería después de una subida exitosa
  listPhotos()
}

function handleRefreshPhotos() {
  // Refrescar la galería después de completar un reto
  listPhotos()
  // Obtener nuevo reto
  if (challengeButtonRef.value) {
    challengeButtonRef.value.updateChallenge()
  }
}

function openChallengeModal(challenge) {
  // Forzar el reto en el FAB button y abrir el modal
  forcedChallenge.value = challenge
  // Abrir el modal del FAB button
  if (fabButtonRef.value) {
    fabButtonRef.value.openModal()
  }
}

function handleModalOpened(type) {
  if (type === 'normal') {
    // Limpiar el reto forzado cuando se abre el modal normal
    forcedChallenge.value = null
  }
}

function handleUploadError(errorMessage) {
  console.error('Upload error:', errorMessage)
}

onMounted(async () => {
  listPhotos()
  await fetchChallenges()
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


