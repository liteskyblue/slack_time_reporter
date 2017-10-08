module Esa
  module Constants
    raise 'Please set ESA_TEAM_NAME as environment variable.' if ENV['ESA_TEAM_NAME'].to_s.empty?
    TEMPLATE_BASE_URL = "https://#{ENV['ESA_TEAM_NAME']}.esa.io/posts/new?template_post_id=".freeze
  end
end
