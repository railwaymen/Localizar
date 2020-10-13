<template>
  <div id="log_in">
    <v-container fluid>
      <v-row justify="center">
        <v-col md="5">
          <div id="form-container">
            <h1>Log in</h1>

            <v-form @submit.prevent="logIn">
              <v-text-field
                v-model="username"
                label="Username"
                id="username"
                autocomplete="current-login"
                :rules="[rules.required]"
              ></v-text-field>

              <v-text-field
                v-model="password"
                label="Password"
                id="password"
                type="password"
                autocomplete="current-password"
                :rules="[rules.required]"
              ></v-text-field>

              <v-alert
                color="red lighten-1"
                v-show="!areCredentialsValid"
                dark
                transition="scale-transition"
              >
                <v-icon style="margin-right: 8px">mdi-alert</v-icon>
                The provided username and password combination is invalid. Make
                sure you have Caps Lock turned off.
              </v-alert>

              <v-btn color="success" id="submit" type="submit">Submit</v-btn>
            </v-form>
          </div>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import { required } from "vuelidate/lib/validators";

export default {
  name: "log_in",
  data: () => ({
    username: "",
    password: "",
    areCredentialsValid: true,
    rules: {
      required: (value) => !!value || "Required",
    },
  }),
  validations: {
    username: {
      required,
    },
    password: {
      required,
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
  watch: {
    username() {
      this.areCredentialsValid = true;
    },
    password() {
      this.areCredentialsValid = true;
    },
  },
  methods: {
    logIn() {
      this.$v.$touch;
      if (this.$v.$invalid) return;

      this.$store
        .dispatch("auth/AUTH_REQUEST", this.form)
        .then(() => {
          this.$router.push({ name: "home" });
        })
        .catch((error) => {
          if (error.response.status != 422) return;
          this.areCredentialsValid = false;
        });
    },
  },
};
</script>

<style>
#form-container {
  -webkit-box-shadow: 0px 4px 25px 0px rgba(0, 0, 0, 0.3);
  -moz-box-shadow: 0px 4px 25px 0px rgba(0, 0, 0, 0.3);
  box-shadow: 0px 4px 25px 0px rgba(0, 0, 0, 0.3);
  padding: 48px;
  border-radius: 12px;
}
</style>
