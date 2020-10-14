<template>
  <v-app>
    <v-app-bar app dark>
      <v-toolbar-title id="app_title">Localizar</v-toolbar-title>

      <v-btn :to="{ name: 'home' }" class="nav-btn" exact>
        {{ $t("navbar_btn.home") }}
      </v-btn>
      <v-btn :to="{ name: 'about' }" class="nav-btn" exact>
        {{ $t("navbar_btn.about") }}
      </v-btn>

      <v-spacer></v-spacer>

      <v-btn :to="{ name: 'projects' }" class="nav-btn" v-if="isAuthenticated">
        {{ $t("navbar_btn.projects") }}
      </v-btn>
      <v-btn
        color="error"
        class="nav-btn"
        v-if="isAuthenticated"
        @click="logout"
        exact
      >
        {{ $t("navbar_btn.log_out") }}
      </v-btn>

      <v-btn
        :to="{ name: 'sign_up' }"
        color="success"
        class="nav-btn"
        v-if="!isAuthenticated"
        exact
      >
        {{ $t("navbar_btn.sign_up") }}
      </v-btn>
      <v-btn
        :to="{ name: 'log_in' }"
        color="info"
        class="nav-btn"
        v-if="!isAuthenticated"
        exact
      >
        {{ $t("navbar_btn.log_in") }}
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
  created() {
    this.$i18n.locale = navigator.language.split("-")[0];
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

#app_title {
  margin-left: 8px;
  margin-right: 24px;
  font-weight: bold;
  font-size: 1.5rem;
}

.form-container {
  -webkit-box-shadow: 0px 4px 24px 0px rgba(0, 0, 0, 0.3);
  -moz-box-shadow: 0px 4px 24px 0px rgba(0, 0, 0, 0.3);
  box-shadow: 0px 4px 24px 0px rgba(0, 0, 0, 0.3);
  padding: 48px;
  border-radius: 12px;
}

.form-input {
  margin-top: 8px;
  margin-bottom: 8px;
}

.form-submit {
  margin-top: 16px;
}
</style>
