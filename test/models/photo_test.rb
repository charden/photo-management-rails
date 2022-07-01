require "test_helper"

class PhotoTest < ActiveSupport::TestCase
  setup do
    @photo = Photo.new({title: "title"})
    @photo.image.attach(io: File.open(Rails.root.join('test', 'fixtures', 'files', 'three.png')), filename: "three.png", content_type: "image/png")
  end

  test "photoは有効か" do
    assert @photo.valid?
  end

  test "Photoのtitleがない場合にはエラーが発生すること" do
    @photo.title = nil

    assert @photo.invalid?
    assert_includes @photo.errors[:title], "を入力してください"
  end

  test "Photoの30文字の場合には登録できること" do
    @photo.title = "この文章はダミーです。文字の大きさ、量、字間、行間等を確認す"

    assert @photo.valid?
  end

  test "Photoの31文字の場合にはエラーが発生すること" do
    @photo.title = "この文章はダミーです。文字の大きさ、量、字間、行間等を確認する"

    assert @photo.invalid?
    assert_includes @photo.errors[:title], "は30文字以内で入力してください"
  end

  test "Photoのimageがない場合にはエラーが発生すること" do
    @photo.image.purge

    assert @photo.invalid?
    assert_includes @photo.errors[:image], "を入力してください"
  end
end
