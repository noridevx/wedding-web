<template>
  <div class="challenge-upload-form">
    <v-form
      ref="form"
      @submit.prevent="handleUpload"
    >
      <!-- Selector de archivo -->
      <v-file-input
        v-model="selectedFile"
        accept="image/*"
        prepend-icon="mdi-camera"
        label="Seleccionar foto para completar el reto"
        hide-details="auto"
        density="compact"
        :rules="fileRules"
        :error-messages="fileError || null"
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
        label="Comentario sobre el reto (opcional)"
        placeholder="Cuéntanos cómo completaste este reto..."
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

      <!-- Botones de acción -->
      <div class="form-actions mt-6">
        <v-btn
          variant="text"
          :disabled="isUploading"
          @click="$emit('close')"
        >
          Cancelar
        </v-btn>
        <v-spacer />
        <v-btn
          color="success"
          variant="elevated"
          :loading="isUploading"
          :disabled="!selectedFile || isUploading"
          @click="handleUpload"
        >
          <v-icon start>
            mdi-trophy-check
          </v-icon>
          {{ isUploading ? 'Completando reto...' : 'Completar Reto' }}
        </v-btn>
      </div>
    </v-form>

    <!-- Snackbar para notificaciones -->
    <v-snackbar
      v-model="showSnackbar"
      :color="snackbarColor"
      location="top"
      :timeout="3000"
    >
      {{ snackbarMessage }}
    </v-snackbar>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { supabase, SUPABASE_BUCKET, SUPABASE_FOLDER } from '@/lib/supabase'
import { useChallenges } from '@/composables/useChallenges'

const props = defineProps({
  challenge: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['upload-success', 'upload-error', 'close'])

const selectedFile = ref(null)
const comment = ref('')
const isUploading = ref(false)
const showSnackbar = ref(false)
const snackbarMessage = ref('')
const snackbarColor = ref('success')
const fileError = ref('')

const { completeChallenge } = useChallenges()

const fileRules = [
  value => {
    if (!value) return 'Selecciona una imagen para completar el reto'
    if (!value?.type?.startsWith('image/')) return 'El archivo debe ser una imagen'
    if (value?.size > 10 * 1024 * 1024) return 'El archivo no puede ser mayor a 10MB'
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
  if (!selectedFile.value || !supabase || !props.challenge) return

  isUploading.value = true
  try {
    // Crear nombre único para el archivo
    const timestamp = Date.now()
    const safeName = selectedFile.value.name.replace(/[^a-zA-Z0-9.-]/g, '_')
    const filepath = `${SUPABASE_FOLDER}/challenges/${timestamp}-${safeName}`

    console.log('Uploading challenge photo:', filepath)

    // Subir archivo a Supabase Storage
    const { error: uploadError } = await supabase.storage
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
          comment: comment.value,
          challenge_id: props.challenge.id,
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

    // Completar el reto
    const success = await completeChallenge(
      props.challenge.id,
      photoData[0].id,
      'anonymous'
    )

    if (!success) {
      throw new Error('Error al completar el reto')
    }

    console.log('Challenge completed successfully:', photoData)
    
    // Mostrar notificación de éxito
    showNotification('¡Reto completado exitosamente!', 'success')
    
    // Emitir evento de éxito
    emit('upload-success', {
      photo: photoData[0],
      challenge: props.challenge
    })
    
    // Limpiar formulario
    resetForm()
    
  } catch (error) {
    console.error('Upload failed:', error)
    showNotification(`Error al completar el reto: ${error.message}`, 'error')
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

function resetForm() {
  selectedFile.value = null
  comment.value = ''
  fileError.value = ''
}
</script>

<style scoped lang="scss">

.image-preview-container {
  margin-top: 4px;
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

.form-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

// Responsive
@media (max-width: 768px) {
  .challenge-upload-form {
    padding: 12px 0;
  }
  
  .form-actions {
    flex-direction: column;
    gap: 8px;
    
    .v-btn {
      width: 100%;
    }
  }
}
</style>
