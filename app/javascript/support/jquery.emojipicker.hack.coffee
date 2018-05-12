# Based on jquery-emoji-picker/js/jquery.emojipicker.js, adapted to work with vuejs

(($) ->
  pluginName = 'emojiPicker'
  defaults =
    width: '200'
    height: '350'
    position: 'right'
    fadeTime: 100
    iconColor: 'black'
    iconBackgroundColor: '#eee'
    recentCount: 36
    emojiSet: 'apple'
    container: 'body'
    button: true

  MIN_WIDTH = 280
  MAX_WIDTH = 600
  MIN_HEIGHT = 100
  MAX_HEIGHT = 350
  MAX_ICON_HEIGHT = 50

  categories = [
    {
      name: 'people'
      label: 'People'
    }
    {
      name: 'nature'
      label: 'Nature'
    }
    {
      name: 'food'
      label: 'Food'
    }
    {
      name: 'activity'
      label: 'Activities'
    }
    {
      name: 'travel'
      label: 'Travel & Places'
    }
    {
      name: 'object'
      label: 'Objects'
    }
    {
      name: 'symbol'
      label: 'Symbols'
    }
    {
      name: 'flag'
      label: 'Flags'
    }
  ]

  EmojiPicker = (element, options) ->
    @element = element
    @$el = $(element)
    @settings = $.extend({}, defaults, options)
    @$container = $(@settings.container)

    # (type) Safety first
    @settings.width = parseInt(@settings.width)
    @settings.height = parseInt(@settings.height)

    # Check for valid width/height
    if @settings.width >= MAX_WIDTH
      @settings.width = MAX_WIDTH

    else if @settings.width < MIN_WIDTH
      @settings.width = MIN_WIDTH

    if @settings.height >= MAX_HEIGHT
      @settings.height = MAX_HEIGHT

    else if @settings.height < MIN_HEIGHT
      @settings.height = MIN_HEIGHT

    possiblePositions = [
      'left'
      'right'
    ]

    if $.inArray(@settings.position, possiblePositions) == -1
      @settings.position = defaults.position
      # current default

    # Do not enable if on mobile device (emojis already present)
    if !/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
      @init()
    else
      @isMobile = true

  ### ---------------------------------------------------------------------- ###

  getPickerHTML = ->
    `var i`
    `var i`
    nodes = []
    aliases = 'undefined': 'object'
    items = {}
    localStorageSupport = if typeof Storage != 'undefined' then true else false
    # Re-Sort Emoji table

    $.each $.fn.emojiPicker.emojis, (i, emoji) ->
      category = aliases[emoji.category] or emoji.category
      items[category] = items[category] or []
      items[category].push emoji
      return

    nodes.push '<div class="emojiPicker">'
    nodes.push '<nav>'

    # Recent Tab, if localstorage support
    if localStorageSupport
      nodes.push '<div class="tab active" data-tab="recent"><div class="emoji emoji-tab-recent"></div></div>'

    # Emoji category tabs
    categories_length = categories.length
    i = 0

    while i < categories_length
      nodes.push '<div class="tab' + (if !localStorageSupport and i == 0 then ' active' else '') + '" data-tab="' + categories[i].name + '"><div class="emoji emoji-tab-' + categories[i].name + '"></div></div>'
      i++

    nodes.push '</nav>'
    nodes.push '<div class="sections">'
    # Search
    nodes.push '<section class="search">'
    nodes.push '<input type="search" placeholder="Search...">'
    nodes.push '<div class="wrap" style="display:none;"><h1>Search Results</h1></div>'
    nodes.push '</section>'

    # Recent Section, if localstorage support
    if localStorageSupport
      recentlyUsedEmojis = []
      recentlyUsedCount = 0
      displayRecentlyUsed = ' style="display:none;"'

      if localStorage.emojis
        recentlyUsedEmojis = JSON.parse(localStorage.emojis)
        recentlyUsedCount = recentlyUsedEmojis.length
        displayRecentlyUsed = ' style="display:block;"'

      nodes.push '<section class="recent" data-count="' + recentlyUsedEmojis.length + '"' + displayRecentlyUsed + '>'
      nodes.push '<h1>Recently Used</h1><div class="wrap">'
      i = recentlyUsedEmojis.length - 1

      while i > -1
        nodes.push '<em><span class="emoji emoji-' + recentlyUsedEmojis[i] + '"></span></em>'
        i--

      nodes.push '</div></section>'
    # Emoji sections
    i = 0

    while i < categories_length
      category_length = items[categories[i].name].length
      nodes.push '<section class="' + categories[i].name + '" data-count="' + category_length + '">'
      nodes.push '<h1>' + categories[i].label + '</h1><div class="wrap">'
      j = 0

      while j < category_length
        emoji = items[categories[i].name][j]
        nodes.push '<em><span class="emoji emoji-' + emoji.shortcode + '"></span></em>'
        j++

      nodes.push '</div></section>'
      i++

    nodes.push '</div>'
    # Shortcode section
    nodes.push '<div class="shortcode"><span class="random">'
    # ADDED: Remove EmojiOfDay
    # nodes.push '<em class="tabTitle">' + generateEmojiOfDay() + '</em>'
    nodes.push '</span><span class="info"></span></div>'
    nodes.push '</div>'
    nodes.join '\n'

  generateEmojiOfDay = ->
    return '' # ADDED: Remove EmojiOfDay
    emojis = $.fn.emojiPicker.emojis
    i = Math.floor(Math.random() * (364 - 0) + 0)
    emoji = emojis[i]
    'Daily Emoji: <span class="eod"><span class="emoji emoji-' + emoji.name + '"></span> <span class="emojiName">' + emoji.name + '</span></span>'

  findEmoji = (emojiShortcode) ->
    emojis = $.fn.emojiPicker.emojis
    i = 0

    while i < emojis.length
      if emojis[i].shortcode == emojiShortcode
        return emojis[i]
      i++

  insertAtCaret = (inputField, myValue) ->
    if document.selection
      #For browsers like Internet Explorer
      inputField.focus()
      sel = document.selection.createRange()
      sel.text = myValue
      inputField.focus()

    else if inputField.selectionStart or inputField.selectionStart == '0'
      #For browsers like Firefox and Webkit based
      startPos = inputField.selectionStart
      endPos = inputField.selectionEnd
      scrollTop = inputField.scrollTop
      inputField.value = inputField.value.substring(0, startPos) + myValue + inputField.value.substring(endPos, inputField.value.length)
      inputField.focus()
      inputField.selectionStart = startPos + myValue.length
      inputField.selectionEnd = startPos + myValue.length
      inputField.scrollTop = scrollTop

    else
      inputField.focus()
      inputField.value += myValue

  toUnicode = (code) ->
    codes = code.split('-').map((value, index) ->
      parseInt value, 16
    )
    String.fromCodePoint.apply null, codes

  addToLocalStorage = (emoji) ->
    recentlyUsedEmojis = []

    if localStorage.emojis
      recentlyUsedEmojis = JSON.parse(localStorage.emojis)

    # If already in recently used, move to front
    index = recentlyUsedEmojis.indexOf(emoji)

    if index > -1
      recentlyUsedEmojis.splice index, 1

    recentlyUsedEmojis.push emoji

    if recentlyUsedEmojis.length > defaults.recentCount
      recentlyUsedEmojis.shift()

    localStorage.emojis = JSON.stringify(recentlyUsedEmojis)

  updateRecentlyUsed = (emoji) ->
    recentlyUsedEmojis = JSON.parse(localStorage.emojis)
    emojis = []
    recent = $('section.recent')
    i = recentlyUsedEmojis.length - 1

    while i >= 0
      emojis.push '<em><span class="emoji emoji-' + recentlyUsedEmojis[i] + '"></span></em>'
      i--

    # Fix height as emojis are added
    prevHeight = recent.outerHeight()
    $('section.recent .wrap').html emojis.join('')
    currentScrollTop = $('.sections').scrollTop()
    newHeight = recent.outerHeight()
    newScrollToHeight = 0

    if !$('section.recent').is(':visible')
      recent.show()
      newScrollToHeight = newHeight

    else if prevHeight != newHeight
      newScrollToHeight = newHeight - prevHeight

    $('.sections').animate { scrollTop: currentScrollTop + newScrollToHeight }, 0

  $.extend EmojiPicker.prototype,
    init: ->
      @active = false
      @addPickerIcon()
      @createPicker()
      @listen()

    addPickerIcon: ->
      # The wrapper is not needed if they have chosen to not use a button
      if @settings.button
        elementHeight = @$el.outerHeight()
        iconHeight = if elementHeight > MAX_ICON_HEIGHT then MAX_ICON_HEIGHT else elementHeight
        # This can cause issues if the element is not visible when it is initiated
        objectWidth = @$el.width()
        @$el.width objectWidth
        @$wrapper = @$el.wrap('<div class=\'emojiPickerIconWrap\'></div>').parent()
        @$icon = $('<div class="emojiPickerIcon"></div>').height(iconHeight).width(iconHeight).addClass(@settings.iconColor).css('backgroundColor', @settings.iconBackgroundColor)
        @$wrapper.append @$icon

    createPicker: ->
      # Show template
      @$picker = $(getPickerHTML()).appendTo(@$container).width(@settings.width).height(@settings.height).css('z-index', 10000)
      # Picker height
      @$picker.find('.sections').height parseInt(@settings.height) - 40
      # 40 is height of the tabs
      # Tab size based on width

      if @settings.width < 240
        @$picker.find('.emoji').css
          'width': '1em'
          'height': '1em'

    destroyPicker: ->
      return this if @isMobile

      @$picker.unbind 'mouseover'
      @$picker.unbind 'mouseout'
      @$picker.unbind 'click'
      @$picker.remove()
      $.removeData @$el.get(0), 'emojiPicker'
      this

    listen: ->
      # ADDED: Show emoji selector on focus
      @$el.on 'focus', =>
        @show()

      # If the button is being used, wrapper has not been set,
      #    and will not need a listener
      if @settings.button
        # Clicking on the picker icon
        @$wrapper.find('.emojiPickerIcon').click $.proxy(@iconClicked, this)

      $(document.body).click $.proxy(@clickOutside, this)
      # Resize events forces a reposition, which may or may not actually be required
      $(window).resize $.proxy(@updatePosition, this)

      # Click event for emoji
      @$picker.on 'click', 'em', $.proxy(@emojiClicked, this)

      # Hover event for emoji
      @$picker.on 'mouseover', 'em', $.proxy(@emojiMouseover, this)
      @$picker.on 'mouseout', 'em', $.proxy(@emojiMouseout, this)

      # Click event for active tab
      @$picker.find('nav .tab').click($.proxy(@emojiCategoryClicked, this)).mouseover($.proxy(@emojiTabMouseover, this)).mouseout $.proxy(@emojiMouseout, this)

      # Scroll event for active tab
      @$picker.find('.sections').scroll $.proxy(@emojiScroll, this)
      @$picker.click $.proxy(@pickerClicked, this)

      # Key events for search
      @$picker.find('section.search input').on 'keyup search', $.proxy(@searchCharEntered, this)

      # Shortcode hover
      @$picker.find('.shortcode').mouseover (e) ->
        e.stopPropagation()

    updatePosition: ->
      ###  Process:
          1. Find the nearest positioned element by crawling up the ancestors, record it's offset
          2. Find the bottom left or right of the input element, record this (Account for position setting of left or right)
          3. Find the difference between the two, as this will become our new position
          4. Magic.

          N.B. The removed code had a reference to top/bottom positioning, but I don't see the use case for this..
      ###

      # Step 1
      # Luckily jquery already does this...
      positionedParent = @$picker.offsetParent()
      parentOffset = positionedParent.offset()
      # now have a top/left object
      # Step 2
      elOffset = @$el.offset()

      if @settings.position == 'right'
        elOffset.left += @$el.outerWidth() - (@settings.width)

      elOffset.top += @$el.outerHeight()
      # Step 3
      #
      diffOffset =
        top: elOffset.top - (parentOffset.top)
        left: elOffset.left - (parentOffset.top)

      @$picker.css
        top: diffOffset.top
        left: diffOffset.left

      this

    hide: ->
      @$picker.hide @settings.fadeTime, 'linear', (->
        @active = false

        if @settings.onHide
          @settings.onHide @$picker, @settings, @active
      ).bind(this)

    show: ->
      # @$el.focus()
      @updatePosition()
      @$picker.show @settings.fadeTime, 'linear', (->
        @active = true

        if @settings.onShow
          @settings.onShow @$picker, @settings, @active

      ).bind(this)

    iconClicked: ->
      if @$picker.is(':hidden')
        @show()
        if @$picker.find('.search input').length > 0
          @$picker.find('.search input').focus()
      else
        @hide()

    emojiClicked: (e) ->
      clickTarget = $(e.target)
      emojiSpan = undefined

      if clickTarget.is('em')
        emojiSpan = clickTarget.find('span')
      else
        emojiSpan = clickTarget.parent().find('.emoji')

      emojiShortcode = emojiSpan.attr('class').split('emoji-')[1]
      emojiUnicode = toUnicode(findEmoji(emojiShortcode).unicode[defaults.emojiSet])
      insertAtCaret @element, emojiUnicode
      addToLocalStorage emojiShortcode
      updateRecentlyUsed emojiShortcode
      # For anyone who is relying on the keyup event
      $(@element).trigger 'keyup'
      # trigger change event on input
      event = document.createEvent('HTMLEvents')
      event.initEvent 'input', true, true
      @element.dispatchEvent event

    emojiMouseover: (e) ->
      emojiShortcode = $(e.target).parent().find('.emoji').attr('class').split('emoji-')[1]
      $shortcode = $(e.target).parents('.emojiPicker').find('.shortcode')
      $shortcode.find('.random').hide()
      $shortcode.find('.info').show().html '<div class="emoji emoji-' + emojiShortcode + '"></div><em>' + emojiShortcode + '</em>'

    emojiMouseout: (e) ->
      $(e.target).parents('.emojiPicker').find('.shortcode .info').empty().hide()
      $(e.target).parents('.emojiPicker').find('.shortcode .random').show()

    emojiCategoryClicked: (e) ->
      section = ''
      # Update tab
      @$picker.find('nav .tab').removeClass 'active'
      if $(e.target).parent().hasClass('tab')
        section = $(e.target).parent().attr('data-tab')
        $(e.target).parent('.tab').addClass 'active'
      else
        section = $(e.target).attr('data-tab')
        $(e.target).addClass 'active'
      $section = @$picker.find('section.' + section)
      heightOfSectionsHidden = $section.parent().scrollTop()
      heightOfSectionToPageTop = $section.offset().top
      heightOfSectionsToPageTop = $section.parent().offset().top
      scrollDistance = heightOfSectionsHidden + heightOfSectionToPageTop - heightOfSectionsToPageTop
      $('.sections').off 'scroll'
      # Disable scroll event until animation finishes
      that = this
      $('.sections').animate { scrollTop: scrollDistance }, 250, ->
        that.$picker.find('.sections').on 'scroll', $.proxy(that.emojiScroll, that)
        # Enable scroll event

    emojiTabMouseover: (e) ->
      section = ''
      if $(e.target).parent().hasClass('tab')
        section = $(e.target).parent().attr('data-tab')
      else
        section = $(e.target).attr('data-tab')

      categoryTitle = ''
      i = 0

      while i < categories.length
        if categories[i].name == section
          categoryTitle = categories[i].label
        i++

      if categoryTitle == ''
        categoryTitle = 'Recently Used'

      categoryCount = $('section.' + section).attr('data-count')
      categoryHtml = '<em class="tabTitle">' + categoryTitle + ' <span class="count">(' + categoryCount + ' emojis)</span></em>'
      $shortcode = $(e.target).parents('.emojiPicker').find('.shortcode')
      $shortcode.find('.random').hide()
      $shortcode.find('.info').show().html categoryHtml

    emojiScroll: (e) ->
      sections = $('section')
      $.each sections, (key, value) ->
        section = sections[key]
        offsetFromTop = $(section).position().top

        if section.className == 'search' or section.className == 'people' and offsetFromTop > 0
          $(section).parents('.emojiPicker').find('nav tab.recent').addClass 'active'
          return

        if offsetFromTop <= 0
          $(section).parents('.emojiPicker').find('nav .tab').removeClass 'active'
          $(section).parents('.emojiPicker').find('nav .tab[data-tab=' + section.className + ']').addClass 'active'

    pickerClicked: (e) ->
      e.stopPropagation()

    clickOutside: (e) ->
      # ADDED: Check if clicked element should hide the emoji picker
      t = $ e.target
      return if t.is(@$el)
      @hide() if @active

    searchCharEntered: (e) ->
      searchTerm = $(e.target).val()
      searchEmojis = $(e.target).parents('.sections').find('section.search')
      searchEmojiWrap = searchEmojis.find('.wrap')
      sections = $(e.target).parents('.sections').find('section')

      # Clear if X is clicked within input
      if searchTerm == ''
        sections.show()
        searchEmojiWrap.hide()

      if searchTerm.length > 0
        sections.hide()
        searchEmojis.show()
        searchEmojiWrap.show()
        results = []
        searchEmojiWrap.find('em').remove()
        $.each $.fn.emojiPicker.emojis, (i, emoji) ->
          shortcode = emoji.shortcode
          if shortcode.indexOf(searchTerm) > -1
            results.push '<em><div class="emoji emoji-' + shortcode + '"></div></em>'
          return
        searchEmojiWrap.append results.join('')

      else
        sections.show()
        searchEmojiWrap.hide()

  $.fn[pluginName] = (options) ->
    # Calling a function
    if typeof options == 'string'
      @each ->
        plugin = $.data(this, pluginName)
        switch options
          when 'toggle'
            plugin.iconClicked()
          when 'destroy'
            plugin.destroyPicker()

      return this

    @each ->
      # Don't attach to the same element twice
      if !$.data(this, pluginName)
        $.data this, pluginName, new EmojiPicker(this, options)

    this

  if !String.fromCodePoint
    # ES6 Unicode Shims 0.1 , © 2012 Steven Levithan http://slevithan.com/ , MIT License

    String.fromCodePoint = ->
      chars = []
      point = undefined
      offset = undefined
      units = undefined
      i = undefined
      i = 0

      while i < arguments.length
        point = arguments[i]
        offset = point - 0x10000
        units = if point > 0xFFFF then [
          0xD800 + (offset >> 10)
          0xDC00 + (offset & 0x3FF)
        ] else [ point ]
        chars.push String.fromCharCode.apply(null, units)
        ++i
      chars.join ''
) jQuery
