@TatApp ?= {}
TatApp.Support ?= {}

TatApp.Support.padString = (str, length, char) ->
  pad = new Array(1 + length).join char
  (pad + str).slice -pad.length

TatApp.Support.invertColor = (color_hex, bw) ->
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
  '#' + TatApp.Support.padString(r, 2, '0') + TatApp.Support.padString(g, 2, '0') + TatApp.Support.padString(b, 2, '0')
