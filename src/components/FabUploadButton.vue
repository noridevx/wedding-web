<template>
  <!-- FAB Button -->
  <v-btn
    icon="mdi-plus"
    color="primary"
    size="x-large"
    class="fab-button"
    @click="showModal = true"
  />

  <!-- Modal para subir fotos -->
  <v-dialog
    v-model="showModal"
    max-width="500px"
    persistent
  >
    <v-card>
      <v-card-title class="d-flex align-center justify-space-between">
        <span>Subir Foto</span>
        <v-btn
          icon="mdi-close"
          variant="text"
          size="small"
          @click="closeModal"
        />
      </v-card-title>

      <v-card-text>
        <v-form
          ref="form"
          @submit.prevent="handleUpload"
        >
          <!-- Selector de archivo -->
          <v-file-input
            v-model="selectedFile"
            accept="image/*"
            prepend-icon="mdi-image"
            label="Seleccionar foto"
            :rules="fileRules"
            :error-messages="fileError"
            @change="validateFile"
          />

          <!-- Vista previa de la imagen -->
          <div
            v-if="imagePreview"
            class="image-preview-container"
          >
            <v-img
              :src="imagePreview"
              aspect-ratio="1"
              class="rounded"
              cover
              max-height="200"
            />
          </div>

          <!-- Campo de comentario -->
          <v-textarea
            v-model="comment"
            label="Comentario (opcional)"
            placeholder="Añade un comentario a tu foto..."
            rows="3"
            auto-grow
            variant="outlined"
            class="mt-4"
          />

          <!-- Información del archivo -->
          <div
            v-if="selectedFile"
            class="file-info mt-3"
          >
            <v-chip
              size="small"
              color="info"
              variant="outlined"
            >
              {{ selectedFile.name }}
            </v-chip>
            <v-chip
              size="small"
              color="success"
              variant="outlined"
              class="ml-2"
            >
              {{ formatFileSize(selectedFile.size) }}
            </v-chip>
          </div>
        </v-form>
      </v-card-text>

      <v-card-actions class="pa-4">
        <v-spacer />
        <v-btn
          variant="outlined"
          :disabled="isUploading"
          @click="closeModal"
        >
          Cancelar
        </v-btn>
        <v-btn
          color="primary"
          :loading="isUploading"
          :disabled="!selectedFile || isUploading"
          @click="handleUpload"
        >
          {{ isUploading ? 'Subiendo...' : 'Subir Foto' }}
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>

  <!-- Snackbar para notificaciones -->
  <v-snackbar
    v-model="showSnackbar"
    :color="snackbarColor"
    :timeout="3000"
  >
    {{ snackbarMessage }}
  </v-snackbar>
</template>

<script setup>
import { ref, computed } from 'vue'
import { supabase, SUPABASE_BUCKET, SUPABASE_FOLDER } from '@/lib/supabase'

const emit = defineEmits(['upload-success', 'upload-error'])

const showModal = ref(false)
const selectedFile = ref(null)
const comment = ref('')
const isUploading = ref(false)
const showSnackbar = ref(false)
const snackbarMessage = ref('')
const snackbarColor = ref('success')
const fileError = ref('')



const fileRules = [
  value => {
    if (!value) return 'Selecciona una imagen'
    if (!value.type.startsWith('image/')) return 'El archivo debe ser una imagen'
    if (value.size > 10 * 1024 * 1024) return 'El archivo no puede ser mayor a 10MB'
    return true
  }
]

const imagePreview = computed(() => {
  if (!selectedFile.value) return null
  return URL.createObjectURL(selectedFile.value)
})

function validateFile() {
  fileError.value = ''
  if (!selectedFile.value) return

  const validation = fileRules[0](selectedFile.value)
  if (validation !== true) {
    fileError.value = validation
    selectedFile.value = null
  }
}

function formatFileSize(bytes) {
  if (bytes === 0) return '0 Bytes'
  const k = 1024
  const sizes = ['Bytes', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

async function handleUpload() {
  if (!selectedFile.value || !supabase) return

  isUploading.value = true
  try {
    // Crear nombre único para el archivo
    const timestamp = Date.now()
    const safeName = selectedFile.value.name.replace(/[^a-zA-Z0-9.-]/g, '_')
    const filepath = `${SUPABASE_FOLDER}/${timestamp}-${safeName}`

    console.log('Uploading:', filepath, 'Size:', selectedFile.value.size, 'Type:', selectedFile.value.type)

    // Subir archivo a Supabase Storage
    const { data: uploadData, error: uploadError } = await supabase.storage
      .from(SUPABASE_BUCKET)
      .upload(filepath, selectedFile.value, {
        upsert: false,
        contentType: selectedFile.value.type
      })

    if (uploadError) {
      throw uploadError
    }

    // Obtener URL pública de la imagen
    const { data: urlData } = supabase.storage
      .from(SUPABASE_BUCKET)
      .getPublicUrl(filepath)

    // Guardar información en la tabla de fotos
    const { data: photoData, error: photoError } = await supabase
      .from('photos')
      .insert([
        {
          file_path: filepath,
          file_name: selectedFile.value.name,
          file_size: selectedFile.value.size,
          file_type: selectedFile.value.type,
          public_url: urlData.publicUrl,
          comment: comment.value || null,
          uploaded_at: new Date().toISOString()
        }
      ])
      .select()

    if (photoError) {
      console.error('Error saving photo data:', photoError)
      // Si falla el guardado en la tabla, eliminar el archivo subido
      await supabase.storage.from(SUPABASE_BUCKET).remove([filepath])
      throw photoError
    }

    console.log('Upload success:', photoData)
    
    // Mostrar notificación de éxito
    showNotification('Foto subida exitosamente', 'success')
    
    // Emitir evento de éxito
    emit('upload-success', photoData[0])
    
    // Limpiar formulario
    closeModal()
    
  } catch (error) {
    console.error('Upload failed:', error)
    showNotification(`Error al subir la foto: ${error.message}`, 'error')
    emit('upload-error', error.message)
  } finally {
    isUploading.value = false
  }
}

function showNotification(message, type = 'success') {
  snackbarMessage.value = message
  snackbarColor.value = type
  showSnackbar.value = true
}

function closeModal() {
  showModal.value = false
  selectedFile.value = null
  comment.value = ''
  fileError.value = ''
}
</script>

<style scoped lang="scss">
.fab-button {
  position: fixed !important;
  bottom: 24px !important;
  right: 24px !important;
  z-index: 9999 !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3) !important;
}

.image-preview-container {
  margin-top: 16px;
  text-align: center;
  
  .rounded {
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  }
}

.file-info {
  display: flex;
  align-items: center;
  gap: 8px;
}

// Responsive para móviles
@media (max-width: 768px) {
  .fab-button {
    bottom: 16px !important;
    right: 16px !important;
  }
}
</style>
