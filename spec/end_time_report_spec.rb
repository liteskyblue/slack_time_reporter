include Reporter

describe Reporter::EndTime do

  let(:friday) { Time.local(2016, 6, 10) }
  let(:benkyo_day) { Time.local(2016, 6, 25, 15, 20) } # week of month % 2 == 0 && Saturday
  let(:sunday) { Time.local(2016, 6, 12) }

  describe 'benkyo day or time' do
    context 'not benkyo day' do
      it 'is friday' do
        Timecop.freeze(friday)
        expect(EndTime.message).to be_falsy
      end

      it 'is sunday' do
        Timecop.travel(sunday)
        expect(EndTime.message).to be_falsy
      end
    end

    context 'benkyo day' do
      before { Timecop.freeze(benkyo_day) }

      it 'is odd week' do
        expect(Date.today.week_of_month.modulo(2)).to eq 0
      end

      it 'is saturday' do
        expect(EndTime.week_day).to eq('土')
      end

      it 'is odd week and saturday' do
        expect(EndTime.benkyo_day?).to be_truthy
      end
    end

    it 'benkyo end time' do
      Timecop.freeze(benkyo_day)
      (0..9).each do |n|
        Timecop.travel(benkyo_day + n.minutes)
        expect(EndTime.end_time?).to be_truthy
      end
    end
  end
end
