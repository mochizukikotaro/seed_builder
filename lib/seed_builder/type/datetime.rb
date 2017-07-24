module SeedBuilder
  module Type
    class Datetime < Base

      def initialize
      end

      def generate
        ::Time.now
      end
    end
  end
end
