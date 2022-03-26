# this is an RSpec file that ought not to get picked up by the
# Minitest regex pattern
RSpec.describe Test do
  context 'when RSpec content is involved' do
    it 'should not involve Minitest' do
      1 + 1
    end
  end
end
