<template>
  <NavBar />
  <Landing />
  <DressCode class="mt-10" />
  <Gallery />
  <Place />
  <Footer />
</template>

<script setup>
import DressCode from '@/components/DressCode.vue';
import Footer from '@/components/Footer.vue';
import Gallery from '@/components/Gallery.vue';
import Landing from '@/components/Landing.vue';
import NavBar from '@/components/NavBar.vue';
import Place from '@/components/Place.vue';
</script>

<style lang="scss">
@import url('https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400..700&display=swap');
.font-dancing {
    font-family: "Dancing Script", serif;
    font-optical-sizing: auto;
    h1 {
        font-size: 5rem;
    }
    h3 {
        font-size: 2rem;
    }
}
h1.font-dancing {
  font-size: 5rem;
}
h3.font-dancing {
  font-size: 2rem;
}

.v-main {
  --v-layout-top: 0px !important;
  background-color: #eaeaea;
  color: rgb(var(--v-theme-surface));
}
</style>