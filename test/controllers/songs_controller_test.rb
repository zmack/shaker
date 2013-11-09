require 'test_helper'

class SongsControllerTest < ActionController::TestCase
  test "index renders the correct template" do
    get :index
    assert_template :index
  end

  test "show renders the correct template" do
    get :show
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


  test "the secret page requires authentication" do
    get :secret
    assert_response :unauthorized

    @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'secret')
    get :secret

    assert_response :ok
  end
end
