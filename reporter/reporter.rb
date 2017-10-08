require 'week_of_month'

module Reporter
  class << self
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
  end
end
