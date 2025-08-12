<template>
  <section class="gallery-grid">
    <div v-if="photos.length === 0" class="empty-state">
      <v-icon size="48" color="grey-lighten-1">mdi-image-multiple</v-icon>
      <p>No hay fotos subidas aún</p>
      <p class="text-caption">Desliza hacia abajo para actualizar</p>
    </div>
    <v-row v-else dense>
      <v-col
        v-for="(photo, idx) in photos"
        :key="idx"
        cols="6"
        sm="4"
        md="3"
      >
        <v-img
          :src="photo"
          aspect-ratio="1"
          class="rounded"
          cover
        >
          <template #placeholder>
            <v-row class="fill-height ma-0" align="center" justify="center">
              <v-progress-circular indeterminate color="grey-lighten-4" />
            </v-row>
          </template>
        </v-img>
      </v-col>
    </v-row>
  </section>
</template>

<script setup>
defineProps({
  photos: {
    type: Array,
    default: () => []
  }
})
</script>

<style scoped lang="scss">
.gallery-grid {
  .rounded { 
    border-radius: 10px; 
    overflow: hidden; 
  }
  
  .empty-state {
    text-align: center;
    padding: 48px 16px;
    color: #9e9e9e;
    
    p {
      margin-top: 16px;
      font-size: 1.1rem;
      
      &.text-caption {
        font-size: 0.9rem;
        opacity: 0.7;
        margin-top: 8px;
      }
    }
  }
}
</style>
