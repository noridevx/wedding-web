<template>
  <Carousel v-bind="carouselConfig">
    <Slide>
      <img
        class="w-100"
        src="@/assets/pictures/disfraces/0abfc3c232b5605638b6a1bc4b4fea44.jpg"
      >
    </Slide>
    <Slide>
      <img
        class="w-100"
        src="@/assets/pictures/disfraces/0d07e1bae28358e1407546e092d95644.jpg"
      >
    </Slide>
    <Slide>
      <img
        class="w-100"
        src="@/assets/pictures/disfraces/0ea0de88969830f5b9ad651d304a230c.jpg"
      >
    </Slide>
    <Slide>
      <img
        class="w-100"
        src="@/assets/pictures/disfraces/13c45dd8c5a5720a06b602afae6498a2.jpg"
      >
    </Slide>
    <Slide>
      <img
        class="w-100"
        src="@/assets/pictures/disfraces/63c6a44365739085a21e09bfe917fb97.jpg"
      >
    </Slide>
    <Slide>
      <img
        class="w-100"
        src="@/assets/pictures/disfraces/64a06202202a4be5700d138ee6d405aa.jpg"
      >
    </Slide>
    <Slide>
      <img
        class="w-100"
        src="@/assets/pictures/disfraces/86edc50a430e75061e05f7a0ebdd270b.jpg"
      >
    </Slide>
    <Slide>
      <img
        class="w-100"
        src="@/assets/pictures/disfraces/218fc5a156c4cfbba65eea054b0a78f4.jpg"
      >
    </Slide>
    <Slide>
      <img
        class="w-100"
        src="@/assets/pictures/disfraces/423a6f3547f3ad2e04bb2ead7e9270ff.jpg"
      >
    </Slide>
    <Slide>
      <img
        class="w-100"
        src="@/assets/pictures/disfraces/781fb6761e1f04e9eb6bc51f09c52af1.jpg"
      >
    </Slide>
    <Slide>
      <img
        class="w-100"
        src="@/assets/pictures/disfraces/7139addd6c904580abc577560ce2cc92.jpg"
      >
    </Slide>
    <Slide>
      <img
        class="w-100"
        src="@/assets/pictures/disfraces/4799419c3d9ad93a58aa8779a4bbc702.jpg"
      >
    </Slide>
    <Slide>
      <img
        class="w-100"
        src="@/assets/pictures/disfraces/d90028b8d063c8cd113c2bedebd17c3d.jpg"
      >
    </Slide>
    <Slide>
      <img
        class="w-100"
        src="@/assets/pictures/disfraces/e0b65fb8845c5b786d06461c98091315.jpg"
      >
    </Slide>
    <Slide>
      <img
        class="w-100"
        src="@/assets/pictures/disfraces/ee84154d472340e4c5d07af33854ed66.jpg"
      >
    </Slide>
    <Slide>
      <img
        class="w-100"
        src="@/assets/pictures/disfraces/f078e52e040d7a3d0c61a9bd44bc8772.jpg"
      >
    </Slide>
    <Slide>
      <img
        class="w-100"
        src="@/assets/pictures/disfraces/fa3216bf6e1e9df1d00dac157d160d0b.jpg"
      >
    </Slide>
    <template #addons>
      <Navigation />
    </template>
  </Carousel>    
</template>
<script setup>
import 'vue3-carousel/carousel.css'
import { Carousel, Slide, Navigation } from 'vue3-carousel'
const carouselConfig = {
    itemsToShow: 1,
    wrapAround: true,
    breakpointMode: 'carousel',
    breakpoints: {
        500: {
            itemsToShow: 2,
        },
        800: {
            itemsToShow: 3,
        },
    }
}
</script>