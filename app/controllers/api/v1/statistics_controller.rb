module Api
  module V1
    class StatisticsController < BaseController
      def index
        render json: statistics
      end

      # TODO: Move this to a better place
      def statistics
        [
          {
            title: 'Sleep',
            statistics: sleep_statistics
          },
          {
            title: 'Health',
            statistics: health_statistics
          },
          {
            title: 'Productivity',
            statistics: productivity_statistics
          },
          {
            title: 'Leisure',
            statistics: leisure_statistics
          }
        ]
      end

      def sleep_statistics
        sleep_logs = current_user.loggables.find(10).logs.where('finish > ?', 21.days.ago)

        wakeup_seconds = sleep_logs.map do |log|
          log.finish.in_time_zone(tz).seconds_since_midnight
        end

        bedtime_seconds = sleep_logs.map do |log|
          since = log.start.in_time_zone(tz).seconds_since_midnight
          to = 24*3600 - since

          since < to and since or - to
        end

        [
          {
            label: 'Bed Time',
            value: Time.at(bedtime_seconds.reduce(:+) / bedtime_seconds.size.to_f).utc.strftime("%H:%M"),
            target: '23:00'
          },
          {
            label: 'Wakeup Time',
            value: Time.at(wakeup_seconds.reduce(:+) / wakeup_seconds.size.to_f).utc.strftime("%H:%M"),
            target: '09:00'
          },
          {
            label: 'Sleep Amount',
            value: formatted_seconds(sleep_logs.map(&:duration).reduce(:+)/sleep_logs.count),
            target: '9h'
          },
        ]
      end

      def health_statistics
        last_smoke_log = Log.by_loggable_id(64).order('finish DESC').first
        last_f5_log = Log.by_loggable_id(63).order('finish DESC').first

        good_meals_count = Log.by_loggable_id(12).where('finish > ?', 21.days.ago).count
        bad_meals_count = Log.by_loggable_id(13).where('finish > ?', 21.days.ago).count
        total_meals_count = good_meals_count + bad_meals_count

        [
          {
            label: 'Days without cigars',
            value: ((Time.current - (last_smoke_log&.finish || 0)).to_i/(24*60*60)).to_i
          },
          {
            label: 'Days without F5',
            value: ((Time.current - (last_f5_log&.finish || 0)).to_i/(24*60*60)).to_i
          },
          {
            label: 'Meals',
            value: total_meals_count == 0 ? 'No data' : "#{good_meals_count*100.0/total_meals_count}% Good Meals"
          }
        ]
      end

      def productivity_statistics
        [
          [21, 'Tatchup hours/week', '30h'],
          [22, 'FedeauxOrg hours/week', '3h'],
          [5, 'Study hours/week', '5h'],
          [8, 'Training hours/week', '5h'],
        ].map do |params|
          logs = Loggable.find(params[0]).logs_with_descendents.where('finish > ?', 21.days.ago)

          {
            label: params[1],
            value: formatted_mean_duration_per_week(logs),
            target: params[2]
          }
        end
      end

      def leisure_statistics
        [
          [61, 'Lolzin hours/week', '5h'],
          [66, 'Youtube hours/week', '5h'],
          [67, 'People hours/week', '3h'],
        ].map do |params|
          logs = Loggable.find(params[0]).logs_with_descendents.where('finish > ?', 21.days.ago)

          {
            label: params[1],
            value: formatted_mean_duration_per_week(logs),
            target: params[2]
          }
        end
      end

      def formatted_mean_duration_per_week(logs, weeks = 3)
        formatted_seconds logs.map(&:duration).reject(&:nil?).reduce(0.0, :+) / weeks
      end

      def formatted_seconds(duration)
        return 'zero' unless duration

        hours = (duration / 3600).to_i
        minutes = ((duration - (hours * 3600)) / 60).to_i

        if hours > 0
          f_hours = "#{hours}h"
        else
          f_hours = ""
        end

        if minutes > 0
          if minutes < 10
            f_minutes = "0#{minutes}min"
          else
            f_minutes = "#{minutes}min"
          end
        else
          f_minutes = ""
        end

        f_hours+f_minutes
      end

      def tz
        ActiveSupport::TimeZone['Brasilia']
      end
    end
  end
end
