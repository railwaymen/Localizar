<template>
  <v-app>
    <v-app-bar app dark>
      <v-toolbar-title>Localizar</v-toolbar-title>

      <v-spacer></v-spacer>

      <v-btn :to="{ name: 'home' }" class="nav-btn" exact>Home</v-btn>
      <v-btn :to="{ name: 'about' }" class="nav-btn" exact>About</v-btn>

      <v-spacer></v-spacer>

      <v-btn
        :to="{ name: 'projects' }"
        class="nav-btn"
        v-if="isAuthenticated"
        exact
      >
        Projects
      </v-btn>

      <v-btn
        color="error"
        class="nav-btn"
        v-if="isAuthenticated"
        @click="logout"
        exact
      >
        Log out
      </v-btn>

      <v-btn
        :to="{ name: 'sign_up' }"
        color="success"
        class="nav-btn"
        v-if="!isAuthenticated"
        exact
      >
        Sign up
      </v-btn>
      <v-btn
        :to="{ name: 'log_in' }"
        color="info"
        class="nav-btn"
        v-if="!isAuthenticated"
        exact
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
import { mapGetters } from "vuex";

export default {
  computed: {
    ...mapGetters("auth", ["isAuthenticated"]),
  },
  methods: {
    logout() {
      this.$store.dispatch("auth/AUTH_LOGOUT").then(() => {
        this.$router.push("/log_in");
      });
    },
  },
};
</script>

<style>
.nav-btn {
  margin-left: 4px;
  margin-right: 4px;
}
</style>
