<template>
  <div id="sign_up">
    <h1>Sign Up</h1>

    <v-form @submit.prevent="signUp">
      <v-text-field
        v-model="username"
        label="Username"
        id="username"
        autocomplete="username"
        :error-messages="usernameErrorMessage"
        :rules="[rules.usernameMinLength]"
        counter
      ></v-text-field>

      <v-text-field
        v-model="password"
        label="Password"
        id="password"
        type="password"
        autocomplete="new-password"
        :rules="[rules.passwordMinLength]"
        counter
      ></v-text-field>

      <v-btn color="success" id="submit" type="sumbit">Sign up</v-btn>
    </v-form>
  </div>
</template>

<script>
import { required, minLength } from "vuelidate/lib/validators";
import { apiClient } from "../modules/apiClient";

const usernameValidationErrors = {
  usernameIsNotAlphanumeric:
    "The username should contain only letters and numbers.",
  usernameAlreadyExists: "The username already exists.",
};

const usernameMinLength = 4;
const passwordMinLength = 8;

export default {
  name: "sign_up",
  data: () => ({
    username: "",
    password: "",
    usernameErrorMessage: "",
    rules: {
      usernameMinLength: (value) =>
        (!!value && value.length >= usernameMinLength) ||
        "Minimum " + usernameMinLength + " characters",
      passwordMinLength: (value) =>
        (!!value && value.length >= passwordMinLength) ||
        "Minimum " + passwordMinLength + " characters",
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
