<template>
  <div id="sign_up">
    <h1>Sign Up</h1>

    <v-form @submit.prevent="signUp">
      <v-text-field
        v-model="username"
        label="Username"
        id="username"
        autocomplete="username"
      ></v-text-field>

      <v-text-field
        v-model="password"
        label="Password"
        id="password"
        type="password"
        autocomplete="new-password"
      ></v-text-field>

      <v-btn color="success" id="submit" type="sumbit">Sign up</v-btn>
    </v-form>
  </div>
</template>

<script>
import { apiClient } from "../modules/apiClient";

export default {
  name: "sign_up",
  data: () => ({
    username: "",
    password: "",
  }),
  methods: {
    signUp() {
      const username = this.username;
      const password = this.password;
      apiClient
        .post("/users", { username, password })
        .then(() => {
          this.$store
            .dispatch("auth/AUTH_REQUEST", { username, password })
            .then(() => {
              this.$router.push({ name: "home" });
            });
        })
        .catch((error) => {
          console.log(error);
        });
    },
  },
};
</script>
