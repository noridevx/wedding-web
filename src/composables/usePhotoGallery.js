import { ref, computed, watch } from 'vue'
import { supabase } from '@/lib/supabase'

export function usePhotoGallery() {
  const photos = ref([])
  const isRefreshing = ref(false)
  const showOnlyChallenges = ref(false)
  
  // Variables para paginado
  const isLoading = ref(false)
  const hasMore = ref(true)
  const currentPage = ref(0)
  const pageSize = ref(12) // Número de fotos por página

  async function listPhotos(reset = false) {
    // If no Supabase, just leave any statics empty; could fallback to local assets if desired
    if (!supabase) {
      photos.value = []
      return
    }
    
    if (isLoading.value) return
    
    try {
      isLoading.value = true
      
      // Resetear si se solicita
      if (reset) {
        photos.value = []
        currentPage.value = 0
        hasMore.value = true
      }
      
      // Calcular offset para paginado
      const offset = currentPage.value * pageSize.value
      
      // Construir la consulta base
      let query = supabase
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
        .range(offset, offset + pageSize.value - 1)
      
      // Si estamos filtrando por retos, añadir el filtro a la consulta
      if (showOnlyChallenges.value) {
        query = query.not('challenge_id', 'is', null)
      }
      
      const { data, error } = await query
      
      if (error) {
        console.error('Error listing photos:', error)
        return
      }
      
      // Filtrar solo imágenes y mapear a un formato más simple
      const newPhotos = (data || [])
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
      
      // Añadir nuevas fotos a la lista existente
      if (reset) {
        photos.value = newPhotos
      } else {
        photos.value.push(...newPhotos)
      }
      
      // Verificar si hay más fotos
      hasMore.value = newPhotos.length === pageSize.value
      currentPage.value++
        
    } catch (error) {
      console.error('Error in listPhotos:', error)
      if (reset) {
        photos.value = []
      }
    } finally {
      isLoading.value = false
    }
  }

  async function loadMorePhotos() {
    if (!hasMore.value || isLoading.value) return
    await listPhotos(false)
  }

  async function refresh() {
    if (isRefreshing.value) return
    
    isRefreshing.value = true
    try {
      await listPhotos(true) // Resetear y cargar desde el principio
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

  // Computed para verificar si hay más fotos filtradas
  const hasMoreFiltered = computed(() => {
    return hasMore.value
  })

  function toggleChallengeFilter() {
    showOnlyChallenges.value = !showOnlyChallenges.value
    // Resetear y recargar cuando cambie el filtro
    listPhotos(true)
  }

  // Watcher para recargar cuando cambie el filtro
  watch(showOnlyChallenges, () => {
    // El toggleChallengeFilter ya maneja la recarga
  })

  return {
    photos,
    filteredPhotos,
    isRefreshing,
    isLoading,
    hasMore,
    hasMoreFiltered,
    showOnlyChallenges,
    listPhotos,
    loadMorePhotos,
    refresh,
    toggleChallengeFilter
  }
}
