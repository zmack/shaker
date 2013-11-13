require 'test_helper'

class SongsControllerTest < ActionController::TestCase
  setup do
    Song.delete_all
  end

  test "index renders the correct template" do
    get :index
    assert_template :index
  end

  test "show renders the correct template" do
    post :create, :song => { :artist => "Testy", :title => "The Test" }

    get :show, :id => 1
    assert_template :show
  end

  test "edit renders the correct template" do
    get :edit, :id => 1
    assert_template :edit
  end

  test "new renders the correct template" do
    get :new
    assert_template :new
  end

  test "adding a new song actually creates it" do
    post :create, :song => { :artist => "Testy", :title => "The Test" }

    assert_equal 1, Song.all.length
    song = Song.all.last

    assert_equal "Testy", song.artist
    assert_equal "The Test", song.title
  end

  test "updating a song actually updates it" do
    Song.new({ :num => 1, :artist => "Fooby", :title => "Barsy" })

    post :update, :id => 1, :song => { :artist => "Testy", :title => "The Test" }

    assert_equal 1, Song.all.length
    song = Song.all.last

    assert_equal "Testy", song.artist
    assert_equal "The Test", song.title
  end
end
