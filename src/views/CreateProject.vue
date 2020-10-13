<template>
  <v-container>
    <v-row class="text-center">
      <v-col md="4" offset-md="4">
        <h1>Create a Project</h1>

        <v-form @submit.prevent="createProject">
          <v-text-field
            type="text"
            label="Project Name"
            ref="name"
            v-model="name"
            autocomplete="off"
            :rules="[rules.required]"
            :error-messages="nameErrorMessage"
            required
          ></v-text-field>

          <v-btn type="submit" style="margin-top: 8px">Create</v-btn>
        </v-form>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { apiClient } from "../modules/apiClient";

const nameValidationErrors = {
  projectNameAlreadyExists: "The project name already exists.",
  projectNameTooShort: "The project name is too short.",
};

export default {
  data: () => ({
    name: "",
    nameErrorMessage: "",
    formHasErrors: false,
    rules: {
      required: (value) => !!value || "Required",
    },
  }),
  computed: {
    form() {
      return {
        name: this.name,
      };
    },
  },
  watch: {
    name() {
      this.nameErrorMessage = "";
    },
  },
  methods: {
    createProject() {
      this.formHasErrors = false;
      Object.keys(this.form).forEach((f) => {
        if (!this.form[f]) this.formHasErrors = true;
        this.$refs[f].validate(true);
      });

      if (this.formHasErrors) return;

      apiClient
        .post("/projects", this.form)
        .then(() => {
          this.$router.push({ name: "projects" });
        })
        .catch((error) => {
          if (error.response.status != 422) return;
          this.nameErrorMessage =
            nameValidationErrors[error.response.data.reason] || "";
        });
    },
  },
};
</script>
