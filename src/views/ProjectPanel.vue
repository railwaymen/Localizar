<template>
    <v-container
      :class="containerClass"
      fluid
    >
      <v-row
        justify="center"
        v-show="!isViewLoading"
      >
        <v-col md="8">
          <h1 class="page-title">{{ project.name }}</h1>
          <v-row style="margin-bottom: 24px;">
            <v-btn
              :color="translationsButtonColor"
              @click="toggleTranslationsView"
              class="nav-btn"
            >
              {{ $t("project_panel.button.translations") }}
            </v-btn>
            <v-btn
              :color="optionsButtonColor"
              @click="toggleOptionsView"
              class="nav-btn"
            >
              {{ $t("project_panel.button.options") }}
            </v-btn>
          </v-row>
    
          <TranslationsList
            :project-slug="projectSlug"
            :locale="project.mainLocale"
            v-show="isTranslationsViewVisible"
          ></TranslationsList>
          
          <LocaleSettings
            :project="project"
            v-show="isOptionsViewVisible"
          ></LocaleSettings>
        </v-col>
      </v-row>
      <v-row
        align="center"
        justify="center"
        class="text-center fill-height"
        v-show="isViewLoading"
      >
        <v-col>
          <v-progress-circular
            indeterminate
          ></v-progress-circular>
        </v-col>
      </v-row>
    </v-container>
</template>

<script>
import apiClient from "@/modules/apiClient";
import TranslationsList from "@/components/TranslationsList";
import LocaleSettings from "@/components/LocaleSettings";

export default {
  components: {LocaleSettings, TranslationsList},
  data: () => ({
    project: {},
    isViewLoading: false,
    containerClass: "",
    isTranslationsViewVisible: false,
    translationsButtonColor: "",
    isOptionsViewVisible: false,
    optionsButtonColor: "",
  }),
  watch: {
    isViewLoading(val) {
      this.containerClass = val ? "fill-height" : ""
    },
    isTranslationsViewVisible(val) {
      this.translationsButtonColor = val ? "primary" : ""
    },
    isOptionsViewVisible(val) {
      this.optionsButtonColor = val ? "primary" : ""
    }
  },
  computed: {
    projectSlug() {
      return this.$route.params.slug
    }
  },
  mounted() {
    this.loadProject()
    this.isTranslationsViewVisible = true
  },
  methods: {
    loadProject() {
      this.isViewLoading = true
      apiClient
        .getProject(this.projectSlug)
        .then((response) => {
          this.project = response.data
          this.isViewLoading = false
        })
        .catch((error) => {
          console.log(error)
          this.isViewLoading = false
        })
    },
  
    toggleTranslationsView() {
      if (!this.isTranslationsViewVisible) {
        this.hideAllViews()
        this.isTranslationsViewVisible = true
      }
    },
  
    toggleOptionsView() {
      if (!this.isOptionsViewVisible) {
        this.hideAllViews()
        this.isOptionsViewVisible = true
      }
    },
  
    hideAllViews() {
      this.isTranslationsViewVisible = false
      this.isOptionsViewVisible = false
    }
  }
}
</script>

<style scoped>
.chat-area {
  position: relative;
  top: 0;
  bottom: 15%;
  width: 100%;
}
</style>
