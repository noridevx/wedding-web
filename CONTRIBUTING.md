## Guía de contribución y contexto del proyecto

Este documento recoge el contexto técnico, arquitectura ligera, convenciones y patrones de reutilización del proyecto. Úsalo como referencia para implementar nuevas funcionalidades manteniendo coherencia.

## Stack y librerías

- **Framework**: Vue 3 (Composition API, `<script setup>`)
- **Build**: Vite 5
- **UI**: Vuetify 3 (tema por defecto `dark`, con overrides locales)
- **Enrutado**: `unplugin-vue-router` (rutas automáticas desde `src/pages`)
- **Auto-import**: `unplugin-vue-components` + `vite-plugin-vuetify`
- **Estilos**: SASS/SCSS (sass-embedded)
- **Fuentes/íconos**: `@mdi/font`, `roboto-fontface`, [Google Fonts](https://fonts.google.com/) vía `unplugin-fonts`
- **Componentes de terceros**: `vue3-carousel`, `vue-gallery`

## Scripts

- Desarrollo: `npm run dev` (Vite con `--port 8080`)
- Compilación: `npm run build`
- Preview: `npm run preview`
- Lint: `npm run lint`

> Nota: En `vite.config.mjs` el `server.port` está en `3000`. El flag del script (`8080`) predomina. Unificar cuando convenga.

## Estructura

- `src/main.js`: crea y monta la app, registra plugins globales (`registerPlugins`).
- `src/App.vue`: layout raíz Vuetify (`<v-app><v-main><router-view/></v-main></v-app>`).
- `src/router/index.js`: router creado con `vue-router/auto` + workaround de recarga para imports dinámicos.
- `src/plugins/`: configuración y registro de plugins (`vuetify`, `router`).
- `src/pages/`: páginas convertidas automáticamente en rutas.
- `src/components/`: componentes reutilizables (auto-importados globalmente).
- `src/styles/settings.scss`: variables/overrides de Vuetify y SASS.
- `src/assets/`: imágenes y recursos estáticos.

## Convenciones de código

- **SFC** con `<script setup>` y Composition API.
- **Nomenclatura**: componentes en PascalCase; archivos en `kebab-case` o `index.vue` por ruta.
- **Idioma UI**: español.
- **Imports**: preferir auto-import de componentes; alias `@` apunta a `src`.
- **Lint**: ESLint flat config; `vue/multi-word-component-names` desactivada.
- **TypeScript**: permitido en SFC puntuales, pero el proyecto no incluye `typescript` en devDependencies. Si se adopta TS, añadirlo y configurar.

## Enrutado y navegación

- Crear nuevas páginas añadiendo `.vue` en `src/pages`. Se generan rutas automáticamente.
- Usar `index.vue` dentro de subcarpetas para rutas anidadas limpias.
- La navegación principal visual está en `components/NavBar.vue` (actualmente simple).

## Estilos y tema

- Tema global Vuetify: `dark`. La home aplica fondo claro sobre `.v-main`.
- Fuentes globales: Roboto; tipografía decorativa (Dancing Script) se usa vía `@import` en páginas/secciones. Si se estandariza, mover a configuración global.
- Centralizar overrides y variables en `src/styles/settings.scss` (apuntado por `vite-plugin-vuetify`).

## Componentes existentes (resumen)

- `NavBar.vue`: barra superior con título y botón de confirmación (`Confirm`).
- `Landing.vue`: hero responsive (imágenes distintas para desktop/mobile).
- `DressCode.vue`: temática y enlaces; integra `DressCarousel`.
- `DressCarousel.vue`: carrusel con `vue3-carousel` (lista estática de imágenes en `assets/pictures/disfraces`).
- `Gallery.vue`: galería “preboda” con `vue-gallery`; carga dinámica de imágenes con `import.meta.glob` desde `assets/pictures/redes` y opción “ver todas”.
- `Place.vue`: ubicación con iframe de Google Maps.
- `Confirm.vue`: diálogo con `<iframe>` a Google Forms para confirmar asistencia.
- `Footer.vue`: bloque de asistencia reutilizando `Confirm`.

## Patrón de contenedor y tipografía

Usar el contenedor estándar (máximo 900px), centrado y con jerarquía tipográfica:

```vue
<v-container class="text-center" style="max-width: 900px;">
  <h1 class="font-dancing">Título</h1>
  <p class="mb-5">Descripción</p>
  <!-- contenido -->
  
</v-container>
```

La clase `.font-dancing` se usa en títulos (`h1/h3`) para identidad visual.

## Manejo de imágenes y assets

- Alias `@/assets/...` en `v-img` y `<img>`.
- Para galerías o listas extensibles de imágenes, preferir carga dinámica:

```vue
<script setup>
import { ref } from 'vue'

const images = ref(
  Object.values(
    import.meta.glob('@/assets/pictures/<carpeta>/*', { eager: true })
  ).map(i => i.default)
)
</script>
```

- En `v-img`, usar `#placeholder` con `v-progress-circular` para mejorar la carga percibida.

## UX, responsive y patrones reutilizables

- Utilidades de Vuetify (`d-none d-md-block`, grid, `v-container`, `v-row`, `v-col`).
- Breakpoints en `vue3-carousel` para carruseles.
- Diálogo con acción primaria (patrón estándar):

```vue
<v-dialog max-width="700">
  <template #activator="{ props }">
    <v-btn v-bind="props" text="Abrir" variant="flat" />
  </template>
  <template #default="{ isActive }">
    <v-btn size="small" icon="mdi-close" class="position-absolute" style="top:-10px;right:-10px;z-index:9" @click="isActive.value=false" />
    <v-card color="white">
      <v-card-text class="pa-0">
        <!-- contenido -->
      </v-card-text>
    </v-card>
  </template>
</v-dialog>
```

## Metodología para extender el proyecto

- Nueva sección en home: añadir componente en `src/components` e incorporarlo en `src/pages/index.vue`. Mantener patrón de contenedor (900px), `.font-dancing` y espaciados (`mt-5`, `mb-5`).
- Nueva página: `src/pages/<slug>.vue` con layout interno (`v-container`). Añadir navegación en `NavBar` si aplica.
- Galerías con muchas imágenes: usar `import.meta.glob` para evitar mantenimiento manual.
- Integraciones de terceros (formularios, etc.): `<v-dialog>` + `<iframe>` como en `Confirm.vue`.
- Estilos globales: preferir `settings.scss` para variables y overrides; evitar estilos inline salvo ajustes puntuales.

## Calidad y linting

- Ejecutar `npm run lint` antes de commits.
- Mantener `<script setup>` y lógica de componentes sencilla.
- Evitar lógica compleja en plantillas; mover a `<script setup>`.

## Decisiones abiertas

- Unificar puerto de desarrollo (`8080` vs `3000`).
- Tema global: decidir si `light` sería más coherente con la home (o mantener `dark` con overrides).
- Normalizar uso de auto-imports (evitar imports manuales donde sea posible) y postura frente a TS (adoptar o evitar).

## Checklist rápido (PRs y tareas)

- ¿Se respetó el patrón de contenedor (900px) y `.font-dancing` en títulos?
- ¿Se usó `import.meta.glob` si la lista de imágenes crece?
- ¿Consistencia en auto-imports y alias `@`?
- ¿Responsive validado con utilidades de Vuetify/breakpoints?
- ¿Overrides globales en `settings.scss` si aplica?
- ¿`npm run lint` sin errores?

## Referencias

- [Documentación de Vuetify](https://vuetifyjs.com/)
- [Vue 3](https://vuejs.org/)
- [Vite](https://vitejs.dev/)
- [unplugin-vue-router](https://github.com/posva/unplugin-vue-router)
- [unplugin-vue-components](https://github.com/unplugin/unplugin-vue-components)


