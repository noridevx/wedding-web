import { ref } from 'vue'
import { supabase, SUPABASE_BUCKET, SUPABASE_FOLDER } from '@/lib/supabase'

export function usePhotoGallery() {
  const photos = ref([])
  const isRefreshing = ref(false)

  async function listPhotos() {
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

  async function refresh() {
    if (isRefreshing.value) return
    
    isRefreshing.value = true
    try {
      await listPhotos()
    } catch (error) {
      console.error('Error refreshing photos:', error)
    } finally {
      isRefreshing.value = false
    }
  }

  return {
    photos,
    isRefreshing,
    listPhotos,
    refresh
  }
}
