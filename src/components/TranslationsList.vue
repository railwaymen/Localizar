<template>
  <div id="translations-list">
    <v-row
      no-gutters
      style="margin-bottom: 24px;"
    >
      <v-spacer></v-spacer>
      <v-dialog
        v-model="dialog"
        max-width="600px"
      >
        <template v-slot:activator="{ on, attrs }">
          <v-btn
            v-bind="attrs"
            v-on="on"
          >
            {{ $t("translations.button.create") }}
          </v-btn>
        </template>
        <v-card>
          <v-card-title>{{ $t("translations.dialog.title.new") }}</v-card-title>
          <v-card-text>
            <v-container>
              <v-row>
                <v-col cols="12">
                  <v-text-field
                    v-model="editItem.key"
                    :label="$t('translations.dialog.textfield.key')"
                    :error-messages="keyValidationError"
                    @keydown.enter="saveItem"
                  ></v-text-field>
                  <v-text-field
                    v-model="editItem.value"
                    :label="$t('translations.dialog.textfield.value')"
                    @keydown.enter="saveItem"
                  ></v-text-field>
                </v-col>
              </v-row>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn
              text
              @click="closeDialog"
            >
              {{ $t("translations.dialog.button.close") }}
            </v-btn>
            <v-btn
              text
              @click="saveItem"
            >
              {{ $t("translations.dialog.button.save") }}
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-row>
    
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

const validationErrors = {
  keyExists: i18n.t("translations.dialog.error.key_exists")
}

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
    items: [],
    
    dialog: false,
    editItem: {
      key: "",
      value: ""
    },
    defaultItem: {
      key: "",
      value: ""
    },
    keyValidationError: ""
  }),
  computed: {
    editItemKey() {
      return this.editItem.key
    }
  },
  watch: {
    options() {
      this.loadTranslations()
    },
    dialog(val) {
      val || this.closeDialog()
    },
    editItemKey() {
      this.keyValidationError = ""
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
    },
    
    closeDialog() {
      this.dialog = false
      this.$nextTick(() => {
        this.editItem = Object.assign({}, this.defaultItem)
      })
    },
  
    saveItem() {
      if (!this.editItem.key || !this.editItem.value)
        return;
    
      apiClient
        .createTranslation(this.projectSlug, this.editItem)
        .then(() => {
          this.loadTranslations()
          this.closeDialog()
        })
        .catch((error) => {
          if (error.response.status === 422) {
            this.keyValidationError = validationErrors[error.response.data.reason]
          } else {
            console.log(error)
          }
        })
    }
  },
}
</script>
