import SeededTextTatFactory from '../factories/seeded_text_tat'

class BaseSeeder
  @isSuitableForCurrentPage: ->
    # Abstract class, use one of its children instead
    false

  constructor: (@onNewContent, @adapter) ->
    @comments = {}
    @initialize()

  addCommentUnlessExists: (text, time) ->
    return if @comments[text]

    # TODO: Dependency Injection
    tat = SeededTextTatFactory.buildTextTat [text], @adapter.targetAttributes(parseInt(time)), form_tat: false
    return unless tat

    @comments[text] = tat
    @onNewContent tat if @onNewContent

export default BaseSeeder
