import Helpers from '../../support/helpers'
import Tat from '../../models/tat'

SeededTextTat =
  buildTextProperties: ->
    {
      normalized:
        top: 0.8 # from 0 to 50% of video height
        left: 0.2
        # 'font-size': Math.random()/20 + 0.02 # from 2 to 8% of video height
        'font-size': 0.08

      css:
        'background-color': '#fcdc00'
        color: '#FFF'
    }

  filterTextTimestamp: (text) ->
    text = text.trim().replace(/^\d?\d:\d\d/, '').trim()
    return false unless text.length > 1
    text

  buildTextTat: (texts, target_attributes, options = {}) ->
    texts = (text for text in (@filterTextTimestamp(text) for text in texts) when text)
    return false if texts.length == 0

    options = _.extend { form_tat: true }, options

    tat_attributes = {
                       target: target_attributes
                       contents: []
                       form_tat: !!options.form_tat
                     }

    for text in texts
      tat_attributes.contents.push
        content: text
        content_type: 'text'
        properties: SeededTextTat.buildTextProperties()

    new Tat tat_attributes

export default SeededTextTat
