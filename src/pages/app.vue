<template>
  <div class="app-page">
    <header class="app-header">
      <h2 class="font-dancing">Boda · Fotos</h2>
      <v-btn size="small" variant="text" @click="refresh">Actualizar</v-btn>
    </header>

    <main class="app-content">
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
          @click="upload"
        >
          Subir
        </v-btn>
        <div v-if="!canUpload" class="warning">
          Configura Supabase para habilitar las subidas. 
          Necesitas VITE_SUPABASE_URL y VITE_SUPABASE_ANON_KEY en tu .env
        </div>
      </section>

      <section class="gallery-grid">
        <div v-if="photos.length === 0" class="empty-state">
          <v-icon size="48" color="grey-lighten-1">mdi-image-multiple</v-icon>
          <p>No hay fotos subidas aún</p>
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
    </main>
  </div>
  
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { supabase, isSupabaseConfigured, SUPABASE_BUCKET, SUPABASE_FOLDER } from '@/lib/supabase'

const canUpload = isSupabaseConfigured()
const files = ref([])
const isUploading = ref(false)
const photos = ref([])

async function listPhotos () {
  // If no Supabase, just leave any statics empty; could fallback to local assets if desired
  if (!supabase) {
    photos.value = []
    return
  }
  const folder = `${SUPABASE_FOLDER}`
  const { data, error } = await supabase.storage.from(SUPABASE_BUCKET).list(folder, { limit: 1000 })
  if (error) {
    console.error('Error listing photos:', error)
    return
  }
  photos.value = (data || [])
    .filter(item => item?.metadata?.mimetype?.startsWith?.('image/'))
    .map(item => supabase.storage.from(SUPABASE_BUCKET).getPublicUrl(`${folder}/${item.name}`).data.publicUrl)
}

async function upload () {
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
    await listPhotos()
    files.value = []
  } catch (e) {
    console.error('Upload failed:', e)
    alert(`Error uploading: ${e.message}`)
  } finally {
    isUploading.value = false
  }
}

function refresh () {
  listPhotos()
}

onMounted(() => {
  listPhotos()
})
</script>

<style scoped lang="scss">
.app-page {
  display: grid;
  grid-template-rows: auto 1fr;
  min-height: 100vh;
  background: #0f0f10; /* distinto al sitio principal */
  color: #fff;
}

.app-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  position: sticky;
  top: 0;
  background: rgba(15, 15, 16, 0.8);
  backdrop-filter: blur(6px);
  z-index: 2;
}

.app-content {
  padding: 8px 12px 24px;
}

.uploader {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
  .warning { color: #ffcd45; font-size: 0.9rem; }
}

.gallery-grid {
  .rounded { border-radius: 10px; overflow: hidden; }
  
  .empty-state {
    text-align: center;
    padding: 48px 16px;
    color: #9e9e9e;
    
    p {
      margin-top: 16px;
      font-size: 1.1rem;
    }
  }
}
</style>


