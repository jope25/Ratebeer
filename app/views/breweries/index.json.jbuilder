json.array!(@breweries) do |b|
  json.extract! b, :id, :name, :year, :active
  json.beers b.beers.count
end