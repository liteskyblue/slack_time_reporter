require 'dotenv'
Dotenv.load
require 'date'
require 'week_of_month'
require 'slack-notifier'

class TimeReporter
  def slack_notifier
    Slack::Notifier.new(
      ENV['WEBHOOK_URL'],
      channel: 'benkyo',
      username: 'time-reporter',
      icon_url: ENV['BOT_ICON_URL']
    )
  end

  def send_message
    return if (benkyo_day? && end_time?).eql? false
    esa_team_name = ENV['ESA_TEAM_NAME']
    esa_template_id = ENV['ESA_TEMPLATE_ID']
    url = "https://#{esa_team_name}.esa.io/posts/new?template_post_id=#{esa_template_id}"
    message = "@here そろそろ終了時間です。\nKWL の振り返りを書きましょう\n#{url}"
    slack_notifier.ping(message)
  end

  def week_day
    {
      0 => '日',
      1 => '月',
      2 => '火',
      3 => '水',
      4 => '木',
      5 => '金',
      6 => '土'
    }[(Date.today.cweek - 1).modulo(7)]
  end

  def benkyo_day?
    week_of_month = Date.today.week_of_month.modulo(2).zero?
    week_of_month && week_day.eql?('土')
  end

  def end_time?
    hour = Time.now.hour.eql? 15
    min = (20...29).cover?(Time.now.min)
    hour && min
  end
end

TimeReporter.new.send_message
