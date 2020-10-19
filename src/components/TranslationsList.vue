<template>
  <div id="translations-list">
    <h1>{{ projectSlug }}</h1>
    <v-data-table
      :headers="headers"
      :items="items"
      :page.sync="page"
      :options.sync="options"
      :loading="loading"
      :items-per-page="itemsPerPage"
      :server-items-length="totalItems"
      class="elevation-1"
      hide-default-footer
      @page-count="pageCount = $event"
    ></v-data-table>
    <v-pagination
      v-model="page"
      :length="pageCount"
    ></v-pagination>
  </div>
</template>

<script>
import i18n from "@/i18n";
import apiClient from "@/modules/apiClient";

export default {
  name: "TranslationsList",
  props: ["projectSlug", "locale"],
  data: () => ({
    itemsPerPage: 50,
    page: 1,
    pageCount: 0,
    totalItems: 0,
    loading: false,
    options: {},
    headers: [
      {
        text: i18n.t("translations.table_headers.key"),
        value: "key",
        sortable: false
      },
      {
        text: i18n.t("translations.table_headers.value"),
        value: "value",
        sortable: false
      }
    ],
    items: []
  }),
  watch: {
    options() {
      this.loadTranslations()
    }
  },
  methods: {
    loadTranslations() {
      this.loading = true
      const { page, itemsPerPage: perPage } = this.options
      const options = { page, perPage }
      apiClient
        .getTranslations(this.projectSlug, options)
        .then((response) => {
          this.totalItems = response.data.total
          this.items = response.data.items
          this.loading = false
        })
        .catch((error) => {
          console.log(error)
          this.loading = false
        })
    }
  }
}
</script>
