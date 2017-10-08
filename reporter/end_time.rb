require './esa_constants'

module Reporter
  module EndTime
    # 振り返りシートのURL
    ESA_KWL_TEMPLATE = "#{::Esa::Constants::TEMPLATE_BASE_URL}#{ENV['ESA_KWL_TEMPLATE_ID']}".freeze

    class << self
      # 勉強会終了時の通知メッセージを設定
      def message
        return if (benkyo_day? && end_time?).eql?(false)
        "@here そろそろ終了時間です。\nKWL の振り返りを書きましょう\n#{ESA_KWL_TEMPLATE}"
      end

      # 今日は何曜日か
      def week_day
        Reporter.week_day
      end

      # 勉強会開催中の日を設定
      def benkyo_day?
        # 偶数集の土曜日に設定
        even_week = Date.today.week_of_month.modulo(2).zero?
        even_week && week_day.eql?('土')
      end

      # 勉強会の終了時刻設定
      def end_time?
        hour = Time.now.hour.eql?(15)
        min = (20..29).cover?(Time.now.min)
        hour && min # Time is between 15:20 and 15:29 ?
      end
    end
  end
end
