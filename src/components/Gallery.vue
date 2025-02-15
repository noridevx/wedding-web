<template>
    <v-container style="max-width: 900px;" class="text-center">
        <h1 class="font-dancing ">Fotos Preboda</h1>
        <p class="mb-5">Selecciona una foto para verla en grande</p>
        <v-row>
            <v-col v-for="image in images" class="d-flex child-flex" cols="12" sm="6" md="4" lg="3">
                <v-img
                    :src="image"
                    aspect-ratio="1"
                    class="bg-grey-lighten-2"
                    cover
                >
                    <template v-slot:placeholder>
                        <v-row align="center" class="fill-height ma-0" justify="center">
                            <v-progress-circular color="grey-lighten-5" indeterminate />
                        </v-row>
                    </template>
                </v-img>
            </v-col>
        </v-row>
    </v-container>
</template>
<script setup>

const images = Object.values(import.meta.glob('@/assets/pictures/redes/*', { eager: true })).map(i => i.default);
</script>