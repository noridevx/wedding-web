<template>
    <v-dialog max-width="700" >
        <template v-slot:activator="{ props: activatorProps }">
        <v-btn
            v-bind="activatorProps"
            text="Confirmar"
            variant="flat"
        ></v-btn>
        </template>

        

        <template v-slot:default="{ isActive }">
            <v-btn size="small" icon="mdi-close" class="position-absolute" style="top: -10px; right: -10px; z-index: 9;"  @click="isActive.value = false"></v-btn>
            <v-card color="white" class="position-relative">
                <v-card-text class="pa-0">
                <iframe src="https://docs.google.com/forms/d/e/1FAIpQLSerHmZZ4KKiLCY51aaTuYeZAVeeSP2_ZUJv_TwnG_gn5pTjgw/viewform?embedded=true" width="100%" height="729" frameborder="0" marginheight="0" marginwidth="0">Cargando…</iframe>
                </v-card-text>
            </v-card>
        </template>
    </v-dialog>
</template>