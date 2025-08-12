<template>
  <section class="gallery-grid">
    <div v-if="photos.length === 0" class="empty-state">
      <v-icon size="48" color="grey-lighten-1">mdi-image-multiple</v-icon>
      <p>No hay fotos subidas aún</p>
      <p class="text-caption">Desliza hacia abajo para actualizar</p>
    </div>
    <v-row v-else dense>
      <v-col
        v-for="photo in photos"
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
            @click="showPhotoDetail(photo)"
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

    <!-- Modal para ver foto en detalle -->
    <v-dialog v-model="showDetailModal" max-width="600px">
      <v-card>
        <v-card-title class="d-flex align-center justify-space-between">
          <span>Detalle de la Foto</span>
          <v-btn
            icon="mdi-close"
            variant="text"
            size="small"
            @click="showDetailModal = false"
          />
        </v-card-title>
        
        <v-card-text class="pa-0">
          <v-img
            :src="selectedPhoto?.url"
            aspect-ratio="1"
            cover
            class="detail-image"
          />
          
          <div class="pa-4">
            <!-- Información de la foto -->
            <div class="photo-info mb-3">
              <v-chip size="small" color="info" variant="outlined">
                {{ selectedPhoto?.fileName }}
              </v-chip>
              <v-chip size="small" color="success" variant="outlined" class="ml-2">
                {{ formatFileSize(selectedPhoto?.fileSize) }}
              </v-chip>
              <v-chip size="small" color="warning" variant="outlined" class="ml-2">
                {{ formatDate(selectedPhoto?.uploadedAt) }}
              </v-chip>
            </div>
            
            <!-- Comentario completo -->
            <div v-if="selectedPhoto?.comment" class="comment-section">
              <h4 class="text-subtitle-1 mb-2">Comentario:</h4>
              <p class="text-body-2">{{ selectedPhoto.comment }}</p>
            </div>
            
            <div v-else class="no-comment">
              <p class="text-caption text-grey">Sin comentario</p>
            </div>
          </div>
        </v-card-text>
      </v-card>
    </v-dialog>
  </section>
</template>

<script setup>
import { ref } from 'vue'

const props = defineProps({
  photos: {
    type: Array,
    default: () => []
  }
})

const showDetailModal = ref(false)
const selectedPhoto = ref(null)

function showPhotoDetail(photo) {
  selectedPhoto.value = photo
  showDetailModal.value = true
}

function formatFileSize(bytes) {
  if (!bytes) return '0 Bytes'
  const k = 1024
  const sizes = ['Bytes', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

function formatDate(dateString) {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('es-ES', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
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

.detail-image {
  border-radius: 8px 8px 0 0;
}

.photo-info {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.comment-section {
  background: rgba(0, 0, 0, 0.02);
  padding: 12px;
  border-radius: 8px;
  border-left: 4px solid #1976d2;
  
  h4 {
    color: #1976d2;
    margin: 0;
  }
  
  p {
    margin: 0;
    line-height: 1.5;
  }
}

.no-comment {
  text-align: center;
  padding: 20px;
  background: rgba(0, 0, 0, 0.02);
  border-radius: 8px;
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
