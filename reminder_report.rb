require './esa_constants'
require 'week_of_month'

module RemindTimeReport
  # 勉強会テンプレートのURL
  ESA_CLASS_TEMPLATE = "#{::Esa::Constants::TEMPLATE_BASE_URL}#{ENV['ESA_CLASS_TEMPLATE_ID']}".freeze

  class << self
    def message
      return if (print_make_day? && remind_time?).eql?(false)
      "@gouf 勉強会のネタ書いた？\nまだなら書きましょう！\n#{ESA_CLASS_TEMPLATE}"
    end

    # 今日は何曜日か
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

    # お題を書いたかリマインドする時刻を設定
    def remind_time?
      hour = Time.now.hour.eql?(12)
      min = (20..29).cover?(Time.now.min)
      hour && min # Time is between 12:20 and 12:29 ?
    end

    # お題を書く日を設定
    def print_make_day?
      # 奇数週の土曜日
      odd_week = Date.today.week_of_month.modulo(2).eql?(1)
      odd_week && week_day.eql?('土')
    end
  end
end
