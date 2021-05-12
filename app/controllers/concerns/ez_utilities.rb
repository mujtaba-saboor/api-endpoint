module EzUtilities
  extend ActiveSupport::Concern

  def to_bool(value)
    value.downcase! if value.is_a?(String)
    ActiveRecord::Type::Boolean.new.deserialize(value)
  end

  class_methods do
    def to_bool(value)
      new.to_bool(value)
    end
  end
end
