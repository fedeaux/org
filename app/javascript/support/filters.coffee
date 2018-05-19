export default
  ellipsis: (string, n) ->
    str_len = string.length

    return string if str_len < n+2
    string[0..n].trim()+'...'

  weekday_month_monthday: (moment_date) ->
    moment_date.format 'ddd, MMM Do'
