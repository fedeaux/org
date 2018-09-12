class DashboardItem
  constructor: (params) ->
    for params_name, value of @setDefaultParams params
      @[params_name] = value

  setDefaultParams: (params) ->
    _.defaults params, { active: true, hide_on_menu: false }

  title: ->
    return @props.title if @props.title
    # return formatted date if @props.date
    if @props.log_form
      return 'New log' if @props.log_form.isNewRecord()
      'Editing log'
    # return based on form item state if @props.log_form

export default DashboardItem
