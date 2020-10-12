<template>
  <div id="login">
    <h1>Log in</h1>

    <v-form @submit.prevent="login">
      <v-text-field
        v-model="username"
        label="Username"
        id="username"
        autocomplete="current-login"
      ></v-text-field>

      <v-text-field
        v-model="password"
        label="Password"
        id="password"
        type="password"
        autocomplete="current-password"
      ></v-text-field>

      <v-btn color="success" id="submit" type="submit">Submit</v-btn>
    </v-form>
  </div>
</template>

<script>
export default {
  name: "log_in",
  data: () => ({
    username: "",
    password: "",
  }),
  methods: {
    login() {
      const username = this.username;
      const password = this.password;
      this.$store
        .dispatch("auth/AUTH_REQUEST", { username, password })
        .then(() => {
          this.$router.push({ name: "home" });
        });
    },
  },
};
</script>
