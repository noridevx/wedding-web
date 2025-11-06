<template>
  <!-- FAB Button -->
  <v-btn
    v-show="!showModal"
    icon="mdi-plus"
    color="primary"
    size="x-large"
    class="fab-button"
    @click="openModalNormal()"
  />

  <!-- Modal para subir fotos -->
  <v-dialog
    v-model="showModal"
    fullscreen
    persistent
  >
    <v-card class="upload-modal-card">
      <!-- Cabecera fija -->
      <v-card-title class="d-flex align-center justify-space-between upload-modal-header">
        <div class="d-flex align-center">
          <v-icon
            v-if="currentChallenge"
            color="warning"
            class="mr-2"
          >
            mdi-trophy
          </v-icon>
          <span>{{ currentChallenge ? 'Completar Reto' : 'Subir Foto' }}</span>
        </div>
        <v-btn
          icon="mdi-close"
          variant="text"
          size="small"
          @click="closeModal"
        />
      </v-card-title>

      <!-- Contenido scrolleable -->
      <div class="upload-modal-content">
        <v-card-text>
          <!-- Información del reto (si aplica) -->
          <div
            v-if="currentChallenge"
            class="challenge-info"
          >
            <div class="d-flex align-center justify-space-between">
              <h3 class="text-h6 font-dancing">
                ¡Nuevo Reto!
              </h3>
              <!-- Estado del reto -->
              <v-chip
                :color="currentChallenge.is_completed ? 'success' : 'warning'"
                variant="outlined"
                size="small"
              >
                <v-icon start>
                  {{ currentChallenge.is_completed ? 'mdi-check-circle' : 'mdi-clock-outline' }}
                </v-icon>
                {{ currentChallenge.is_completed ? 'Completado' : 'Pendiente' }}
              </v-chip>
            </div>
            <p class="text-body-1 mb-1">
              {{ currentChallenge.description }}
            </p>
          </div>

          <v-form
            ref="form"
            @submit.prevent="handleUpload"
          >
            <!-- Campo de teléfono (solo para retos) -->
            <v-text-field
              v-if="currentChallenge"
              v-model="phone"
              label="Teléfono (para participar en el concurso)"
              placeholder="600000000"
              prepend-icon="mdi-phone"
              variant="outlined"
              hide-details="auto"
              density="compact"
              class="mb-4"
              :error-messages="phoneError"
              @input="validatePhone"
            />

            <!-- Selector de archivo -->
            <v-file-input
              v-model="selectedFile"
              accept="image/*"
              prepend-icon="mdi-image"
              label="Seleccionar foto"
              hide-details="auto"
              density="compact"
              :rules="fileRules"
              variant="outlined"
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
              :label="currentChallenge ? 'Comentario sobre el reto (opcional)' : 'Comentario (opcional)'"
              :placeholder="currentChallenge ? 'Cuéntanos cómo completaste este reto...' : 'Añade un comentario a tu foto...'"
              rows="3"
              auto-grow
              variant="outlined"
              hide-details="auto"
              class="mt-4"
            />
          </v-form>
        </v-card-text>
      </div>

      <!-- Botones fijos -->
      <v-card-actions class="upload-modal-actions">
        <v-spacer />
        <v-btn
          variant="text"
          :disabled="isUploading"
          @click="closeModal"
        >
          Cancelar
        </v-btn>
        <v-btn
          :color="currentChallenge ? 'warning' : 'primary'"
          variant="tonal"
          :loading="isUploading"
          :disabled="!selectedFile || isUploading || !!phoneError"
          @click="handleUpload"
        >
          <template #prepend>
            <v-icon
              v-if="currentChallenge"
              icon="mdi-trophy"
            />
          </template>
          {{ isUploading ? (currentChallenge ? 'Completando reto...' : 'Subiendo...') : (currentChallenge ? 'Completar Reto' : 'Subir Foto') }}
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>

  <!-- Snackbar para notificaciones -->
  <v-snackbar
    v-model="showSnackbar"
    :color="snackbarColor"
    location="top"
    :timeout="3000"
  >
    {{ snackbarMessage }}
  </v-snackbar>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { supabase, SUPABASE_BUCKET, SUPABASE_FOLDER } from '@/lib/supabase'
import { useChallenges } from '@/composables/useChallenges'
import { useDeviceStorage } from '@/composables/useDeviceStorage'

const emit = defineEmits(['upload-success', 'upload-error', 'refresh-photos', 'modal-opened'])

// Props para recibir el reto desde el componente padre
const props = defineProps({
  challenge: {
    type: Object,
    default: null
  },
  // Prop para forzar la apertura del modal con un reto específico
  forceChallenge: {
    type: Object,
    default: null
  }
})

const showModal = ref(false)
const selectedFile = ref(null)
const comment = ref('')
const phone = ref('')
const isUploading = ref(false)
const showSnackbar = ref(false)
const snackbarMessage = ref('')
const snackbarColor = ref('success')
const fileError = ref('')
const phoneError = ref('')

// Lógica de retos y almacenamiento
const { completeChallenge } = useChallenges()
const { getDevicePhone, saveDevicePhone, validatePhone: validatePhoneFormat } = useDeviceStorage()

// Computed para el reto actual
const currentChallenge = computed(() => props.forceChallenge || props.challenge)

// Watcher para cargar el teléfono cuando cambie el reto
watch(currentChallenge, (newChallenge) => {
  if (newChallenge && showModal.value) {
    const savedPhone = getDevicePhone()
    if (savedPhone) {
      phone.value = savedPhone
    }
  }
})



const fileRules = [
  value => {
    if (!value) return 'Selecciona una imagen'
    if (!value?.size || value?.size > 50 * 1024 * 1024) return 'El archivo no puede ser mayor a 50MB'
    return true
  }
]

const imagePreview = computed(() => {
  if (!selectedFile.value) return null
  return URL.createObjectURL(selectedFile.value)
})

function openModal() {
  showModal.value = true
  // Cargar teléfono guardado si existe
  const savedPhone = getDevicePhone()
  if (savedPhone) {
    phone.value = savedPhone
  }
  // Emitir evento para indicar que se abrió con reto
  emit('modal-opened', 'challenge')
}

function openModalNormal() {
  // Limpiar cualquier reto forzado y abrir modal normal
  showModal.value = true
  // Limpiar el teléfono cuando se abre modal normal
  phone.value = ''
  // Emitir evento para limpiar el reto forzado
  emit('modal-opened', 'normal')
}

// Exponer función para abrir modal desde el componente padre
defineExpose({
  openModal,
  openModalNormal
})

function validateFile() {
  fileError.value = ''
  if (!selectedFile.value) return

  try {
    const validation = fileRules[0](selectedFile.value)
    if (validation !== true) {
      fileError.value = validation
      selectedFile.value = null
    }
  } catch (error) {
    console.error('Error validating file:', error)
    fileError.value = 'Error al validar el archivo'
    selectedFile.value = null
  }
}

function validatePhone() {
  phoneError.value = ''
  if (!phone.value) return true // Es opcional
  
  if (!validatePhoneFormat(phone.value)) {
    phoneError.value = 'Formato de teléfono inválido. Usa un número español válido.'
    return false
  }
  // Limpiar error si el teléfono es válido
  phoneError.value = ''
  return true
}



async function handleUpload() {
  if (!selectedFile.value || !supabase) return

  // Validar teléfono si se proporciona
  if (phone.value && !validatePhone()) {
    return
  }

  isUploading.value = true
  try {
    // Crear nombre único para el archivo
    const timestamp = Date.now()
    const safeName = selectedFile.value.name.replace(/[^a-zA-Z0-9.-]/g, '_')
    const filepath = `${SUPABASE_FOLDER}/${timestamp}-${safeName}`

    console.log('Uploading:', filepath, 'Size:', selectedFile.value.size, 'Type:', selectedFile.value.type)

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
          phone: phone.value || null,
          challenge_id: currentChallenge.value?.id || null,
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

    // Si es un reto, completarlo
    if (currentChallenge.value) {
      const success = await completeChallenge(
        currentChallenge.value.id,
        photoData[0].id,
        'anonymous'
      )

      if (!success) {
        throw new Error('Error al completar el reto')
      }
    }

    // Guardar teléfono en localStorage para futuros retos
    if (phone.value) {
      saveDevicePhone(phone.value)
    }

    console.log('Upload success:', photoData)
    
    // Mostrar notificación de éxito
    const message = currentChallenge.value ? '¡Reto completado!' : 'Foto subida'
    showNotification(message, 'success')
    
    // Emitir eventos
    emit('upload-success', photoData[0])
    if (currentChallenge.value) {
      emit('refresh-photos')
    }
    
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
  // No limpiar el teléfono para que persista entre retos
  // phone.value = ''
  fileError.value = ''
  phoneError.value = ''
}
</script>

<style scoped lang="scss">
.fab-button {
  position: fixed !important;
  bottom: 24px !important;
  right: 24px !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3) !important;
}

// Estilos del modal con layout fijo
.upload-modal-card {
  display: flex;
  flex-direction: column;
  max-height: 80vh;
}

.upload-modal-header {
  flex-shrink: 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.upload-modal-content {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
}

.upload-modal-actions {
  flex-shrink: 0;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  background: rgba(30, 27, 75, 0.5);
}

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

.challenge-info {
  padding: 8px;
  margin-bottom: 16px;
  background: linear-gradient(135deg, rgba(255, 193, 7, 0.1), rgba(255, 152, 0, 0.1));
  border-radius: 8px;
  border: 1px solid rgba(255, 193, 7, 0.2);
  
  h3 {
    color: #FFC107;
    font-weight: 600;
  }
  
  p {
    color: #F1F5F9;
    line-height: 1.6;
  }
}

// Responsive para móviles
@media (max-width: 768px) {
  .fab-button {
    bottom: 16px !important;
    right: 16px !important;
  }
  
  .upload-modal-card {
    max-height: 90vh;
  }
}
</style>
