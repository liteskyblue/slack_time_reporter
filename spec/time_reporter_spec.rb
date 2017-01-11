require 'active_support'
require 'active_support/core_ext'

ENV['ESA_TEAM_NAME'] = 'test'
ENV['ESA_CLASS_TEMPLATE_ID'] = '1'
ENV['ESA_KWL_TEMPLATE_ID'] = '2'

describe TimeReporter do
  let(:friday) { Time.local(2016, 6, 10) }
  let(:print_make_day) { Time.local(2016, 6, 4, 12, 20) }
  let(:benkyo_day) { Time.local(2016, 6, 25, 15, 20) } # week of month % 2 == 0 && Saturday
  let(:sunday) { Time.local(2016, 6, 12) }

  describe 'benkyo day or time' do
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

  describe 'notify message' do
    let(:slack_notifier_mock) { double('Slack::Notifier') }

    let(:class_message) do
      url = TimeReporter::ESA_CLASS_TEMPLATE
      "@gouf 勉強会のネタ書いた？\nまだなら書きましょう！\n#{url}"
    end

    let(:kwl_message) do
      url = TimeReporter::ESA_KWL_TEMPLATE
      "@here そろそろ終了時間です。\nKWL の振り返りを書きましょう\n#{url}"
    end

    let!(:time_reporter) { TimeReporter.new }

    before do
      allow(time_reporter).to receive(:slack_notifier).and_return(slack_notifier_mock)
    end

    subject { time_reporter }

    it 'sent with KWL template url' do
      Timecop.freeze(benkyo_day)
      allow(slack_notifier_mock).to receive(:ping).with(kwl_message)

      expect(subject.send_message).to match(kwl_message)
    end

    it 'sent with class template url' do
      Timecop.freeze(print_make_day)
      allow(slack_notifier_mock).to receive(:ping).with(class_message)

      expect(subject.remind_making_print).to match(class_message)
    end

    after { Timecop.return }
  end
end
