<template lang="pug">
.datetime-picker
  a.action(@click='showDatepicker()')
    | {{ date_display }}

  datepicker.inline(v-model='datepicker_date' :calendar-button='true' :input-class='"hidden"')

  input(v-model='time_display')

  .datetime-picker-actions.icon-actions
    i.chevron.left.icon(@click='subOneDay()')
    i.chevron.right.icon(@click='addOneDay()')
    i.chevron.down.icon(@click='roundDown()')
    i.chevron.up.icon(@click='roundUp()')
</template>

<script lang="coffee">

export default
  props: ['value']

  data: ->
    inner_value: null
    datepicker_date: null
    time_display: ''

  methods:
    subOneDay: ->
      return unless @datepicker_date
      @datepicker_date.setDate @datepicker_date.getDate() - 1
      @setDateFromDatepickerDate()

    addOneDay: ->
      return unless @datepicker_date
      @datepicker_date.setDate @datepicker_date.getDate() + 1
      @setDateFromDatepickerDate()

    roundDown: ->
      minutes = @inner_value.minutes()
      rest = minutes % 5
      @inner_value.minutes minutes - rest
      @innerValueChanged()

    roundUp: ->
      minutes = @inner_value.minutes()
      rest = 5 - minutes % 5
      return if rest == 5
      @inner_value.minutes minutes + rest
      @innerValueChanged()

    showDatepicker: ->
      $('.vdp-datepicker__calendar-button', @$el).click()

    update: ->
      return if !@value and !@inner_value or (@value and @inner_value and @value.format() == @inner_value.format())
      @$emit 'input', @inner_value

    copyValue: ->
      @inner_value = @value and @value._isAMomentObject and @value.clone() or null

    setDefaultInnerValue: ->
      @inner_value = moment()
      @update()

    updateTimeDisplay: ->
      return '' unless @inner_value
      @time_display = @inner_value.format 'HH:mm'

    datepickerDate: ->
      return null unless @inner_value
      @inner_value.toDate()

    updateDatepickerDate: ->
      @datepicker_date = @datepickerDate()

    innerValueChanged: ->
      @updateTimeDisplay()
      @updateDatepickerDate()
      @update()

    setTimeFromTimeDisplay: ->
      components = _.map(@time_display.split(':'), (c) -> parseInt c)

      return unless components[0] >= 0 and components[0] <= 23 and
        components[1] >= 0 and components[1] <= 59 and
        (@inner_value.hours() != components[0] or @inner_value.minutes() != components[1])

      @inner_value.hours components[0]
                  .minutes components[1]

      @innerValueChanged()

    setDateFromDatepickerDate: ->
      return unless @datepicker_date
      moment_datepicker_date = moment @datepicker_date

      return unless moment_datepicker_date and moment_datepicker_date.format('YYYYMMDD') != @inner_value.format('YYYYMMDD')

      @inner_value.date moment_datepicker_date.date()
                  .month moment_datepicker_date.month()
                  .year moment_datepicker_date.year()

      @innerValueChanged()

    ensureDefaultValue: ->
      @copyValue()
      @setDefaultInnerValue() unless @value

  computed:
    date_display: ->
      return @inner_value.format('MMM Do, YYYY') if @inner_value and @inner_value._isAMomentObject
      'unset'

  watch:
    value: ->
      @ensureDefaultValue()

    inner_value: ->
      @innerValueChanged()

    time_display: ->
      @setTimeFromTimeDisplay()

    datepicker_date: ->
      @setDateFromDatepickerDate()

  mounted: ->
    @ensureDefaultValue()

</script>
