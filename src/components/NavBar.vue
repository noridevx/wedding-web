<script setup lang="ts">
import Confirm from './Confirm.vue';

</script>

<template>
    <v-app-bar color="transparent" elevation="0">
        <v-container class="d-flex align-center">
            <v-app-bar-title class="font-dancing">
                <div class="text-center d-inline-block">
                    <div class="mb-0 pb-0">Elena & Sergio</div>
                    <div style="font-size: 0.5rem; line-height: 0.5rem;">08-11-2025</div>
                </div>
            </v-app-bar-title>

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