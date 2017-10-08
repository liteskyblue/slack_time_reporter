require './reporter/reporter'
require './reporter/end_time'
require './reporter/reminder'
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
  Reporter::RemindTime,
  Reporter::EndTime
]

reporters.reject { |reporter| reporter.message.nil? }
         .each { |reporter| slack_notifier.ping(reporter.message) }
