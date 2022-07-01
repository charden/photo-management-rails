require "test_helper"

class SessionsTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  setup do
    @user = users(:valid)
  end

  test "ログインページが表示できること" do
    get "/login"
    assert_response :success
  end

  test "h1にログインと記載されていること" do
    get "/login"
    assert_select "h1", "ログイン"
  end

  test "ユーザーIDの入力欄があること" do
    get "/login"
    assert_select "form input[name=name]"
  end

  test "パスワードの入力欄があること" do
    get "/login"
    assert_select "form input[name=password]"
  end

  test "formのsubmitボタンがログインするになっていること" do
    get "/login"
    assert_select "form input[type=submit][value=?]", "ログインする"
  end

  test "フォームのPOST先が/loginであること" do
    get "/login"
    assert_select "form[action=?]", "/login"
  end

  test "未ログイン時にTOPにアクセスするとログイン画面にリダイレクトすること" do
    get "/"
    assert_redirected_to '/login'
  end

  test "ログイン後にTOPにリダイレクトすること" do
    post "/login", params: { name: "test", password: "password" }
    assert_redirected_to "/"
  end

  test "ログイン後にログイン済み状態になっていること" do
    post "/login", params: { name: "test", password: "password" }
    assert logged_in?
  end

  test "ログアウト後にログインページにリダイレクトすること" do
    post "/login", params: { name: "test", password: "password" }
    assert logged_in?

    get "/logout"
    assert_redirected_to "/login"
  end

  test "ログアウト後にログイン済み状態になっていないこと" do
    post "/login", params: { name: "test", password: "password" }
    assert logged_in?

    get "/logout"
    assert_not logged_in?
  end

  test "ユーザーIDが未入力の場合に｢ユーザーIDを入力してください｣と表示されること" do
    post "/login", params: { name: "", password: "password" }

    assert_select "li[class='error']", "ユーザーIDを入力してください"
  end

  test "パスワードが未入力の場合に｢パスワードを入力してください｣と表示されること" do
    post "/login", params: { name: "test", password: "" }

    assert_select "li[class='error']", "パスワードを入力してください"
  end

  test "ユーザーが存在しない場合に｢ユーザーIDとパスワードが一致するユーザーが存在しません｣と表示されること" do
    post "/login", params: { name: "test", password: "test" }

    assert_select "li[class='error']", "ユーザーIDとパスワードが一致するユーザーが存在しません"
  end
end
