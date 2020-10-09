<template>
  <div id="login">
    <v-form>
      <v-text-field
        v-model="username"
        label="Username"
        id="username"
      ></v-text-field>

      <v-text-field
        v-model="password"
        label="Password"
        id="password"
        type="password"
      ></v-text-field>

      <v-btn color="success" id="submit" @click="signup">Sign up</v-btn>
    </v-form>
  </div>
</template>

<script>
import { apiClient } from "../modules/apiClient";

export default {
  data: () => ({
    username: "",
    password: "",
  }),
  methods: {
    signup() {
      const username = this.username;
      const password = this.password;
      apiClient
        .post("/users", { username, password })
        .then(() => {
          this.$store.dispatch("AUTH_REQUEST").then(() => {
            this.$router.push("/login");
          });
        })
        .catch((error) => {
          console.log(error);
        });
    },
  },
};
</script>
