require 'bundler'
Bundler.require

# Not includes `--without development`
development_environment = !ENV['BUNDLE_WITHOUT'].to_s.include?('development')
if development_environment
  require 'dotenv'
  Dotenv.load
end

class TimeReporter
  ESA_TEMPLATE_URL_FOR = "https://#{ENV['ESA_TEAM_NAME']}.esa.io/posts/new?template_post_id=".freeze

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
    esa_template_id = ENV['ESA_TEMPLATE_ID']
    url = "#{ESA_TEMPLATE_URL_FOR}#{ENV['ESA_KWL_TEMPLATE_ID']}"
    message = "@here そろそろ終了時間です。\nKWL の振り返りを書きましょう\n#{url}"
    slack_notifier.ping(message)
  end

  def remind_making_print
    return if (print_make_day? && remind_time?).eql? false
    url = "#{ESA_TEMPLATE_URL_FOR}#{ENV['ESA_CLASS_TEMPLATE_ID']}"
    message = "@gouf 勉強会のネタ書いた？\nまだなら書きましょう！\n#{url}"
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
    }[Date.today.cwday.modulo(7)]
  end

  def benkyo_day?
    week_of_month = Date.today.week_of_month.modulo(2).zero?
    week_of_month && week_day.eql?('土')
  end

  def end_time?
    hour = Time.now.hour.eql? 15
    min = (20..29).cover?(Time.now.min)
    hour && min
  end

  def print_make_day?
    week_of_month = Date.today.week_of_month.modulo(2).eql?(1)
    week_of_month && week_day.eql?('土')
  end

  def remind_time?
    hour = Time.now.hour.eql? 12
    min = (20..29).cover?(Time.now.min)
    hour && min
  end
end