<template>
  <v-app-bar
    color="rgba(30, 27, 75, 0.9)"
    elevation="0"
    class="app-header"
  >
    <h2 class="font-dancing text-center ma-auto">
      Elena & Sergio
    </h2>
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
@import url('https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400..700&display=swap');
.font-dancing {
    font-family: "Dancing Script", serif;
    font-optical-sizing: auto;
    h1 {
        font-size: 5rem;
    }
    h3 {
        font-size: 2rem;
    }
}
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
