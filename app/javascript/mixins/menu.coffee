export default
  data: ->
    show_menu: false

  methods:
    showMenu: ->
      @show_menu = true

    hideMenu: ->
      @show_menu = false
