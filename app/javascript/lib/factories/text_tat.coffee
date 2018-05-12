import Helpers from '../../support/helpers'
import Tat from '../../models/tat'

TextTat =
  buildRandomTextProperties: ->
    color = ''
    while color.length != 7
      color = "#"+((1<<24)*Math.random()|0).toString(16)

    bg_color = Helpers.invertColor color

    {
      normalized:
        top: Math.random()/2 # from 0 to 50% of video height
        left: Math.random()/2 # from 0 to 50% of video width
        # 'font-size': Math.random()/20 + 0.02 # from 2 to 8% of video height
        'font-size': 0.08

      css:
        'background-color': bg_color
        color: color
    }

  buildRandomTextTat: (texts, target_attributes, options = {}) ->
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
        properties: TextTat.buildRandomTextProperties()

    new Tat tat_attributes

export default TextTat
