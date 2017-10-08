require './end_time_report'
require './reminder_report'
require 'bundler'
Bundler.require

# Load dotenv when development environment
development_environment = !ENV['BUNDLE_WITHOUT'].to_s.include?('development')
if development_environment
  require 'dotenv'
  Dotenv.load
end

slack_notifier =
  Slack::Notifier.new(
    ENV['WEBHOOK_URL'],
    channel: 'benkyo',
    username: 'time-reporter',
    icon_url: ENV['BOT_ICON_URL']
  )

reporters = [
  RemindTimeReport,
  EndTimeReport
]

reporters.reject { |reporter| reporter.message.nil? }
         .each { |reporter| slack_notifier.ping(reporter.message) }
