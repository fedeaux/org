export default
  data: ->
    seeders: []
    seeded_tats: []
    found_suitable_seeders: false

  methods:
    findSuitableSeeders: ->
      # TODO: duct tape, refactor once https://github.com/tbartercom/tat.me_chrome-extension/issues/20 is closed
      @removeAllSeeders()

      for seeder in @adapter.instantiateContentSeeders @onNewContent
        @seeders.push seeder

    removeAllSeeders: ->
      seeder.remove() for seeder in @seeders
      @seeded_tats = []

    onNewContent: (tat) ->
      @seeded_tats.push tat
