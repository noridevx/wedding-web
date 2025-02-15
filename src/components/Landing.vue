<template>
    <div class="bg-white landing-background text-center">
        <div class="position-relative" style="z-index: 1;">
            <v-container>
                <div class="pt-10 font-dancing">
                    <h1>Elena & Sergio</h1>
                    <h3>08-11-2025</h3>
                </div>
            </v-container>
        </div>
        
        <div class="position-absolute left-0 right-0 bottom-0" style="z-index: 0;">
            <v-img
                width="60%"
                aspect-ratio="16/9"
                cover
                src="@/assets/pictures/landing-2.jpg"
                class="ma-auto"
            ></v-img>
        </div>
    </div>
</template>
<script setup>
</script>
<style lang="scss">
.landing-background {
    height: 100vh;
    font-size: 1.5rem;
    position: relative;
}
</style>