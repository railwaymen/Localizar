<template>
  <div id="projects">
    <h1>{{ $t("projects.title") }}</h1>
    <v-btn :to="{ name: 'create_project' }">
      {{ $t("projects.button.create_new") }}
    </v-btn>
  </div>
</template>
