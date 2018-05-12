<template lang="pug">
.tats-video-element
  tats-video-content(
    v-for='content in tat.contents'
    :tat='tat'
    :content='content'
    :is_in_form='tat.form_tat'
    :there_is_some_in_form='there_is_some_tat_in_form'
    :key="content.tmp_id"
    :display='display'
  )
</template>

<script lang="coffee">
export default
  props: ['tat', 'there_is_some_tat_in_form', 'display']

  mounted: ->
    # Don't emit rendered event for tat being rendered as a result of "edit" or "new"
    return if @tat.form_tat
    TatApp.vue.event_bridge.$emit 'TatApp::Tats::Rendered', { @tat }

</script>
