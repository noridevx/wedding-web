<template>
  <v-app-bar
    color="rgba(15, 15, 16, 0.8)"
    elevation="0"
    class="app-header"
  >
    <v-container class="d-flex align-center justify-space-between">
      <h2 class="font-dancing mb-0">
        Boda · Fotos
      </h2>
      <div class="d-flex align-center">
        <v-icon 
          v-if="isRefreshing" 
          size="small" 
          class="rotating mr-1"
          color="blue-lighten-2"
        >
          mdi-refresh
        </v-icon>
        <span 
          v-if="isRefreshing" 
          class="text-caption text-blue-lighten-2"
        >
          Actualizando...
        </span>
      </div>
    </v-container>
  </v-app-bar>
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
  backdrop-filter: blur(6px);
  z-index: 2;
  
  .rotating {
    animation: rotate 1s linear infinite;
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
