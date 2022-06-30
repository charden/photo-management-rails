require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:valid)
  end

  test "Userは有効か" do
    @user.valid?
    assert @user.valid?
  end

  test "Userのnameがない場合にはエラーが発生すること" do
    @user.name = nil

    assert @user.invalid?
    assert_includes @user.errors[:name], "を入力してください"
  end

  test "Userのpasswordがない場合にはエラーが発生すること" do
    @user.password = nil

    assert @user.invalid?
    assert_includes @user.errors[:password], "を入力してください"
  end
end
