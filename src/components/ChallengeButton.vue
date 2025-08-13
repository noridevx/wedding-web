<template>
  <div class="challenge-button-container">
    <!-- Botón de reto -->
    <v-btn
      v-if="currentChallenge"
      color="secondary"
      variant="elevated"
      size="large"
      class="challenge-btn"
      :loading="isLoading"
      @click="openChallengeModal"
    >
      <v-icon start>
        mdi-trophy
      </v-icon>
      ¡Completa un reto!
    </v-btn>

    <!-- Información del reto completado -->
    <div
      v-if="currentChallenge && currentChallenge.is_completed"
      class="completed-challenge-info"
    >
      <v-alert
        type="success"
        variant="tonal"
        class="mb-2"
      >
        <template #prepend>
          <v-icon icon="mdi-check-circle" />
        </template>
        <div class="d-flex align-center justify-space-between">
          <span>¡Reto completado!</span>
          <v-chip
            v-if="currentChallenge.phone"
            color="info"
            variant="outlined"
            size="small"
          >
            <v-icon start size="small">
              mdi-phone
            </v-icon>
            Teléfono registrado
          </v-chip>
          <v-chip
            v-else
            color="warning"
            variant="outlined"
            size="small"
          >
            <v-icon start size="small">
              mdi-phone-off
            </v-icon>
            Sin teléfono
          </v-chip>
        </div>
      </v-alert>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useChallenges } from '@/composables/useChallenges'

const emit = defineEmits(['refresh-photos', 'open-challenge-modal'])

const currentChallenge = ref(null)

const { 
  isLoading: challengesLoading, 
  fetchChallenges, 
  getRandomChallenge,
  reserveChallenge
} = useChallenges()

// Computed para el loading
const isLoading = computed(() => challengesLoading.value)

// Cargar retos al montar el componente
onMounted(async () => {
  await fetchChallenges()
  currentChallenge.value = getRandomChallenge()
})

async function openChallengeModal() {
  if (!currentChallenge.value) return
  
  // Reservar el reto para este dispositivo
  const success = await reserveChallenge(currentChallenge.value.id)
  if (success) {
    // Emitir evento para abrir el modal con el reto actual
    emit('open-challenge-modal', currentChallenge.value)
  }
}

// Función para actualizar el reto (llamada desde el padre)
function updateChallenge() {
  currentChallenge.value = getRandomChallenge()
}

// Exponer función para actualizar reto
defineExpose({
  updateChallenge
})
</script>

<style scoped lang="scss">
.challenge-button-container {
  position: relative;
  padding: 16px;
}

.challenge-btn {
  display: block;
  width: 100%;
  box-shadow: 0 4px 12px rgba(255, 193, 7, 0.3);
  transition: all 0.3s ease;
  
  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(255, 193, 7, 0.4);
  }
}

.completed-challenge-info {
  margin-top: 8px;
}

// Responsive
@media (max-width: 768px) {
  .challenge-btn {
    font-size: 0.9rem;
  }
}
</style>
