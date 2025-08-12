<template>
  <section class="gallery-grid">
    <div v-if="photos.length === 0" class="empty-state">
      <v-icon size="48" color="grey-lighten-1">mdi-image-multiple</v-icon>
      <p>No hay fotos subidas aún</p>
      <p class="text-caption">Desliza hacia abajo para actualizar</p>
    </div>
    <v-row v-else dense>
      <v-col
        v-for="(photo, index) in photos"
        :key="photo.id"
        cols="6"
        sm="4"
        md="3"
      >
        <v-card class="photo-card" elevation="2">
          <v-img
            :src="photo.url"
            aspect-ratio="1"
            class="photo-image"
            cover
            @click="showPhotoDetail(index)"
          >
            <template #placeholder>
              <v-row class="fill-height ma-0" align="center" justify="center">
                <v-progress-circular indeterminate color="grey-lighten-4" />
              </v-row>
            </template>
          </v-img>
          
          <!-- Comentario (si existe) -->
          <v-card-text v-if="photo.comment" class="photo-comment pa-2">
            <p class="text-caption text-truncate">{{ photo.comment }}</p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Modal de detalle con navegación -->
    <PhotoDetailModal
      v-model="showDetailModal"
      :photos="photos"
      :initial-photo-index="selectedPhotoIndex"
    />
  </section>
</template>

<script setup>
import { ref } from 'vue'
import PhotoDetailModal from './PhotoDetailModal.vue'

defineProps({
  photos: {
    type: Array,
    default: () => []
  }
})

const showDetailModal = ref(false)
const selectedPhotoIndex = ref(0)

function showPhotoDetail(index) {
  selectedPhotoIndex.value = index
  showDetailModal.value = true
}
</script>

<style scoped lang="scss">
.gallery-grid {
  .photo-card {
    border-radius: 12px;
    overflow: hidden;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
    
    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15) !important;
    }
    
    .photo-image {
      cursor: pointer;
    }
    
    .photo-comment {
      background: rgba(0, 0, 0, 0.02);
      border-top: 1px solid rgba(0, 0, 0, 0.05);
      
      p {
        margin: 0;
        line-height: 1.4;
      }
    }
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

// Responsive para móviles
@media (max-width: 768px) {
  .gallery-grid {
    .photo-card {
      .photo-comment {
        p {
          font-size: 0.75rem;
        }
      }
    }
  }
}
</style>
