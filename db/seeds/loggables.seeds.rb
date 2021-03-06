after(:users) do
  def create_loggable(loggable_attributes, parent = nil)
    loggable = Loggable.where(id: loggable_attributes[:id]).first_or_initialize

    loggable_attributes[:text_color] = nil unless loggable_attributes[:text_color]
    loggable_attributes[:background_color] = nil unless loggable_attributes[:background_color]

    loggable.assign_attributes loggable_attributes.except(:children)
    loggable.parent = parent
    loggable.user = User.find_by(email: 'phec06@gmail.com')
    loggable.save

    return unless loggable_attributes[:children]

    loggable_attributes[:children].each do |child_attributes|
      create_loggable child_attributes, loggable
    end
  end

  [
    {
      id: 1,
      name: 'Life',
      text_color: '50aa29',
      background_color: 'ecffe5',
      children: [
        {
          id: 10,
          name: 'Sleep',
          text_color: '397cef',
          background_color: 'dbf9fa',
        },
        {
          id: 11,
          name: 'Wakeup'
        },
        {
          id: 12,
          name: 'Before Bed'
        },
        # {
        #   id: 11,
        #   name: 'Morning Ritual'
        # },
        # {
        #   id: 12,
        #   name: 'Good Meal'
        # },
        # {
        #   id: 13,
        #   name: 'Bad Meal'
        # },
        # {
        #   id: 19,
        #   name: 'Turn off Ritual'
        # },
      ]
    },

    {
      id: 2,
      name: 'Work',
      text_color: 'b45f06',
      background_color: 'fce5cd',
      children: [
        {
          id: 21,
          name: 'Tatchup'
        },
        {
          id: 22,
          name: 'FedeauxOrg'
        },
        {
          id: 23,
          name: 'Youtube'
        },
        {
          id: 24,
          name: 'NaRadio'
        },
        {
          id: 25,
          name: 'Freelas'
        },
      ]
    },

    {
      id: 6669,
      name: 'Arts',
      text_color: '999',
      background_color: 'fff',
      children: [
        {
          id: 3,
          name: 'Music',
          text_color: 'ff0000',
          background_color: 'f4cccc',
          children: [
            {
              id: 31,
              name: 'Technique & Repertoire',
              children: [
                {
                  id: 311,
                  name: 'Electric Guitar',
                },
                {
                  id: 312,
                  name: 'Acoustic Guitar',
                },
                {
                  id: 313,
                  name: 'Piano',
                },
                {
                  id: 314,
                  name: 'Sing',
                },
                {
                  id: 315,
                  name: 'Violin',
                },
              ]
            },
            {
              id: 32,
              name: 'Musicality'
            },
          ]
        },

        {
          id: 9,
          name: 'Drawing',
          text_color: 'ccc',
          background_color: 'fff',
        }
      ]
    },

    {
      id: 4,
      name: 'Chores',
      text_color: 'bf9000',
      background_color: 'fff2cc',
      children: [
        {
          id: 41,
          name: 'Cleanup',
          children: [
            {
              id: 411,
              name: 'Kitchen'
            },
            {
              id: 412,
              name: 'Bathroom'
            },
            {
              id: 413,
              name: 'Livingym'
            },
            {
              id: 414,
              name: 'Studioffice'
            },
            {
              id: 415,
              name: 'Bedroom'
            },
            {
              id: 416,
              name: 'Whole House'
            },
          ]
        },
        {
          id: 42,
          name: 'Market',
        },
        {
          id: 43,
          name: 'Dogs',
        },
        {
          id: 44,
          name: 'Other',
        }
      ]
    },

    {
      id: 5,
      name: 'Study',
      text_color: '1155cc',
      background_color: 'c9daf8',
      children: [
        {
          id: 51,
          name: 'Computer Science',
        },
        {
          id: 52,
          name: 'Development',
        },
        {
          id: 53,
          name: 'Humanities',
        }
      ]
    },

    {
      id: 6,
      name: 'Leisure',
      text_color: 'ff00ff',
      background_color: 'ead1dc',
      children: [
        {
          id: 61,
          name: 'Lolzin',
          text_color: '10b0b5',
          background_color: '142a32'
        },

        {
          id: 62,
          name: 'F1',
          text_color: '2e4618',
          background_color: 'b7d17d'
        },

        {
          id: 63,
          name: 'F5',
          text_color: 'f00',
          background_color: 'b7d17d'
        },

        {
          id: 64,
          name: 'Smoke',
          text_color: '555',
          background_color: 'ccc'
        },

        {
          id: 65,
          name: 'Social Media',
          text_color: 'fff',
          background_color: '3B5998'
        },

        {
          id: 66,
          name: 'Youtube',
          text_color: 'fff',
          background_color: 'ff0000'
        },

        {
          id: 67,
          name: 'People',
          text_color: 'ead1dc',
          background_color: 'ff00ff'
        }
      ]
    },

    {
      id: 7,
      name: 'Mind',
      text_color: '33f',
      background_color: 'eee',

      children: [
        {
          id: 71,
          name: 'Therapy',
        },
        {
          id: 72,
          name: 'Meditation',
        }
      ]
    },

    {
      id: 8,
      name: 'Training',
      text_color: '3a7b1e',
      background_color: 'b4ff99',
      children: [
        {
          id: 81,
          name: 'Jiu Jitsu',
          children: [
            {
              id: 811,
              name: 'Jiu Jitsu Alliance',
            },
            {
              id: 819,
              name: 'Jiu Jitsu Allan',
            },
          ]
        },
        {
          id: 82,
          name: 'Bodybuilding'
        },
        {
          id: 83,
          name: 'Home Training'
        },
      ]
    },
  ].each do |loggable_attributes|
    create_loggable loggable_attributes
  end
end
