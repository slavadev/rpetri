RSpec.describe RPetri::Net::Runner do
  class TestNet
    include RPetri::Net::Builder
    include RPetri::Net::Runner
  end
end
