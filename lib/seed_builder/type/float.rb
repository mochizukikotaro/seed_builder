module SeedBuilder
  module Type
    class Float < Base
      def generate
        max = 100
        min = 1
        rand * (max-min) + min
      end
    end
  end
end
