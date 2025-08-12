<template>
  <header class="app-header">
    <h2 class="font-dancing">Boda · Fotos</h2>
    <div class="refresh-indicator" :class="{ 'refreshing': isRefreshing }">
      <v-icon v-if="isRefreshing" size="small" class="rotating">mdi-refresh</v-icon>
      <span v-if="isRefreshing" class="ml-1">Actualizando...</span>
    </div>
  </header>
</template>

<script setup>
defineProps({
  isRefreshing: {
    type: Boolean,
    default: false
  }
})
</script>

<style scoped lang="scss">
.app-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  position: sticky;
  top: 0;
  background: rgba(15, 15, 16, 0.8);
  backdrop-filter: blur(6px);
  z-index: 2;
  
  .refresh-indicator {
    display: flex;
    align-items: center;
    font-size: 0.9rem;
    color: #9e9e9e;
    
    &.refreshing {
      color: #64b5f6;
    }
    
    .rotating {
      animation: rotate 1s linear infinite;
    }
  }
}

@keyframes rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}
</style>
