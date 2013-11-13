require 'songs'

class Song
  attr_reader :title, :artist

  @@songs = []

  def self.all
    @@songs
  end

  def self.delete_all
    @@songs = []
  end
end
