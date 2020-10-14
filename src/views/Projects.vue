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
              @click:row="rowClicked"
            >
            </v-data-table>
          </div>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import i18n from "@/i18n";

export default {
  data: () => ({
    headers: [
      { text: i18n.t("projects.table_headers.project_name"), value: "name" },
    ],
    projects: [{ name: "Yes", slug: "yes" }],
  }),
  methods: {
    rowClicked(project) {
      this.$router.push({
        name: "project_panel",
        params: { slug: project.slug },
      });
    },
  },
};
</script>
