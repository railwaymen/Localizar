<template>
  <div id="login">
    <v-form ref="form">
      <v-text-field
        v-model="username"
        name="username"
        label="Username"
        id="username"
      ></v-text-field>

      <v-text-field
        v-model="password"
        label="Password"
        id="password"
        type="password"
      ></v-text-field>

      <v-btn color="success" id="submit" @click="login">Submit</v-btn>
    </v-form>
  </div>
</template>

<script>
export default {
  data: () => ({
    username: "",
    password: "",
  }),
  methods: {
    login() {
      const username = this.username;
      const password = this.password;
      this.$store.dispatch("AUTH_REQUEST", { username, password }).then(() => {
        this.$router.push("/");
      });
    },
  },
};
</script>
