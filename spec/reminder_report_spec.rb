describe RemindTimeReport do
  let(:print_make_day) { Time.local(2016, 6, 4, 12, 20) }
  let(:sunday) { Time.local(2016, 6, 12) }

  describe 'remind print make day or time' do
    it 'not remind day' do
      Timecop.freeze(sunday)
      expect(RemindTimeReport.print_make_day?).to be_falsy
    end

    it 'remind day' do
      Timecop.freeze(print_make_day)
      expect(RemindTimeReport.print_make_day?).to be_truthy
    end

    it 'print make time' do
      Timecop.freeze(print_make_day)
      (0..9).each do |n|
        Timecop.travel(print_make_day + n.minutes)
        expect(RemindTimeReport.remind_time?).to be_truthy
      end
    end

    after { Timecop.return }
  end
end
