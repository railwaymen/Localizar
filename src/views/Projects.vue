<template>
  <div id="projects">
    <v-container>
      <v-row justify="center">
        <v-col md="8">
          <div class="form-container">
            <v-row>
              <h1>{{ $t("projects.title") }}</h1>
              <v-spacer></v-spacer>
              <v-btn :to="{ name: 'create_project' }">
                {{ $t("projects.button.create_new") }}
              </v-btn>
            </v-row>

            <v-data-table
              :headers="headers"
              :items="projects"
              :loading="loading"
              @click:row="rowClicked"
            ></v-data-table>
          </div>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import i18n from "@/i18n";
import apiClient from "@/modules/apiClient";

export default {
  data: () => ({
    loading: true,
    headers: [
      { text: i18n.t("projects.table_headers.project_name"), value: "name" },
    ],
    projects: [],
  }),
  mounted() {
    this.loadData();
  },
  methods: {
    loadData() {
      this.loading = true;
      apiClient
        .getProjects()
        .then((response) => {
          this.projects = response.data;
          this.loading = false;
        })
        .catch((error) => {
          console.log(error);
          this.loading = false;
        });
    },
    rowClicked(project) {
      this.$router.push({
        name: "project_panel",
        params: { slug: project.slug },
      });
    },
  },
};
</script>
