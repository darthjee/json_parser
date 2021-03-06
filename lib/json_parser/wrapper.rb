class JsonParser::Wrapper
  include JsonParser::TypeCast

  attr_reader :clazz, :type

  def initialize(clazz: nil, type: nil)
    @clazz = clazz
    @type = type
  end

  def wrap(value)
    return wrap_array(value) if value.is_a?(Array)
    wrap_element(value)
  end

  private

  def wrap_element(value)
    value = cast(value) if has_type? && !value.nil?
    return if value.nil?

    clazz ? clazz.new(value) : value
  end

  def wrap_array(array)
    array.map { |v| wrap v }
  end

  def has_type?
    type.present? && type != :none
  end

  def cast(value)
    public_send("to_#{type}", value)
  end
end
