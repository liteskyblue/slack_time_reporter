require 'slack'

Slack.configure do |config|
  config.token = ENV['SLACK_TOKEN']
end

esa_team_name = 'blue'
esa_template_id = 39
url = "https://#{esa_team_name}.esa.io/posts/new?template_post_id=#{esa_template_id}"
message = "KWL 振り返りを書きましょう\n#{url}"
Slack.chat_postMessage(text: message, channel: 'benkyo')
