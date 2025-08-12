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
  getRandomChallenge 
} = useChallenges()

// Computed para el loading
const isLoading = computed(() => challengesLoading.value)

// Cargar retos al montar el componente
onMounted(async () => {
  await fetchChallenges()
  currentChallenge.value = getRandomChallenge()
})

function openChallengeModal() {
  // Emitir evento para abrir el modal con el reto actual
  emit('open-challenge-modal', currentChallenge.value)
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

// Responsive
@media (max-width: 768px) {
  .challenge-btn {
    margin: 12px auto;
    font-size: 0.9rem;
  }
}
</style>
