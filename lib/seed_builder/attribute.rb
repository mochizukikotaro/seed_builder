module SeedBuilder
  class Attribute

    attr_reader :key, :type, :validates, :entity

    def initialize key, active_model_type, entity, model_object
      @key          = key
      @entity       = entity
      @model_object = model_object
      @type         = active_model_type.type.to_s.capitalize
    end

    def build
      # TODO: ここに外部キーに関する処理分岐を入れる

      if carrier_wave?
        Upload::CarrierWave.new(@model_object, @key)
      elsif paperclip?
        @model_object[@key] = "paper clip data"
      else
        # NOTE: いったん、わかりやすさのため tmp var 使う
        data = ValidData.new(
                    type:         @type,
                    model_object: @model_object,
                    key:          @key).generate
        @model_object[@key] = data
      end
    end

    private

    def carrier_wave?
      @entity.new.send(@key).is_a? CarrierWave::Uploader::Base
    end

    def paperclip?
      false
    end

    def foreign_key?
      # ポリモーフィックの外部キーはこの時点でリレーション先のモデルを確定できないので、普通のフィールドとして扱う
      return false if polymorphic_foreign_key?
      return true if @entity.foreign_keys.find{|f| @key == f[:foreign_key] }
      return true if "left_side_id" == @key
      false
    end

    def foreign_klass
      return nil if polymorphic_foreign_key?

      if foreign = @entity.foreign_keys.find{|f| @key == f[:foreign_key] }
        return foreign[:klass]
      end

      # TODO: left_side_id の対応
    end

    def auto_generate?
      # TODO: Rails規約どおりの場合のみ想定しているのでカスタムに対応する
      "id" == @key
    end

    def sti_type?
      "type" == @key && @entity.superclass != ActiveRecord::Base
    end

    def polymorphic_foreign_key?
      @entity.polymorphic_columns.find{|c| @key == c[:foreign_key] } ? true : false
    end

    def unique_index?
      ActiveRecord::Base.connection.indexes(@entity.table_name).select{|i| i.columns.include?(@key) && i.unique}.size.zero? ? false : true
    end

    def unique?
      @entity.validators.select{|v| v.attributes.include?(@key.to_sym) && v.is_a?(ActiveRecord::Validations::UniquenessValidator) }.size.zero? ? false : true
    end
  end
end
