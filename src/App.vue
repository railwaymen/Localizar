<template>
  <v-app>
    <v-app-bar app dark>
      <v-toolbar-title>Localizar</v-toolbar-title>

      <v-spacer></v-spacer>

      <v-btn to="/" class="nav-btn">Home</v-btn>
      <v-btn to="/about" class="nav-btn">About</v-btn>

      <v-spacer></v-spacer>
      <v-btn to="/sign_up" color="success" class="nav-btn">Sign up</v-btn>
      <v-btn to="/login" color="info" class="nav-btn">Log in</v-btn>
    </v-app-bar>

    <v-main>
      <v-container fluid>
        <router-view></router-view>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
export default {
  methods: {
    logout: () => {
      this.$store.dispatch("AUTH_LOGOUT").then(() => {
        this.$router.push("/login");
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
