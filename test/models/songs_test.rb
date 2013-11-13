require 'test_helper'

TEST_HASH = {
      "num"=>"1",
      "added"=>"1373283960",
      "album"=>"VAVA VOOM",
      "album_artist_raw"=>"Bassnectar",
      "artist"=>"Bassnectar",
      "bitrate"=>"320",
      "channel"=>"2",
      "comment"=>"",
      "compilation"=>"0",
      "disc"=>"0",
      "file"=>"01 Vava Voom (ft Lupe Fiasco).mp3",
      "filetype"=>"mp3 l3v1",
      "genre"=>"Electronic",
      "grouping"=>"",
      "label"=>"",
      "lastplay"=>"0",
      "lastskip"=>"0",
      "length"=>"230",
      "length_estimated"=>"0",
      "missing"=>"0",
      "modif"=>"1333372429",
      "playcount"=>"0",
      "rating"=>"",
      "replaygain_album_gain"=>"0",
      "replaygain_album_peak"=>"0",
      "replaygain_track_gain"=>"0",
      "replaygain_track_peak"=>"0",
      "samprate"=>"44100",
      "size"=>"9430547",
      "skipcount"=>"0",
      "title"=>"Vava Voom (ft Lupe Fiasco)",
      "track"=>"1",
      "version"=>"",
      "year"=>"2012"
    }

class SongsTest < ActiveSupport::TestCase
  test "can instantiate a song from a hash" do
    song = Song.new(TEST_HASH)
    assert_equal "Bassnectar", song.artist
    assert_equal "VAVA VOOM", song.album
    assert_equal "Vava Voom (ft Lupe Fiasco)", song.title
    assert_equal 0, song.playcount
  end

  test "the song class has an 'all' method" do
    assert Song.respond_to?(:all)
  end

  test "there should be a delete_all method that erases all songs" do
    assert Song.respond_to?(:delete_all)
    Song.delete_all

    assert_empty Song.all
  end
end

class SongWithDeleteAllMethod < ActiveSupport::TestCase
  setup do
    Song.delete_all
  end

  test "a song can be saved" do
    assert Song.all.empty?, "there should be no songs present"

    song = Song.new(TEST_HASH)

    assert song.save

    assert_equal 1, Song.all.length
  end

  test "a song can be found by num" do
    assert Song.all.empty?, "there should be no songs present"

    song = Song.new(TEST_HASH)
    assert song.save

    found_song = Song.find_by_num(1)

    assert_equal found_song, song
  end

  test "a song with no num gets assigned one" do
    assert Song.all.empty?, "there should be no songs present"

    song = Song.new({ 'artist' => "Foo", 'title' => "Bar" })
    song.save

    assert_equal 1, song.num
    assert_equal 1, Song.all.length
  end

  test "saving a song with the same num overrides the old one" do
    assert Song.all.empty?, "there should be no songs present"

    song = Song.new({ 'artist' => "Foo", 'title' => "Bar" })
    song.save

    assert_equal 1, song.num
    assert_equal 1, Song.all.length

    song = Song.new({ 'num' => 1, 'artist' => "Bar", 'title' => "Bar" })
    song.save

    assert_equal 1, song.num
    assert_equal 1, Song.all.length

    found_song = Song.find_by_num(1)
    assert_equal "Bar", found_song.artist
  end

  test "songs comes with a method that imports more songs from a hash array" do
    assert Song.all.empty?, "there should be no songs present"
    assert Song.respond_to?(:load_from_hash_array), "should have .load_from_hash_array method"

    hash_array = 5.times.map do |i|
      { 'artist' => "Foo #{i}", 'title' => "Bar #{i}", 'playcount' => "5" }
    end

    Song.load_from_hash_array(hash_array)
    assert_equal 5, Song.all.length
    assert_equal [0,1,2,3,4], Song.all.map { |s| s.artist.reverse.to_i }
  end
end


class SongsGroupingTest < ActiveSupport::TestCase
  setup do
    Song.delete_all

    Song.new({ 'artist' => "Foo", 'title' => "Bar", 'playcount' => "5" }).save
    Song.new({ 'artist' => "Foo", 'title' => "Bar 1", 'playcount' => "6" }).save
    Song.new({ 'artist' => "Baz", 'title' => "Bar", 'playcount' => "15" }).save
    Song.new({ 'artist' => "Baz", 'title' => "Bar 1", 'playcount' => "14" }).save
    Song.new({ 'artist' => "Baz", 'title' => "Bar 2", 'playcount' => "20" }).save
  end

  test "find_by_artist can find all songs by an artist" do
    assert_equal 2, Song.find_by_artist("Foo").length
    assert_equal 3, Song.find_by_artist("Baz").length
  end

  test "can find a certain track" do
    song = Song.find_by_artist_and_title("Foo", "Bar 1")
    assert_equal 2, song.num
  end

  test "can return top played" do
    assert_equal [5,3,4,2,1], Song.top_played.map(&:num)
    assert_equal [5,3,4], Song.top_played(3).map(&:num)
  end
end
