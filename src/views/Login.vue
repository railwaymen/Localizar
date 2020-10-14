<template>
  <div id="log_in">
    <v-container fluid>
      <v-row justify="center" class="text-center">
        <v-col md="5">
          <div class="form-container">
            <h1>{{ $t("log_in.title") }}</h1>

            <v-form @submit.prevent="logIn">
              <v-text-field
                v-model="username"
                :label="$t('log_in.textfield.username_placeholder')"
                id="username"
                autocomplete="current-login"
                class="form-input"
                :rules="[rules.required]"
              ></v-text-field>

              <v-text-field
                v-model="password"
                :label="$t('log_in.textfield.password_placeholder')"
                id="password"
                type="password"
                autocomplete="current-password"
                class="form-input"
                :rules="[rules.required]"
              ></v-text-field>

              <v-alert
                color="red lighten-1"
                v-show="!areCredentialsValid"
                dark
                transition="scale-transition"
              >
                <v-icon style="margin-right: 8px">mdi-alert</v-icon>
                {{ $t("log_in.error.credentials_not_matching") }}
              </v-alert>

              <v-btn
                color="success"
                id="submit"
                type="submit"
                class="form-submit"
              >
                {{ $t("log_in.button.submit") }}
              </v-btn>
            </v-form>
          </div>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import { required } from "vuelidate/lib/validators";
import i18n from "@/i18n";

const requiredMessage = i18n.t("generic.error.field_required");

export default {
  name: "log_in",
  data: () => ({
    username: "",
    password: "",
    areCredentialsValid: true,
    rules: {
      required: (value) => !!value || requiredMessage,
    },
  }),
  validations: {
    username: {
      required,
    },
    password: {
      required,
    },
  },
  computed: {
    form() {
      return {
        username: this.username,
        password: this.password,
      };
    },
  },
  watch: {
    username() {
      this.areCredentialsValid = true;
    },
    password() {
      this.areCredentialsValid = true;
    },
  },
  methods: {
    logIn() {
      this.$v.$touch;
      if (this.$v.$invalid) return;

      this.$store
        .dispatch("auth/AUTH_REQUEST", this.form)
        .then(() => {
          this.$router.push({ name: "home" });
        })
        .catch((error) => {
          if (error.response.status != 422) return;
          this.areCredentialsValid = false;
        });
    },
  },
};
</script>
