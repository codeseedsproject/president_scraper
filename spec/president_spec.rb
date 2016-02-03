require 'president'

RSpec.describe President do
  describe '#parse_rows' do
    it 'returns html rows for all presidents' do
      result = President.new.parsed_rows
      expect(result).to eq("")
    end

    it 'returns an individual row' do
      result = President.new.row
      expect(result).to eq("")
    end
  end
end