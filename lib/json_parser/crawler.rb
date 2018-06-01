class JsonParser::Crawler
  attr_reader :post_process, :path, :case_type, :compact, :default

  def initialize(path, case_type: :lower_camel, compact: false, default: nil, &block)
    @case_type = case_type
    @compact = compact
    @default = default
    @path = path.map { |p| change_case(p) }
    @post_process = block
  end

  def value(json, index = 0)
    crawl(json, index)
  rescue NoMethodError, KeyError
    wrap(default)
  end

  private

  def crawl(json, index = 0)
    return wrap(json) if is_ended?(index)
    return crawl_array(json, index) if json.is_a?(Array)

    crawl(fetch(json, index), index + 1)
  end

  def fetch(json, index)
    key = path[index]
    json.key?(key) ? json.fetch(key) : json.fetch(key.to_sym)
  end

  def is_ended?(index)
    index >= path.size
  end

  def wrap(json)
    post_process.call(json)
  end

  def change_case(key)
    case case_type
    when :lower_camel
      key.camelize(:lower)
    when :upper_camel
      key.camelize(:upper)
    when :snake
      key.underscore
    end
  end

  def crawl_array(array, index)
    array.map { |j| value(j, index) }.tap do |a|
      a.compact! if compact
    end
  end
end
