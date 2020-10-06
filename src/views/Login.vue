<template>
  <div id="login">
    <v-form>
      <v-text-field
        name="username"
        label="Username"
        id="username"
      ></v-text-field>

      <v-text-field
        name="password"
        label="Password"
        id="password"
        type="password"
      ></v-text-field>

      <v-btn color="success" id="submit">Submit</v-btn>
    </v-form>
  </div>
</template>

<script>
export default {
  methods: {
    login: () => {
      const { username, password } = this;
      this.$store.dispatch("AUTH_REQUEST", { username, password }).then(() => {
        this.$router.push("/");
      });
    },
  },
};
</script>
