require 'active_support'
require 'active_support/core_ext'

describe TimeReporter do
  describe 'benkyo day or time' do
    let(:friday) { Time.local(2016, 6, 10) }
    let(:benkyo_day) { Time.local(2016, 6, 25, 15, 20) } # week of month % 2 == 0 && Suturday
    let(:sunday) { Time.local(2016, 6, 12) }

    it 'not benkyo day' do
      Timecop.freeze(friday)
      expect(TimeReporter.new.benkyo_day?).to be_falsy

      Timecop.travel(sunday)
      expect(TimeReporter.new.benkyo_day?).to be_falsy
    end

    it 'benkyo day' do
      Timecop.freeze(benkyo_day)

      expect(Date.today.week_of_month.modulo(2)).to eq 0
      expect(TimeReporter.new.week_day).to eq('土')
      expect(TimeReporter.new.benkyo_day?).to be_truthy
    end

    it 'benkyo end time' do
      Timecop.freeze(benkyo_day)
      (0..9).each do |n|
        Timecop.travel(benkyo_day + n.minutes)
        expect(TimeReporter.new.end_time?).to be_truthy
      end
    end

    after { Timecop.return }
  end
end
