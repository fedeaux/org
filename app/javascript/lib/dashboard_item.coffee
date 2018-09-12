class DashboardItem
  constructor: (params) ->
    for params_name, value of @setDefaultParams params
      @[params_name] = value

  setDefaultParams: (params) ->
    _.defaults params, { active: true }

export default DashboardItem
