import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'
import { useDeviceStorage } from './useDeviceStorage'

const challenges = ref([])
const isLoading = ref(false)
const error = ref(null)

export function useChallenges() {
  const { 
    getDeviceId, 
    saveReservedChallenge, 
    getReservedChallenge, 
    clearReservedChallenge, 
    isReservedChallengeExpired 
  } = useDeviceStorage()

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

  // Obtener un reto aleatorio disponible (no completado, no reservado)
  function getRandomChallenge() {
    if (challenges.value.length === 0) return null

    // Primero verificar si hay un reto reservado por este dispositivo
    const deviceReservedChallenge = getReservedChallenge()
    if (deviceReservedChallenge && !isReservedChallengeExpired()) {
      // Buscar el reto reservado en la lista actual
      const reservedChallenge = challenges.value.find(c => c.id === deviceReservedChallenge.id)
      if (reservedChallenge && !reservedChallenge.is_completed) {
        return reservedChallenge
      }
    }

    // Obtener retos disponibles (no completados, no reservados)
    const availableChallenges = challenges.value.filter(challenge => 
      !challenge.is_completed && !challenge.is_reserved
    )
    
    // Si hay retos disponibles, elegir uno aleatorio
    if (availableChallenges.length > 0) {
      const randomIndex = Math.floor(Math.random() * availableChallenges.length)
      return availableChallenges[randomIndex]
    }
    
    // Si no hay retos disponibles, elegir uno aleatorio de los no completados
    const incompleteChallenges = challenges.value.filter(challenge => !challenge.is_completed)
    if (incompleteChallenges.length > 0) {
      const randomIndex = Math.floor(Math.random() * incompleteChallenges.length)
      return incompleteChallenges[randomIndex]
    }
    
    // Si todos están completados, elegir uno aleatorio de todos
    const randomIndex = Math.floor(Math.random() * challenges.value.length)
    return challenges.value[randomIndex]
  }

  // Reservar un reto para este dispositivo
  async function reserveChallenge(challengeId) {
    if (!supabase) {
      error.value = 'Supabase no está configurado'
      return false
    }

    try {
      const deviceId = getDeviceId()
      
      const { data, error: reserveError } = await supabase
        .from('challenges')
        .update({
          is_reserved: true,
          reserved_at: new Date().toISOString(),
          reserved_by: deviceId
        })
        .eq('id', challengeId)
        .select()

      if (reserveError) {
        throw reserveError
      }

      // Guardar en localStorage
      saveReservedChallenge(data[0])

      // Actualizar el reto en el estado local
      const index = challenges.value.findIndex(c => c.id === challengeId)
      if (index !== -1) {
        challenges.value[index] = data[0]
      }

      return true
    } catch (err) {
      console.error('Error reserving challenge:', err)
      error.value = err.message
      return false
    }
  }

  // Liberar un reto reservado
  async function releaseChallenge(challengeId) {
    if (!supabase) {
      error.value = 'Supabase no está configurado'
      return false
    }

    try {
      const { data, error: releaseError } = await supabase
        .from('challenges')
        .update({
          is_reserved: false,
          reserved_at: null,
          reserved_by: null
        })
        .eq('id', challengeId)
        .select()

      if (releaseError) {
        throw releaseError
      }

      // Limpiar localStorage
      clearReservedChallenge()

      // Actualizar el reto en el estado local
      const index = challenges.value.findIndex(c => c.id === challengeId)
      if (index !== -1) {
        challenges.value[index] = data[0]
      }

      return true
    } catch (err) {
      console.error('Error releasing challenge:', err)
      error.value = err.message
      return false
    }
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

      // Luego marcar el reto como completado y liberarlo
      const { data, error: updateError } = await supabase
        .from('challenges')
        .update({
          is_completed: true,
          is_reserved: false,
          reserved_at: null,
          reserved_by: null,
          completed_at: new Date().toISOString(),
          completed_by: completedBy
        })
        .eq('id', challengeId)
        .select()

      if (updateError) {
        throw updateError
      }

      // Limpiar localStorage
      clearReservedChallenge()

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
    reserveChallenge,
    releaseChallenge,
    completeChallenge
  }
}
