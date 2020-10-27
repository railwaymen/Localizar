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
          <v-btn
            :color="translationsButtonColor"
            @click="toggleTranslationsView"
            style="margin-bottom: 24px;"
          >
            {{ $t("project_panel.button.translations") }}
          </v-btn>
          
          <TranslationsList
            :project-slug="projectSlug"
            :locale="project.mainLocale"
            v-show="isTranslationsViewVisible"
          ></TranslationsList>
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

export default {
  components: {TranslationsList},
  data: () => ({
    project: {},
    isViewLoading: false,
    containerClass: "",
    isTranslationsViewVisible: false,
    translationsButtonColor: ""
  }),
  watch: {
    isViewLoading(val) {
      this.containerClass = val ? "fill-height" : ""
    },
    isTranslationsViewVisible(val) {
      this.translationsButtonColor = val ? "primary" : ""
    }
  },
  computed: {
    projectSlug() {
      return this.$route.params.slug
    }
  },
  mounted() {
    this.loadProject()
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
      if (this.isTranslationsViewVisible) {
        this.hideAllViews()
      } else {
        this.hideAllViews()
        this.isTranslationsViewVisible = true
      }
    },
    hideAllViews() {
      this.isTranslationsViewVisible = false
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
