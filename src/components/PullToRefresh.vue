<template>
  <v-sheet
    ref="containerRef" 
    class="pull-to-refresh-container"
    :class="{ 'refreshing': isRefreshing }"
    elevation="0"
  >
    <slot />
  </v-sheet>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

defineProps({
  isRefreshing: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['refresh'])

const containerRef = ref(null)

// Variables para el pull to refresh
let startY = 0
let currentY = 0
let isDragging = false
let pullDistance = 0
const PULL_THRESHOLD = 80

// Pull to refresh handlers
function handleTouchStart(e) {
  if (containerRef.value?.$el?.scrollTop === 0) {
    startY = e.touches[0].clientY
    isDragging = true
  }
}

function handleTouchMove(e) {
  if (!isDragging) return
  
  currentY = e.touches[0].clientY
  pullDistance = Math.max(0, currentY - startY)
  
  if (pullDistance > 0) {
    e.preventDefault()
    
    // Aplicar transformación visual
    if (containerRef.value?.$el) {
      const scale = 1 + (pullDistance / 1000)
      const translateY = pullDistance * 0.3
      containerRef.value.$el.style.transform = `translateY(${translateY}px) scale(${scale})`
      containerRef.value.$el.style.transition = 'none'
    }
  }
}

function handleTouchEnd() {
  if (!isDragging) return
  
  isDragging = false
  
  if (containerRef.value?.$el) {
    containerRef.value.$el.style.transition = 'transform 0.3s ease-out'
    containerRef.value.$el.style.transform = 'translateY(0px) scale(1)'
  }
  
  if (pullDistance > PULL_THRESHOLD) {
    emit('refresh')
  }
  
  pullDistance = 0
}

// Mouse events para desktop (opcional)
function handleMouseDown(e) {
  if (containerRef.value?.$el?.scrollTop === 0) {
    startY = e.clientY
    isDragging = true
  }
}

function handleMouseMove(e) {
  if (!isDragging) return
  
  currentY = e.clientY
  pullDistance = Math.max(0, currentY - startY)
  
  if (pullDistance > 0 && containerRef.value?.$el) {
    const scale = 1 + (pullDistance / 1000)
    const translateY = pullDistance * 0.3
    containerRef.value.$el.style.transform = `translateY(${translateY}px) scale(${scale})`
    containerRef.value.$el.style.transition = 'none'
  }
}

function handleMouseUp() {
  if (!isDragging) return
  
  isDragging = false
  
  if (containerRef.value?.$el) {
    containerRef.value.$el.style.transition = 'transform 0.3s ease-out'
    containerRef.value.$el.style.transform = 'translateY(0px) scale(1)'
  }
  
  if (pullDistance > PULL_THRESHOLD) {
    emit('refresh')
  }
  
  pullDistance = 0
}

onMounted(() => {
  // Agregar event listeners para pull to refresh
  if (containerRef.value?.$el) {
    containerRef.value.$el.addEventListener('touchstart', handleTouchStart, { passive: false })
    containerRef.value.$el.addEventListener('touchmove', handleTouchMove, { passive: false })
    containerRef.value.$el.addEventListener('touchend', handleTouchEnd)
    
    // Mouse events para desktop
    containerRef.value.$el.addEventListener('mousedown', handleMouseDown)
    containerRef.value.$el.addEventListener('mousemove', handleMouseMove)
    containerRef.value.$el.addEventListener('mouseup', handleMouseUp)
    containerRef.value.$el.addEventListener('mouseleave', handleMouseUp)
  }
})

onUnmounted(() => {
  // Limpiar event listeners
  if (containerRef.value?.$el) {
    containerRef.value.$el.removeEventListener('touchstart', handleTouchStart)
    containerRef.value.$el.removeEventListener('touchmove', handleTouchMove)
    containerRef.value.$el.removeEventListener('touchend', handleTouchEnd)
    
    containerRef.value.$el.removeEventListener('mousedown', handleMouseDown)
    containerRef.value.$el.removeEventListener('mousemove', handleMouseMove)
    containerRef.value.$el.removeEventListener('mouseup', handleMouseUp)
    containerRef.value.$el.removeEventListener('mouseleave', handleMouseUp)
  }
})
</script>

<style scoped lang="scss">
.pull-to-refresh-container {
  overflow-y: auto;
  overflow-x: hidden;
  height: 100%;
  will-change: transform;
  
  // Estilos para el pull to refresh
  &::-webkit-scrollbar {
    width: 4px;
  }
  
  &::-webkit-scrollbar-track {
    background: transparent;
  }
  
  &::-webkit-scrollbar-thumb {
    background: rgba(255, 255, 255, 0.2);
    border-radius: 2px;
  }
  
  &.refreshing {
    pointer-events: none;
  }
}
</style>
