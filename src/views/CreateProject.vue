<template>
  <v-container>
    <v-row justify="center" class="text-center">
      <v-col md="5">
        <div class="form-container">
          <h1>{{ $t("create_project.title") }}</h1>

          <v-form @submit.prevent="createProject">
            <v-text-field
              type="text"
              :label="$t('create_project.textfield.name_placeholder')"
              ref="name"
              v-model="name"
              autocomplete="off"
              class="form-input"
              :rules="[rules.required]"
              :error-messages="nameErrorMessage"
            ></v-text-field>

            <v-btn type="submit" class="form-submit">{{
              $t("create_project.button.submit")
            }}</v-btn>
          </v-form>
        </div>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { required } from "vuelidate/lib/validators";
import { apiClient } from "@/modules/apiClient";
import i18n from "@/i18n";

const nameValidationErrors = {
  projectNameAlreadyExists: i18n.t(
    "create_project.error.project_name_already_exists"
  ),
};

const requiredMessage = i18n.t("generic.error.field_required");

export default {
  data: () => ({
    name: "",
    nameErrorMessage: "",
    rules: {
      required: (value) => !!value || requiredMessage,
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
  validations: {
    name: {
      required,
    },
  },
  methods: {
    createProject() {
      this.$v.$touch();
      if (this.$v.$invalid) return;

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
