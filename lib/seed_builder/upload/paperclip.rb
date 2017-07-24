module SeedBuilder
  module Upload
    class Paperclip

      def initialize model, key
        @entity = model
        @key = key
      end

      def value
        File.open("files/test.#{ext}") do |file|
          @entity.send(@key.to_s + "=", file)
        end
      end

      private

      # Valid ext name
      #
      # @return [String]
      def ext
        if content_type =~ /jpe?g/
          "jpg"
        elsif content_type =~ /png/
          "png"
        elsif content_type =~ /gif/
          "gif"
        elsif content_type =~ /pdf/
          "pdf"
        else
          "jpg"
        end
      end

      # Return regex string for content_type
      # ex. "(?-mix:\\Aimage\\/.*\\z)"
      #
      # @return [String]
      def content_type
        return @content_type unless @content_type.nil?
        @content_type ||= content_type_validator.nil? ? nil : content_type_validator[:content_type].to_s
      end

      # Return AttachmentContentTypeValidator object
      #
      # @return [Object]
      def content_type_validator
        content_type_validator = @entity._validators[@key].select do |validator|
          validator.is_a? Paperclip::Validators::AttachmentContentTypeValidator
        end
        content_type_validator.size.zero? ? nil : content_type_validator.first
      end

    end
  end
end