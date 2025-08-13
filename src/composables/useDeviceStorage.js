import { ref, onMounted, computed } from 'vue'

const deviceId = ref(null)
const reservedChallenge = ref(null)
const devicePhone = ref(null)

export function useDeviceStorage() {
  // Generar o recuperar ID del dispositivo
  function getDeviceId() {
    if (deviceId.value) return deviceId.value
    
    let id = localStorage.getItem('wedding_device_id')
    if (!id) {
      id = 'device_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9)
      localStorage.setItem('wedding_device_id', id)
    }
    deviceId.value = id
    return id
  }

  // Guardar teléfono del dispositivo
  function saveDevicePhone(phone) {
    if (phone) {
      localStorage.setItem('wedding_device_phone', phone)
      devicePhone.value = phone
    } else {
      localStorage.removeItem('wedding_device_phone')
      devicePhone.value = null
    }
  }

  // Recuperar teléfono del dispositivo
  function getDevicePhone() {
    if (devicePhone.value) return devicePhone.value
    
    const phone = localStorage.getItem('wedding_device_phone')
    if (phone) {
      devicePhone.value = phone
      return phone
    }
    return null
  }

  // Validar formato de teléfono
  function validatePhone(phone) {
    if (!phone) return true // Es opcional
    // Validar formato básico de teléfono español
    const phoneRegex = /^(\+34|0034|34)?[6789]\d{8}$/
    return phoneRegex.test(phone.replace(/\s/g, ''))
  }

  // Guardar reto reservado en localStorage
  function saveReservedChallenge(challenge) {
    if (challenge) {
      localStorage.setItem('wedding_reserved_challenge', JSON.stringify({
        ...challenge,
        reservedAt: new Date().toISOString()
      }))
      reservedChallenge.value = challenge
    } else {
      localStorage.removeItem('wedding_reserved_challenge')
      reservedChallenge.value = null
    }
  }

  // Recuperar reto reservado del localStorage
  function getReservedChallenge() {
    if (reservedChallenge.value) return reservedChallenge.value
    
    const stored = localStorage.getItem('wedding_reserved_challenge')
    if (stored) {
      try {
        const challenge = JSON.parse(stored)
        reservedChallenge.value = challenge
        return challenge
      } catch (error) {
        console.error('Error parsing reserved challenge:', error)
        localStorage.removeItem('wedding_reserved_challenge')
        return null
      }
    }
    return null
  }

  // Limpiar reto reservado
  function clearReservedChallenge() {
    localStorage.removeItem('wedding_reserved_challenge')
    reservedChallenge.value = null
  }

  // Verificar si el reto reservado ha expirado (más de 1 hora)
  function isReservedChallengeExpired() {
    const challenge = getReservedChallenge()
    if (!challenge || !challenge.reservedAt) return true
    
    const reservedAt = new Date(challenge.reservedAt)
    const now = new Date()
    const diffHours = (now - reservedAt) / (1000 * 60 * 60)
    
    return diffHours > 1 // Expira después de 1 hora
  }

  // Inicializar al montar el componente
  onMounted(() => {
    getDeviceId()
    getReservedChallenge()
    getDevicePhone()
  })

  return {
    deviceId: computed(() => deviceId.value),
    reservedChallenge: computed(() => reservedChallenge.value),
    devicePhone: computed(() => devicePhone.value),
    getDeviceId,
    saveDevicePhone,
    getDevicePhone,
    validatePhone,
    saveReservedChallenge,
    getReservedChallenge,
    clearReservedChallenge,
    isReservedChallengeExpired
  }
}
