<template lang="pug">
.terms-and-privacy-links.ui.two.column.grid
  .column
    a(:href = 'terms_url', @click='view("Terms")', target='blank')
      | Terms and conditions

  .column
    a(:href = 'privacy_url', @click='view("Privacy")', target='blank')
      | Privacy Policy

</template>

<script lang="coffee">
  export default
    methods:
      view: (view) ->
        TatApp.vue.event_bridge.$emit "TatApp::View::#{view}"

    computed:
      terms_url: ->
        TatApp.config.app_url+'/Terms and Conditions.pdf'

      privacy_url: ->
        TatApp.config.app_url+'/Privacy Policy.pdf'
</script>
