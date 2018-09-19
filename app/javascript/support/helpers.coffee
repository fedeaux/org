Helpers =
  padString: (str, length, char) ->
    pad = new Array(1 + length).join char
    (pad + str).slice -pad.length

  invertColor: (color_hex, bw) ->
    color_hex = color_hex.slice(1) if color_hex.indexOf('#') == 0

    # convert 3-digit hex to 6-digits.
    if color_hex.length == 3
      hex = hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2]

    if color_hex.length != 6
      throw new Error('Invalid HEX color.')

    r = parseInt color_hex.slice(0, 2), 16
    g = parseInt color_hex.slice(2, 4), 16
    b = parseInt color_hex.slice(4, 6), 16

    if bw
      # http://stackoverflow.com/a/3943023/112731
      return if r * 0.299 + g * 0.587 + b * 0.114 > 186 then '#000000' else '#FFFFFF'

    # invert color components
    r = (255 - r).toString(16)
    g = (255 - g).toString(16)
    b = (255 - b).toString(16)

    # pad each with zeros and return
    '#' + Helpers.padString(r, 2, '0') + Helpers.padString(g, 2, '0') + Helpers.padString(b, 2, '0')

  formatTimespanAsDuration: (start, finish) ->
    return 0 unless start and finish
    duration = moment.duration finish.diff start
    Helpers.formatDuration duration.asSeconds()

  formatDuration: (duration) ->
    hours = Math.floor(duration / 3600)
    minutes = Math.floor((duration - (hours * 3600)) / 60)
    seconds = Math.floor duration - (hours * 3600) - (minutes * 60)

    if hours > 0
      f_hours = "#{hours}h"
    else
      f_hours = ""

    if minutes > 0
      if minutes < 10
        f_minutes = "0#{minutes}min"
      else
        f_minutes = "#{minutes}min"
    else
      f_minutes = ""

    if seconds > 0
      if seconds < 10
        f_seconds = "0#{seconds}s"
      else
        f_seconds = "#{seconds}s"

    else
      f_seconds = ""

    f_hours+f_minutes+f_seconds

  find: (collection, id) ->
    for index, item of collection
      return { index, item } if item.id == id

    {
      index: -1
      item: null
    }

export default Helpers
