<script setup lang="ts">
import Confirm from './Confirm.vue';

</script>

<template>
    <v-app-bar color="transparent" elevation="0">
        <v-container class="d-flex align-center">
            <v-app-bar-title class="font-dancing">Elena & Sergio</v-app-bar-title>

            <v-spacer></v-spacer>
            <Confirm />
        </v-container>
    </v-app-bar>
</template>
<style>
.mynav {
    background-color: rgb(83, 78, 78);
    width: 90%;
    margin: auto;
    margin-top: 100px;
    border-radius: 999999px;
}
</style>