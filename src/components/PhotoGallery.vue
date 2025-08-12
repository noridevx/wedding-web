<template>
  <section class="gallery-grid">
    <!-- Filtro de retos -->
    <div class="filter-section">
      <v-btn
        :color="showOnlyChallenges ? 'warning' : 'grey'"
        variant="outlined"
        size="small"
        class="filter-btn"
        @click="toggleChallengeFilter"
      >
        <v-icon
          start
          :color="showOnlyChallenges ? 'warning' : 'grey'"
        >
          mdi-trophy
        </v-icon>
        {{ showOnlyChallenges ? 'Solo Retos' : 'Todas las Fotos' }}
        <v-icon
          end
          :color="showOnlyChallenges ? 'warning' : 'grey'"
        >
          {{ showOnlyChallenges ? 'mdi-check' : 'mdi-filter' }}
        </v-icon>
      </v-btn>
      
      <!-- Contador de fotos -->
      <div class="photo-counter">
        <span class="text-caption">
          {{ filteredPhotos.length }} de {{ photos.length }} fotos
        </span>
      </div>
    </div>

    <div
      v-if="filteredPhotos.length === 0"
      class="empty-state"
    >
      <v-icon
        size="48"
        color="grey-lighten-1"
      >
        {{ showOnlyChallenges ? 'mdi-trophy-off' : 'mdi-image-multiple' }}
      </v-icon>
      <p>
        {{ showOnlyChallenges ? 'No hay fotos de retos aún' : 'No hay fotos subidas aún' }}
      </p>
      <p class="text-caption">
        {{ showOnlyChallenges ? 'Completa algunos retos para ver fotos aquí' : 'Desliza hacia abajo para actualizar' }}
      </p>
    </div>
    <v-row
      v-else
      dense
    >
      <v-col
        v-for="(photo, index) in filteredPhotos"
        :key="photo.id"
        cols="6"
        sm="4"
        md="3"
      >
        <v-card
          class="photo-card"
          :class="{ 'challenge-photo': photo.challenge }"
          elevation="2"
        >
          <div class="photo-container">
            <v-img
              :src="photo.url"
              aspect-ratio="1"
              class="photo-image"
              cover
              @click="showPhotoDetail(index)"
            >
              <template #placeholder>
                <v-row
                  class="fill-height ma-0"
                  align="center"
                  justify="center"
                >
                  <v-progress-circular
                    indeterminate
                    color="grey-lighten-4"
                  />
                </v-row>
              </template>
            </v-img>
            
            <!-- Badge de reto -->
            <div
              v-if="photo.challenge"
              class="challenge-badge"
            >
              <v-icon
                size="16"
                color="white"
              >
                mdi-trophy
              </v-icon>
            </div>
          </div>
          
          <!-- Comentario (si existe) -->
          <v-card-text
            v-if="photo.comment"
            class="photo-comment pa-2"
          >
            <p class="text-caption text-truncate">
              {{ photo.comment }}
            </p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Modal de detalle con navegación -->
    <PhotoDetailModal
      v-model="showDetailModal"
      :photos="filteredPhotos"
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
  },
  filteredPhotos: {
    type: Array,
    default: () => []
  },
  showOnlyChallenges: {
    type: Boolean,
    default: false
  },
  toggleChallengeFilter: {
    type: Function,
    default: () => {}
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
  .filter-section {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 8px;
    padding: 0 4px;
    
    .filter-btn {
      border-radius: 20px;
      text-transform: none;
      font-weight: 500;
      transition: all 0.3s ease;
      
      &:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      }
    }
    
    .photo-counter {
      color: rgba(255, 255, 255, 0.7);
      font-size: 0.875rem;
    }
  }
  
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
    
    // Estilos para fotos de retos
    &.challenge-photo {
      border: 2px solid #FFC107;
      box-shadow: 0 4px 12px rgba(255, 193, 7, 0.3);
      
      &:hover {
        box-shadow: 0 8px 25px rgba(255, 193, 7, 0.4) !important;
      }
    }
    
    .photo-container {
      position: relative;
      
      .challenge-badge {
        position: absolute;
        top: 8px;
        right: 8px;
        background: linear-gradient(135deg, #FFC107, #FF9800);
        border-radius: 50%;
        width: 28px;
        height: 28px;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
        z-index: 2;
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
