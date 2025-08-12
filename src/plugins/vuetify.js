/**
 * plugins/vuetify.js
 *
 * Framework documentation: https://vuetifyjs.com`
 */

// Styles
import '@mdi/font/css/materialdesignicons.css'
import 'vuetify/styles'

// Composables
import { createVuetify } from 'vuetify'
import { VPullToRefresh } from 'vuetify/labs/VPullToRefresh'

// https://vuetifyjs.com/en/introduction/why-vuetify/#feature-guides
export default createVuetify({
  components: {
    VPullToRefresh,
  },
  theme: {
    defaultTheme: 'dark',
    themes: {
      dark: {
        dark: true,
        colors: {
          // Colores principales
          primary: '#8B5CF6', // Violeta elegante
          secondary: '#F59E0B', // Dorado cálido
          accent: '#06B6D4', // Cian vibrante
          
          // Colores de superficie
          surface: '#1E1B4B', // Azul oscuro elegante
          'surface-variant': '#312E81', // Azul medio
          background: '#0F0F23', // Azul muy oscuro
          
          // Colores de estado
          success: '#10B981', // Verde esmeralda
          warning: '#F59E0B', // Dorado
          error: '#EF4444', // Rojo vibrante
          info: '#3B82F6', // Azul cielo
          
          // Colores de texto
          'on-primary': '#FFFFFF',
          'on-secondary': '#000000',
          'on-surface': '#E2E8F0',
          'on-background': '#F1F5F9',
          
          // Colores adicionales
          'surface-bright': '#2D1B69',
          'surface-container': '#1A103F',
          'surface-container-high': '#2D1B69',
          'surface-container-low': '#0F0A1F',
        }
      }
    }
  },
})
