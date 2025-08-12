<template>
  <v-container
    style="max-width: 900px;"
    class="text-center"
  >
    <h1 class="font-dancing ">
      Preboda
    </h1>
    <p class="mb-5">
      Selecciona una foto para verla en grande
    </p>
    <vue-gallery
      :images="images"
      :index="selectedIndex"
    />
    <v-row>
      <template
        v-for="(image, index) in images"
      >
        <v-col
          v-if="showThis(index)"
          :key="index"
          class="d-flex child-flex"
          cols="12"
          sm="6"
          md="4"
          lg="3"
        >
          <v-img
            :src="image"
            aspect-ratio="1"
            class="bg-grey-lighten-2 cursor-pointer"
            cover
            @click="selectedIndex = index"
          >
            <template #placeholder>
              <v-row
                align="center"
                class="fill-height ma-0"
                justify="center"
              >
                <v-progress-circular
                  color="grey-lighten-5"
                  indeterminate
                />
              </v-row>
            </template>
          </v-img>
        </v-col>
      </template>
    </v-row>
    <v-btn
      v-if="!showAll"
      variant="outlined"
      class="mt-3"
      @click="showAll = true"
    >
      ver todas las fotos
    </v-btn>
  </v-container>
</template>
<script setup>
import { onMounted, onUnmounted, ref } from 'vue';
import VueGallery from 'vue-gallery'


const images = ref(Object.values(import.meta.glob('@/assets/pictures/redes/*', { eager: true })).map(i => i.default));
const showAll = ref(false);
const selectedIndex = ref(null);

function showThis(index) {
    return (showAll.value || index < 4);
}

const checkScreen = () => {
    showAll.value = !window.matchMedia('(max-width: 768px)').matches
}

onMounted(() => {
    checkScreen()
    window.addEventListener('resize', checkScreen)
})

onUnmounted(() => {
    window.removeEventListener('resize', checkScreen)
})
</script>