<template lang="pug">
.tats-list-item
  template(v-if="confirming_destroy")
    br
    .ui.red.message Really delete tat?

    .ui.fluid.small.buttons
      .ui.red.button(@click='destroy()')
        | Yes

      .ui.basic.button(@click='cancelDestroy()')
        | No

    br
    br

  template(v-if="tat && !confirming_destroy")
    | {{ tat.contents[0].content | ellipsis(40) }}

    .tats-list-item-actions
      .tats-list-item-action(@click="view()")
        i.fa.fa-eye

      .tats-list-item-action(@click="confirmDestroy()" v-if="allow_destructive_actions")
        i.fa.fa-trash

      .tats-list-item-action(@click="edit()" v-if="allow_destructive_actions")
        i.fa.fa-edit
</template>

<script lang="coffee">
export default
  props:
    tat:
      required: true

    allow_destructive_actions:
      default: false

  data: ->
    confirming_destroy: false

  methods:
    view: (options = {}) ->
      TatApp.vue.event_bridge.$emit 'TatApp::Tats::View', { @tat, options }

    edit: ->
      @view pause: true, skip_analytics: true
      TatApp.vue.event_bridge.$emit 'TatApp::Tats::Edit', { @tat }

    destroy: ->
      TatApp.vue.event_bridge.$emit 'TatApp::Tats::Destroy', { @tat }

    confirmDestroy: ->
      @view pause: true, skip_analytics: true
      @confirming_destroy = true
      TatApp.vue.event_bridge.$emit 'TatApp::Tats::ConfirmDestroy', { @tat }

    cancelDestroy: ->
      @confirming_destroy = false
      TatApp.vue.event_bridge.$emit 'TatApp::Tats::CancelDestroy', { @tat }
</script>
