import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'

export function usePhotoGallery() {
  const photos = ref([])
  const isRefreshing = ref(false)
  const showOnlyChallenges = ref(false)

  async function listPhotos() {
    // If no Supabase, just leave any statics empty; could fallback to local assets if desired
    if (!supabase) {
      photos.value = []
      return
    }
    
    try {
      // Obtener fotos desde la tabla 'photos' con información de retos
      const { data, error } = await supabase
        .from('photos')
        .select(`
          *,
          challenges(
            id,
            description,
            is_completed
          )
        `)
        .order('uploaded_at', { ascending: false })
        .limit(1000)
      
      if (error) {
        console.error('Error listing photos:', error)
        return
      }
      
      // Filtrar solo imágenes y mapear a un formato más simple
      photos.value = (data || [])
        .filter(item => item?.file_type?.startsWith?.('image/'))
        .map(item => ({
          id: item.id,
          url: item.public_url,
          comment: item.comment,
          fileName: item.file_name,
          fileSize: item.file_size,
          uploadedAt: item.uploaded_at,
          challenge: item.challenge_id ? {
            id: item.challenges?.id,
            description: item.challenges?.description,
            isCompleted: item.challenges?.is_completed
          } : null
        }))
        
    } catch (error) {
      console.error('Error in listPhotos:', error)
      photos.value = []
    }
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

  // Computed para filtrar fotos según el estado del filtro
  const filteredPhotos = computed(() => {
    if (!showOnlyChallenges.value) {
      return photos.value
    }
    return photos.value.filter(photo => photo.challenge)
  })

  function toggleChallengeFilter() {
    showOnlyChallenges.value = !showOnlyChallenges.value
  }

  return {
    photos,
    filteredPhotos,
    isRefreshing,
    showOnlyChallenges,
    listPhotos,
    refresh,
    toggleChallengeFilter
  }
}
