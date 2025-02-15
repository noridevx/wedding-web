<template>
    <v-container class="text-center position-relative">       
        <h1 class="font-dancing">Dress Code</h1>
        <h3 class="font-dancing">Temática Vikinga</h3>
        <p class="mt-5">Queremos hacer una boda Vikinga y nos gustaría que vinierais tematizados (no disfrazados)</p>
        <h3 class="font-dancing mt-5">Ideas</h3>
        <div class="d-flex align-center">
            <DressCarousel class="w-100 mx-auto" style="max-width: 900px;"/>
        </div>
        <a href="https://www.pinterest.com/elenacg19/vestidos-invitados/" target="_blank">
            <h3 class="font-dancing mt-5 mb-3">Más ideas en pinterest</h3>
        </a>
        <a data-pin-do="embedBoard" data-pin-board-width="300" data-pin-scale-height="240" data-pin-scale-width="80" href="https://www.pinterest.com/elenacg19/vestidos-invitados/"></a>
        <h3 class="font-dancing mt-5">Tiendas donde comprar</h3>
        <div class="d-flex flex-wrap ga-3 mt-3 justify-center">
            <a href="http://api-shein.shein.com/h5/sharejump/appjump?link=lceycvMsnCb_9&localcountry=ES" target="_blank">
                <v-btn>
                    Shein
                </v-btn>
            </a>
            <a href="https://www.aliexpress.com/p/wish-manage/share.html?smbPageCode=wishlist-amp&spreadId=50612c58f68933edb81d55393cd7a4ac96d5e2b793e88218cc509e47800daaad" target="_blank">
                <v-btn>
                    Aliexpress
                </v-btn>
            </a>
            <a href="https://www.celticwebmerchant.com/es/ropa/vikinga/" target="_blank">
                <v-btn>
                    Celtic Webmerchant
                </v-btn>
            </a>
            <a href="https://lacortedeltejon.com/ropa-medieval/camisas" target="_blank">
                <v-btn>
                    La Corte del Tejón
                </v-btn>
            </a>
        </div>        
    </v-container>
</template>
<script setup>
import DressCarousel from './DressCarousel.vue';


</script>
<style lang="scss">

</style>