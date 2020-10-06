<template>
  <v-app>
    <v-app-bar app dark>
      <v-toolbar-title>Localizar</v-toolbar-title>

      <v-spacer></v-spacer>

      <v-btn to="/" class="nav-btn">Home</v-btn>
      <v-btn to="/about" class="nav-btn">About</v-btn>

      <v-spacer></v-spacer>

      <v-btn to="/projects" class="nav-btn" v-if="this.$store.isAuthenticated">
        Projects
      </v-btn>

      <v-btn
        color="error"
        class="nav-btn"
        v-if="this.$store.isAuthenticated"
        @click="logout"
      >
        Log out
      </v-btn>

      <v-btn
        to="/sign_up"
        color="success"
        class="nav-btn"
        v-if="!this.$store.isAuthenticated"
      >
        Sign up
      </v-btn>
      <v-btn
        to="/login"
        color="info"
        class="nav-btn"
        v-if="!this.$store.isAuthenticated"
      >
        Log in
      </v-btn>
    </v-app-bar>

    <v-main>
      <v-container fluid>
        <router-view></router-view>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
const axios = require("axios").default;

export default {
  methods: {
    logout: () => {
      this.$store.dispatch("AUTH_LOGOUT").then(() => {
        this.$router.push("/login");
      });
    },
  },
  created: () => {
    axios.interceptors.response.use(undefined, (error) => {
      return new Promise(() => {
        if (
          error.status === 401 &&
          error.config &&
          !error.config.__isRetryRequest
        ) {
          this.$store.dispatch("AUTH_LOGOUT");
        }
        throw error;
      });
    });
  },
};
</script>

<style>
.nav-btn {
  margin-left: 4px;
  margin-right: 4px;
}
</style>
