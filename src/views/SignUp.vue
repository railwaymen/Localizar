<template>
  <div id="sign_up">
    <v-container fluid>
      <v-row justify="center" class="text-center">
        <v-col md="5">
          <div class="form-container">
            <h1>{{ $t("sign_up.title") }}</h1>

            <v-form @submit.prevent="signUp">
              <v-text-field
                v-model="username"
                :label="$t('sign_up.textfield.username_placeholder')"
                id="username"
                autocomplete="username"
                class="form-input"
                :error-messages="usernameErrorMessage"
                :rules="[rules.usernameMinLength]"
                counter
              ></v-text-field>

              <v-text-field
                v-model="password"
                :label="$t('sign_up.textfield.password_placeholder')"
                id="password"
                type="password"
                autocomplete="new-password"
                class="form-input"
                :rules="[rules.passwordMinLength]"
                counter
              ></v-text-field>

              <v-btn
                color="success"
                id="submit"
                type="sumbit"
                class="form-submit"
              >
                {{ $t("sign_up.button.submit") }}
              </v-btn>
            </v-form>
          </div>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import { required, minLength } from "vuelidate/lib/validators";
import { apiClient } from "../modules/apiClient";
import i18n from "@/i18n";

const usernameValidationErrors = {
  usernameIsNotAlphanumeric: i18n.t(
    "sign_up.error.username_is_not_alphanumeric"
  ),
  usernameAlreadyExists: i18n.t("sign_up.error.username_already_exists"),
};

const usernameMinLength = 4;
const passwordMinLength = 8;

const usernameMinLengthMessage = i18n.t("sign_up.error.minimum_length", {
  count: usernameMinLength.toString(),
});
const passwordMinLengthMessage = i18n.t("sign_up.error.minimum_length", {
  count: passwordMinLength.toString(),
});

export default {
  name: "sign_up",
  data: () => ({
    username: "",
    password: "",
    usernameErrorMessage: "",
    rules: {
      usernameMinLength: (value) =>
        (!!value && value.length >= usernameMinLength) ||
        usernameMinLengthMessage,
      passwordMinLength: (value) =>
        (!!value && value.length >= passwordMinLength) ||
        passwordMinLengthMessage,
    },
  }),
  validations: {
    username: {
      required,
      minLength: minLength(usernameMinLength),
    },
    password: {
      required,
      minLength: minLength(passwordMinLength),
    },
  },
  watch: {
    username() {
      this.usernameErrorMessage = "";
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
  methods: {
    signUp() {
      this.$v.$touch;
      if (this.$v.$invalid) return;

      apiClient
        .post("/users", this.form)
        .then(() => {
          this.$store.dispatch("auth/AUTH_REQUEST", this.form).then(() => {
            this.$router.push({ name: "home" });
          });
        })
        .catch((error) => {
          if (error.response.status != 422) return;
          this.usernameErrorMessage =
            usernameValidationErrors[error.response.data.reason] || "";
        });
    },
  },
};
</script>
