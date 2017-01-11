require 'active_support'
require 'active_support/core_ext'

ENV['ESA_TEAM_NAME'] = 'test'
ENV['ESA_CLASS_TEMPLATE_ID'] = '1'
ENV['ESA_KWL_TEMPLATE_ID'] = '2'

describe TimeReporter do
  describe 'benkyo day or time' do
    let(:friday) { Time.local(2016, 6, 10) }
    let(:benkyo_day) { Time.local(2016, 6, 25, 15, 20) } # week of month % 2 == 0 && Saturday
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
  end

  describe 'remind print make day or time' do
    let(:sunday) { Time.local(2016, 6, 12) }
    let(:print_make_day) { Time.local(2016, 6, 4, 12, 20) }

    it 'not remind day' do
      Timecop.freeze(sunday)
      expect(TimeReporter.new.print_make_day?).to be_falsy
    end

    it 'remind day' do
      Timecop.freeze(print_make_day)
      expect(TimeReporter.new.print_make_day?).to be_truthy
    end

    it 'print make time' do
      Timecop.freeze(print_make_day)
      (0..9).each do |n|
        Timecop.travel(print_make_day + n.minutes)
        expect(TimeReporter.new.remind_time?).to be_truthy
      end
    end

    after { Timecop.return }
  end
end
