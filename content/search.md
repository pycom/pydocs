### Search results

{{ results.searchInformation.totalResults }} results in {{ results.searchInformation.formattedSearchTime }} ms.







<template v-if="results == null"  >
  <v-alert color="blue lighten-3" value=true icon="rowing">
    no results.
  </v-alert>
</template>

<template v-for="(item, index) in results.items">
<v-card class="ma-3" @click="navResult(item.formattedUrl)">
<v-card-title class="blue--text text--darken-3 mb-0 pb-0">
<v-icon left>search</v-icon>
    <span class="title"> {{ item.title }}</span>
    </v-card-title>
    <v-card-text class="blue--text text--darken-2 pt-0 mt-0">
       <p class="red--text text--lighten-3 mt-0 pt-0">{{ item.formattedUrl }}</p>
       <v-layout>
       <v-flex v-if="item.pagemap.cse_image">
         <v-img
         ma-4
         contain
          aspect-ratio=1
          v-if="item.pagemap.cse_image"
          :src="item.pagemap.cse_image && item.pagemap.cse_image[0].src">
        </v-img>
        </v-flex>
        <v-flex class="pl-4">
       <span  v-html="item.htmlSnippet"></span>
       </v-flex>
       </v-layout>
    </v-card-text>
  </v-card>


</template>


<div class="text-xs-center">
  <v-pagination
    v-model="page"
    @input="pageClicked"
    @previous="pageClicked($event)"
    @next="pageClicked($event)"
    :length="pageCount"
  ></v-pagination>
  </div>
