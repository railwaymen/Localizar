<template>
  <div>
    <h3>Main Locale:</h3>
    <p>{{ project.mainLocale }}</p>
    
    <h3>Supported Locales:</h3>
    <p>{{ project.supportedLocales.join(', ') }}</p>
    
  </div>
</template>

<script>
export default {
  name: "LocaleSettings",
  props: ["project"],
  data: () => ({
  
  }),
  methods: {
  },
}
</script>

<style scoped>

</style>
