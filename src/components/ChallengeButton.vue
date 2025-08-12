<template>
  <div class="challenge-button-container">
    <!-- Botón principal -->
    <v-btn
      v-if="!showModal && currentChallenge"
      color="secondary"
      variant="elevated"
      size="large"
      class="challenge-btn"
      :loading="isLoading"
      @click="showModal = true"
    >
      <v-icon start>
        mdi-trophy
      </v-icon>
      ¡Completa un reto!
    </v-btn>

    <!-- Modal del reto -->
    <v-dialog
      v-model="showModal"
      max-width="600px"
      persistent
    >
      <v-card class="challenge-modal-card">
        <!-- Cabecera -->
        <v-card-title class="d-flex align-center justify-space-between challenge-modal-header">
          <div class="d-flex align-center">
            <v-icon
              color="warning"
              class="mr-2"
            >
              mdi-trophy
            </v-icon>
            <span>¡Nuevo Reto!</span>
          </div>
          <v-btn
            icon="mdi-close"
            variant="text"
            size="small"
            @click="closeModal"
          />
        </v-card-title>

        <!-- Contenido -->
        <div class="challenge-modal-content">
          <v-card-text v-if="currentChallenge">
            <!-- Información del reto -->
            <div class="challenge-info">
              <h3 class="text-h5 mb-3 font-dancing">
                ¡Nuevo Reto!
              </h3>
              <p class="text-body-1 mb-4">
                {{ currentChallenge.description }}
              </p>
              
              <!-- Estado del reto -->
              <v-chip
                :color="currentChallenge.is_completed ? 'success' : 'warning'"
                variant="outlined"
                class="mb-4"
              >
                <v-icon start>
                  {{ currentChallenge.is_completed ? 'mdi-check-circle' : 'mdi-clock-outline' }}
                </v-icon>
                {{ currentChallenge.is_completed ? 'Completado' : 'Pendiente' }}
              </v-chip>
            </div>

            <!-- Componente de subida de foto -->
            <ChallengeUploadForm
              :challenge="currentChallenge"
              @upload-success="handleUploadSuccess"
              @upload-error="handleUploadError"
              @close="closeModal"
            />
          </v-card-text>
        </div>
      </v-card>
    </v-dialog>

    <!-- Snackbar para notificaciones -->
    <v-snackbar
      v-model="showSnackbar"
      :color="snackbarColor"
      :timeout="3000"
    >
      {{ snackbarMessage }}
    </v-snackbar>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import ChallengeUploadForm from './ChallengeUploadForm.vue'
import { useChallenges } from '@/composables/useChallenges'

const showModal = ref(false)
const currentChallenge = ref(null)
const showSnackbar = ref(false)
const snackbarMessage = ref('')
const snackbarColor = ref('success')

const { 
  isLoading, 
  fetchChallenges, 
  getRandomChallenge 
} = useChallenges()

// Cargar retos al montar el componente
onMounted(async () => {
  await fetchChallenges()
  currentChallenge.value = getRandomChallenge()
})

function handleUploadSuccess() {
  showNotification('¡Reto completado exitosamente!', 'success')
  // Actualizar el reto actual
  currentChallenge.value = getRandomChallenge()
}

function handleUploadError(errorMessage) {
  showNotification(`Error: ${errorMessage}`, 'error')
}

function showNotification(message, type = 'success') {
  snackbarMessage.value = message
  snackbarColor.value = type
  showSnackbar.value = true
}

function closeModal() {
  showModal.value = false
}
</script>

<style scoped lang="scss">
.challenge-button-container {
  position: relative;
}

.challenge-btn {
  margin: 16px auto;
  display: block;
  box-shadow: 0 4px 12px rgba(255, 193, 7, 0.3);
  transition: all 0.3s ease;
  
  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(255, 193, 7, 0.4);
  }
}

.challenge-modal-card {
  display: flex;
  flex-direction: column;
  max-height: 90vh;
}

.challenge-modal-header {
  flex-shrink: 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  background: linear-gradient(135deg, #FFC107, #FF9800);
  color: #000;
}

.challenge-modal-content {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
}

.challenge-info {
  text-align: center;
  padding: 16px 0;
  
  h3 {
    color: #FFC107;
    font-weight: 600;
  }
  
  p {
    color: #F1F5F9;
    line-height: 1.6;
  }
}

// Responsive
@media (max-width: 768px) {
  .challenge-btn {
    margin: 12px auto;
    font-size: 0.9rem;
  }
  
  .challenge-modal-card {
    max-height: 95vh;
  }
}
</style>
