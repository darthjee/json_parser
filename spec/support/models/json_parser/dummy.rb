class JsonParser::Dummy
  include JsonParser
  attr_reader :json

  json_parse :id
  json_parse :name, path: 'user'
  json_parse :father_name, full_path: 'father.name'
  json_parse :age, cached: true
  json_parse :house, class: ::House
  json_parse :old_house, class: ::House, cached: true
  json_parse :games, class: ::Game
  json_parse :games_filtered, class: ::Game, after: :filter_games, full_path: 'games'

  def initialize(json)
    @json = json
  end

  def filter_games(games)
    games.select do |g|
      g.publisher != 'sega'
    end
  end
end
