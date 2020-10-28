<template>
  <div>
    <h3>Main Locale:</h3>
    <p>{{ project.mainLocale }}</p>
    
    <h3>Supported Locales:</h3>
    <p v-show="!editMode">{{ project.supportedLocales.join(', ') }}</p>
    <v-autocomplete
      v-model="editItem.supportedLocales"
      :loading="localesLoading"
      :items="locales"
      chips
      small-chips
      multiple
      deletable-chips
      v-show="editMode"
      item-value="id"
      item-text="name"
    ></v-autocomplete>
    
    <v-btn
      @click="edit"
      v-show="!editMode"
      class="nav-btn"
    >
      {{ $t("locale_settings.button.edit") }}
    </v-btn>
    
    <v-btn
      @click="cancelEditing"
      v-show="editMode"
      class="nav-btn"
    >
      {{ $t("locale_settings.button.cancel") }}
    </v-btn>
    
    <v-btn
      @click="save"
      v-show="editMode"
      class="nav-btn"
      color="success"
    >
      {{ $t("locale_settings.button.save") }}
    </v-btn>
  </div>
</template>

<script>
import apiClient from "@/modules/apiClient";

export default {
  name: "LocaleSettings",
  props: ["project"],
  data: () => ({
    editMode: false,
    editItem: {
      slug: "",
      mainLocale: "",
      supportedLocales: [],
    },
    defaultItem: {
      slug: "",
      mainLocale: "",
      supportedLocales: [],
    },
    localesLoading: false,
    locales: [],
  }),
  methods: {
    loadLocales() {
      this.localesLoading = true
      apiClient
        .getLocales()
        .then((response) => {
          this.locales = response.data
          this.localesLoading = false
        })
        .catch((error) => {
          console.log(error)
          this.localesLoading = false
        })
    },
    
    edit() {
      this.editItem = Object.assign({}, this.project)
      this.editMode = true
      this.locales.length > 0 || this.localesLoading || this.loadLocales()
    },
  
    cancelEditing() {
      this.editItem = Object.assign({}, this.defaultItem)
      this.editMode = false
    },
    
    save() {
      this.updateModel()
        .then(() => {
          this.editItem = Object.assign({}, this.defaultItem)
          this.editMode = false
        })
    },
  
    updateModel() {
      return new Promise((resolve, reject) => {
        apiClient
          .updateProject(this.editItem)
          .then((response) => {
            this.project = response.data
            resolve(response)
          })
          .catch((error) => {
            console.log(error)
            reject(error)
          })
      })
    },
  },
}
</script>

<style scoped>

</style>
