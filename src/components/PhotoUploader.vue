<template>
  <section class="uploader">
    <v-file-input
      v-model="files"
      accept="image/*"
      prepend-icon="mdi-image-plus"
      label="Sube tus fotos"
      multiple
      :disabled="!canUpload"
    />
    <v-btn
      class="ml-2"
      :loading="isUploading"
      :disabled="!canUpload || !files?.length"
      @click="handleUpload"
    >
      Subir
    </v-btn>
    <div v-if="!canUpload" class="warning">
      Configura Supabase para habilitar las subidas. 
      Necesitas VITE_SUPABASE_URL y VITE_SUPABASE_ANON_KEY en tu .env
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import { supabase, isSupabaseConfigured, SUPABASE_BUCKET, SUPABASE_FOLDER } from '@/lib/supabase'

const emit = defineEmits(['upload-success', 'upload-error'])

const canUpload = isSupabaseConfigured()
const files = ref([])
const isUploading = ref(false)

async function handleUpload() {
  if (!files.value?.length || !supabase) return
  
  isUploading.value = true
  try {
    const uploads = Array.from(files.value).map(async (file) => {
      // Validate file type
      if (!file.type.startsWith('image/')) {
        throw new Error(`File ${file.name} is not an image`)
      }
      
      // Create unique filename
      const timestamp = Date.now()
      const safeName = file.name.replace(/[^a-zA-Z0-9.-]/g, '_')
      const filepath = `${SUPABASE_FOLDER}/${timestamp}-${safeName}`
      
      console.log('Uploading:', filepath, 'Size:', file.size, 'Type:', file.type)
      
      const { data, error } = await supabase.storage
        .from(SUPABASE_BUCKET)
        .upload(filepath, file, { 
          upsert: false,
          contentType: file.type
        })
        
      if (error) {
        console.error('Upload error for', file.name, ':', error)
        throw error
      }
      
      console.log('Upload success:', data)
    })
    
    await Promise.all(uploads)
    files.value = []
    emit('upload-success')
  } catch (e) {
    console.error('Upload failed:', e)
    emit('upload-error', e.message)
  } finally {
    isUploading.value = false
  }
}
</script>

<style scoped lang="scss">
.uploader {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
  
  .warning { 
    color: #ffcd45; 
    font-size: 0.9rem; 
  }
}

// Mejoras para dispositivos móviles
@media (max-width: 768px) {
  .uploader {
    flex-direction: column;
    align-items: stretch;
    gap: 12px;
    
    .v-btn {
      margin-left: 0 !important;
    }
  }
}
</style>
