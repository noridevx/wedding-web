import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'

const challenges = ref([])
const isLoading = ref(false)
const error = ref(null)

export function useChallenges() {
  // Obtener todos los retos
  async function fetchChallenges() {
    if (!supabase) {
      error.value = 'Supabase no está configurado'
      return
    }

    isLoading.value = true
    error.value = null

    try {
      const { data, error: fetchError } = await supabase
        .from('challenges')
        .select('*')
        .order('created_at', { ascending: false })

      if (fetchError) {
        throw fetchError
      }

      challenges.value = data || []
    } catch (err) {
      console.error('Error fetching challenges:', err)
      error.value = err.message
    } finally {
      isLoading.value = false
    }
  }

  // Obtener un reto aleatorio
  function getRandomChallenge() {
    if (challenges.value.length === 0) return null

    // Primero intentar obtener retos no completados
    const incompleteChallenges = challenges.value.filter(challenge => !challenge.is_completed)
    
    // Si hay retos incompletos, elegir uno aleatorio de esos
    if (incompleteChallenges.length > 0) {
      const randomIndex = Math.floor(Math.random() * incompleteChallenges.length)
      return incompleteChallenges[randomIndex]
    }
    
    // Si todos están completados, elegir uno aleatorio de todos
    const randomIndex = Math.floor(Math.random() * challenges.value.length)
    return challenges.value[randomIndex]
  }

  // Completar un reto
  async function completeChallenge(challengeId, photoId, completedBy = 'anonymous') {
    if (!supabase) {
      error.value = 'Supabase no está configurado'
      return false
    }

    try {
      // Primero actualizar la foto para vincularla al reto
      const { error: photoUpdateError } = await supabase
        .from('photos')
        .update({ challenge_id: challengeId })
        .eq('id', photoId)

      if (photoUpdateError) {
        throw photoUpdateError
      }

      // Luego marcar el reto como completado
      const { data, error: updateError } = await supabase
        .from('challenges')
        .update({
          is_completed: true,
          completed_at: new Date().toISOString(),
          completed_by: completedBy
        })
        .eq('id', challengeId)
        .select()

      if (updateError) {
        throw updateError
      }

      // Actualizar el reto en el estado local
      const index = challenges.value.findIndex(c => c.id === challengeId)
      if (index !== -1) {
        challenges.value[index] = data[0]
      }

      return true
    } catch (err) {
      console.error('Error completing challenge:', err)
      error.value = err.message
      return false
    }
  }

  // Computed properties
  const incompleteChallenges = computed(() => 
    challenges.value.filter(challenge => !challenge.is_completed)
  )

  const completedChallenges = computed(() => 
    challenges.value.filter(challenge => challenge.is_completed)
  )

  const totalChallenges = computed(() => challenges.value.length)

  const completionRate = computed(() => {
    if (totalChallenges.value === 0) return 0
    return Math.round((completedChallenges.value.length / totalChallenges.value) * 100)
  })

  return {
    // State
    challenges: computed(() => challenges.value),
    isLoading: computed(() => isLoading.value),
    error: computed(() => error.value),
    
    // Computed
    incompleteChallenges,
    completedChallenges,
    totalChallenges,
    completionRate,
    
    // Methods
    fetchChallenges,
    getRandomChallenge,
    completeChallenge
  }
}
