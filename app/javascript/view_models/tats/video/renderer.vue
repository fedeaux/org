<template lang="pug">
#tats-video-renderer-wrapper
  tats-video-element(
    v-for='tat in visible_tats'
    :tat='tat'
    :there_is_some_tat_in_form='there_is_some_tat_in_form'
    :key="tat.tmp_id"
    :display='display'
  )
</template>

<script lang="coffee">
export default
  props: ['tats', 'current_video_time', 'there_is_some_tat_in_form', 'display']

  computed:
    visible_tats: ->
      tat for tat in @tats when tat.isVisibleAt @current_video_time
</script>
