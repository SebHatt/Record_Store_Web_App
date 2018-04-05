require_relative('../db/sql_runner')

class Artist

  attr_reader :id, :name

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end
  
  def save()
    sql = "INSERT INTO artists (name)
    VALUES ($1)
    RETURNING id"
    values = [@name]
    result = SqlRunner.run(sql, values)
    id = result.first["id"]
    @id = id.to_i
  end

  def self.delete_all()
    sql = "DELETE FROM artists;"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM artists
    WHERE id = $1"
    values = [@id]
    SqlRunner.run( sql, values )
  end

  def self.find(id)
    sql = "SELECT * FROM artists
    WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql ,values).first
    artist = Artist.new(result)
    return artist
  end

  def self.all()
    sql = "SELECT * FROM artists"
    artist_data = SqlRunner.run(sql)
    artists = map_items(artist_data)
    return artists
  end

  def self.map_items(artist_data)
    return artist_data.map { |artist| Artist.new(artist) }
  end


end
