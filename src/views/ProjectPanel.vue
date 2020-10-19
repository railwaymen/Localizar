<template>
    <v-container
      :class="containerClass"
      fluid
    >
      <v-row
        align="top"
        justify="center"
        v-show="!isViewLoading"
      >
        <v-col md="8">
          <h1>{{ project.name }}</h1>
          <p>Visible</p>
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

export default {
  data: () => ({
    project: {},
    isViewLoading: false,
    containerClass: ""
  }),
  watch: {
    isViewLoading(val) {
      this.containerClass = val ? "fill-height" : ""
    }
  },
  mounted() {
    this.loadProject()
  },
  methods: {
    loadProject() {
      this.isViewLoading = true
      const slug = this.$route.params.slug
      apiClient
        .getProject(slug)
        .then((response) => {
          this.project = response.data
          this.isViewLoading = false
        })
        .catch((error) => {
          console.log(error)
          this.isViewLoading = false
        })
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
