after(:users) do
  user = User.find_by(email: 'phec06@gmail.com')

  [
    {
      id: 1,
      name: 'Life',
      text_color: 'b45f06',
      background_color: 'fce5cd',
      children: [
        {
          id: 11,
          name: 'Sleep'
        },
        {
          id: 12,
          name: 'Meal'
        }
      ]
    },

    {
      id: 2,
      name: 'Meal',
      text_color: '50aa29',
      background_color: 'ecffe5'
    },

    {
      id: 3,
      name: 'Work',
      text_color: 'bf9000',
      background_color: 'fff2cc'
    },

    {
      id: 4,
      name: 'Smoke',
      text_color: '444',
      background_color: 'eee'
    },

    {
      id: 5,
      name: 'F1',
      text_color: '50aa29',
      background_color: 'ecffe5'
    },

    {
      id: 6,
      name: 'Guitar',
      text_color: 'ff0000',
      background_color: 'f4cccc'
    },

    {
      id: 7,
      name: 'Cleanup',
      text_color: '50aa29',
      background_color: 'ecffe5'
    },



  ].each do |loggable_attributes|
    loggable = Loggable.where(id: loggable_attributes[:id]).first_or_initialize
    loggable.assign_attributes loggable_attributes
    loggable.user = user
    loggable.save
  end
end
