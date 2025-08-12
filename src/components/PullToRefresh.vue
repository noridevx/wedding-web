<template>
  <div 
    ref="containerRef" 
    class="pull-to-refresh-container"
    :class="{ 'refreshing': isRefreshing }"
  >
    <slot />
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const props = defineProps({
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
  if (containerRef.value?.scrollTop === 0) {
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
    if (containerRef.value) {
      const scale = 1 + (pullDistance / 1000)
      const translateY = pullDistance * 0.3
      containerRef.value.style.transform = `translateY(${translateY}px) scale(${scale})`
      containerRef.value.style.transition = 'none'
    }
  }
}

function handleTouchEnd() {
  if (!isDragging) return
  
  isDragging = false
  
  if (containerRef.value) {
    containerRef.value.style.transition = 'transform 0.3s ease-out'
    containerRef.value.style.transform = 'translateY(0px) scale(1)'
  }
  
  if (pullDistance > PULL_THRESHOLD) {
    emit('refresh')
  }
  
  pullDistance = 0
}

// Mouse events para desktop (opcional)
function handleMouseDown(e) {
  if (containerRef.value?.scrollTop === 0) {
    startY = e.clientY
    isDragging = true
  }
}

function handleMouseMove(e) {
  if (!isDragging) return
  
  currentY = e.clientY
  pullDistance = Math.max(0, currentY - startY)
  
  if (pullDistance > 0 && containerRef.value) {
    const scale = 1 + (pullDistance / 1000)
    const translateY = pullDistance * 0.3
    containerRef.value.style.transform = `translateY(${translateY}px) scale(${scale})`
    containerRef.value.style.transition = 'none'
  }
}

function handleMouseUp() {
  if (!isDragging) return
  
  isDragging = false
  
  if (containerRef.value) {
    containerRef.value.style.transition = 'transform 0.3s ease-out'
    containerRef.value.style.transform = 'translateY(0px) scale(1)'
  }
  
  if (pullDistance > PULL_THRESHOLD) {
    emit('refresh')
  }
  
  pullDistance = 0
}

onMounted(() => {
  // Agregar event listeners para pull to refresh
  if (containerRef.value) {
    containerRef.value.addEventListener('touchstart', handleTouchStart, { passive: false })
    containerRef.value.addEventListener('touchmove', handleTouchMove, { passive: false })
    containerRef.value.addEventListener('touchend', handleTouchEnd)
    
    // Mouse events para desktop
    containerRef.value.addEventListener('mousedown', handleMouseDown)
    containerRef.value.addEventListener('mousemove', handleMouseMove)
    containerRef.value.addEventListener('mouseup', handleMouseUp)
    containerRef.value.addEventListener('mouseleave', handleMouseUp)
  }
})

onUnmounted(() => {
  // Limpiar event listeners
  if (containerRef.value) {
    containerRef.value.removeEventListener('touchstart', handleTouchStart)
    containerRef.value.removeEventListener('touchmove', handleTouchMove)
    containerRef.value.removeEventListener('touchend', handleTouchEnd)
    
    containerRef.value.removeEventListener('mousedown', handleMouseDown)
    containerRef.value.removeEventListener('mousemove', handleMouseMove)
    containerRef.value.removeEventListener('mouseup', handleMouseUp)
    containerRef.value.removeEventListener('mouseleave', handleMouseUp)
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
