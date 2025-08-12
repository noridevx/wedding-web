<template>
  <v-dialog v-model="showModal" max-width="800px" fullscreen>
    <v-card class="photo-detail-modal">
      <!-- Header simplificado -->
      <v-card-title class="d-flex align-center justify-end pa-4">
        <v-btn
          icon="mdi-close"
          variant="text"
          size="small"
          @click="closeModal"
        />
      </v-card-title>
      
      <!-- Contenido principal con swipe -->
      <v-card-text class="pa-0 photo-content">
        <div 
          ref="swipeContainer"
          class="swipe-container"
          @touchstart="handleTouchStart"
          @touchmove="handleTouchMove"
          @touchend="handleTouchEnd"
          @mousedown="handleMouseDown"
          @mousemove="handleMouseMove"
          @mouseup="handleMouseUp"
          @mouseleave="handleMouseUp"
        >
          <!-- Imagen principal -->
          <div 
            class="image-container"
            :style="{ transform: `translateY(${translateY}px) scale(${scale})` }"
          >
            <v-img
              :src="currentPhoto?.url"
              aspect-ratio="1"
              cover
              class="detail-image"
              :loading="imageLoading"
            >
              <template #placeholder>
                <v-row class="fill-height ma-0" align="center" justify="center">
                  <v-progress-circular indeterminate color="grey-lighten-4" />
                </v-row>
              </template>
            </v-img>
          </div>
        </div>
        
        <!-- Comentario -->
        <div class="comment-section pa-4">
          <div v-if="currentPhoto?.comment" class="comment-content">
            <h4 class="text-subtitle-1 mb-2">Comentario:</h4>
            <p class="text-body-2">{{ currentPhoto.comment }}</p>
          </div>
          
          <div v-else class="no-comment">
            <p class="text-caption text-grey">Sin comentario</p>
          </div>
        </div>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { ref, computed, watch } from 'vue'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  photos: {
    type: Array,
    default: () => []
  },
  initialPhotoIndex: {
    type: Number,
    default: 0
  }
})

const emit = defineEmits(['update:modelValue'])

const currentPhotoIndex = ref(props.initialPhotoIndex)
const imageLoading = ref(false)

// Variables para el swipe
const swipeContainer = ref(null)
const startY = ref(0)
const currentY = ref(0)
const isDragging = ref(false)
const translateY = ref(0)
const scale = ref(1)
const SWIPE_THRESHOLD = 100

const showModal = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value)
})

const currentPhoto = computed(() => {
  return props.photos[currentPhotoIndex.value] || null
})

// Navegación con swipe
function handleTouchStart(e) {
  if (props.photos.length <= 1) return
  
  startY.value = e.touches[0].clientY
  isDragging.value = true
  translateY.value = 0
  scale.value = 1
}

function handleTouchMove(e) {
  if (!isDragging.value) return
  
  currentY.value = e.touches[0].clientY
  const deltaY = currentY.value - startY.value
  
  // Aplicar transformación visual
  translateY.value = deltaY * 0.5
  scale.value = 1 - Math.abs(deltaY) / 1000
  
  e.preventDefault()
}

function handleTouchEnd() {
  if (!isDragging.value) return
  
  const deltaY = currentY.value - startY.value
  
  if (Math.abs(deltaY) > SWIPE_THRESHOLD) {
    if (deltaY > 0 && currentPhotoIndex.value > 0) {
      // Swipe hacia abajo - foto anterior
      previousPhoto()
    } else if (deltaY < 0 && currentPhotoIndex.value < props.photos.length - 1) {
      // Swipe hacia arriba - foto siguiente
      nextPhoto()
    }
  }
  
  // Reset transformación
  translateY.value = 0
  scale.value = 1
  isDragging.value = false
}

// Mouse events para desktop
function handleMouseDown(e) {
  if (props.photos.length <= 1) return
  
  startY.value = e.clientY
  isDragging.value = true
  translateY.value = 0
  scale.value = 1
}

function handleMouseMove(e) {
  if (!isDragging.value) return
  
  currentY.value = e.clientY
  const deltaY = currentY.value - startY.value
  
  // Aplicar transformación visual
  translateY.value = deltaY * 0.5
  scale.value = 1 - Math.abs(deltaY) / 1000
}

function handleMouseUp() {
  if (!isDragging.value) return
  
  const deltaY = currentY.value - startY.value
  
  if (Math.abs(deltaY) > SWIPE_THRESHOLD) {
    if (deltaY > 0 && currentPhotoIndex.value > 0) {
      // Swipe hacia abajo - foto anterior
      previousPhoto()
    } else if (deltaY < 0 && currentPhotoIndex.value < props.photos.length - 1) {
      // Swipe hacia arriba - foto siguiente
      nextPhoto()
    }
  }
  
  // Reset transformación
  translateY.value = 0
  scale.value = 1
  isDragging.value = false
}

// Navegación
function nextPhoto() {
  if (currentPhotoIndex.value < props.photos.length - 1) {
    currentPhotoIndex.value++
    imageLoading.value = true
    setTimeout(() => {
      imageLoading.value = false
    }, 100)
  }
}

function previousPhoto() {
  if (currentPhotoIndex.value > 0) {
    currentPhotoIndex.value--
    imageLoading.value = true
    setTimeout(() => {
      imageLoading.value = false
    }, 100)
  }
}

function closeModal() {
  showModal.value = false
}

// Navegación con teclado
function handleKeydown(event) {
  if (!showModal.value) return
  
  switch (event.key) {
    case 'ArrowUp':
      event.preventDefault()
      nextPhoto()
      break
    case 'ArrowDown':
      event.preventDefault()
      previousPhoto()
      break
    case 'Escape':
      event.preventDefault()
      closeModal()
      break
  }
}

// Event listeners para navegación con teclado
watch(showModal, (isOpen) => {
  if (isOpen) {
    document.addEventListener('keydown', handleKeydown)
    // Reset al índice inicial cuando se abre el modal
    currentPhotoIndex.value = props.initialPhotoIndex
  } else {
    document.removeEventListener('keydown', handleKeydown)
  }
})

// Limpiar event listener al desmontar
import { onUnmounted } from 'vue'
onUnmounted(() => {
  document.removeEventListener('keydown', handleKeydown)
})
</script>

<style scoped lang="scss">
.photo-detail-modal {
  background: #0f0f10;
  color: #fff;
  height: 100vh;
  display: flex;
  flex-direction: column;
}

.photo-content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.swipe-container {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 70vh;
  overflow: hidden;
  cursor: grab;
  
  &:active {
    cursor: grabbing;
  }
}

.image-container {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  max-width: 100%;
  max-height: 100%;
  transition: transform 0.3s ease-out;
  will-change: transform;
}

.detail-image {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
  border-radius: 8px;
  user-select: none;
  pointer-events: none;
}

.comment-section {
  background: rgba(255, 255, 255, 0.05);
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  
  .comment-content {
    background: rgba(25, 118, 210, 0.1);
    padding: 16px;
    border-radius: 8px;
    border-left: 4px solid #1976d2;
    
    h4 {
      color: #1976d2;
      margin: 0 0 8px 0;
      font-weight: 500;
    }
    
    p {
      margin: 0;
      line-height: 1.5;
      color: rgba(255, 255, 255, 0.9);
    }
  }
  
  .no-comment {
    text-align: center;
    padding: 20px;
    background: rgba(255, 255, 255, 0.02);
    border-radius: 8px;
    
    p {
      margin: 0;
      color: rgba(255, 255, 255, 0.5);
    }
  }
}

// Responsive para móviles
@media (max-width: 768px) {
  .swipe-container {
    min-height: 60vh;
  }
  
  .comment-section {
    padding: 12px;
    
    .comment-content {
      padding: 12px;
    }
  }
}

// Animaciones
.image-container {
  transition: transform 0.3s ease-out;
}

// Mejoras de accesibilidad
.swipe-container:focus {
  outline: none;
}

// Indicador visual de swipe (opcional)
.swipe-container::before {
  content: '';
  position: absolute;
  top: 20px;
  left: 50%;
  transform: translateX(-50%);
  width: 40px;
  height: 4px;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 2px;
  opacity: 0.7;
}
</style>
