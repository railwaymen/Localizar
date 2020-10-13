<template>
  <v-container>
    <v-row class="text-center">
      <v-col md="4" offset-md="4">
        <h1>Create a Project</h1>

        <v-form @submit.prevent="createProject">
          <v-text-field
            type="text"
            label="Project Name"
            v-model="projectName"
            autocomplete="off"
          ></v-text-field>

          <v-btn type="submit">Create</v-btn>
        </v-form>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { apiClient } from "../modules/apiClient";

export default {
  data: () => ({
    projectName: "",
  }),
  methods: {
    createProject() {
      const name = this.projectName;
      apiClient
        .post("/projects", { name })
        .then(() => {
          this.$router.push({ name: "projects" });
        })
        .catch((error) => {
          console.log(error);
        });
    },
  },
};
</script>
