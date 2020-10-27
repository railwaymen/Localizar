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
    >
      <template v-slot:top>
        <v-dialog v-model="dialogDelete" max-width="500px">
          <v-card>
            <v-card-title class="headline">{{ $t("translations.dialog_delete.title") }}</v-card-title>
            <v-card-text>{{ $t("translations.dialog_delete.message", { key: editItem.key }) }}</v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="closeDelete">
                {{ $t("translations.dialog_delete.button.cancel") }}
              </v-btn>
              <v-btn color="red darken-1" text @click="deleteItemConfirm">
                {{ $t("translations.dialog_delete.button.confirm") }}
              </v-btn>
              <v-spacer></v-spacer>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </template>
      <template v-slot:item.actions="{ item }">
        <v-icon
          small
          @click="deleteItem(item)"
        >
          mdi-delete
        </v-icon>
      </template>
    </v-data-table>
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
        sortable: false,
      },
      {
        text: i18n.t("translations.table_headers.value"),
        value: "value",
        sortable: false,
      },
      {
        text: i18n.t("translations.table_headers.actions"),
        value: "actions",
        sortable: false,
      }
    ],
    items: [],
    
    dialog: false,
    dialogDelete: false,
    editIndex: -1,
    editItem: {
      id: null,
      key: "",
      value: ""
    },
    defaultItem: {
      id: null,
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
    dialogDelete(val) {
      val || this.closeDelete()
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
  
    deleteItem(item) {
      this.editIndex = this.items.indexOf(item)
      this.editItem = Object.assign({}, item)
      this.dialogDelete = true
    },
  
    deleteItemConfirm() {
      this.loading = true
      apiClient
        .deleteTranslation(this.projectSlug, this.editItem.id)
        .then(() => {
          this.closeDelete()
          this.loadTranslations()
        })
        .catch((error) => {
          console.log(error)
          this.loading = false
        })
    },
  
    closeDelete() {
      this.dialogDelete = false
      this.$nextTick(() => {
        this.editIndex = -1
        this.editedItem = Object.assign({}, this.defaultItem)
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
