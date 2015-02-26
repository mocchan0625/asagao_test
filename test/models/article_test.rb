require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  # 空の値のチェック
  test "presence" do
    article = Article.new
    assert article.invalid?
    assert article.errors.include?(:title)
    assert article.errors.include?(:body)
    assert article.errors.include?(:released_at)
  end
  test "length" do
    article = FactoryGirl.build(:article)
    article.title = "A" * 201
    assert article.invalid?
    assert article.errors.include?(:title)
  end
  test "expired_at" do
    article = FactoryGirl.build(:article)
    article.released_at = Time.current
    article.expired_at = 1.days.ago
    assert article.invalid?
    assert article.errors.include?(:expired_at)
  end
  test "no_expiration" do
    article = FactoryGirl.build(:article)
    article.no_expiration = true
    assert article.valid?
    assert_nil article.expired_at
  end
  test "readable_for" do
    article1 = FactoryGirl.create(:article, title: "現在",
      released_at: 1.day.ago, expired_at: 1.days.from_now)
    article2 = FactoryGirl.create(:article, title: "過去",
      released_at: 2.days.ago, expired_at: 1.days.ago)
    article3 = FactoryGirl.create(:article, title: "未来",
      released_at: 1.day.from_now, expired_at: 2.days.from_now)
    article4 = FactoryGirl.create(:article, title: "終了日なし",
      released_at: 1.day.ago, expired_at: nil)
    article5 = FactoryGirl.create(:article, title: "会員のみ",
      released_at: 1.day.ago, expired_at: nil, member_only: true)

    articles = Article.readable_for(nil)
    assert_includes articles, article1, "現在の記事が含まれる"
    assert_not_includes articles, article2, "過去の記事は含まれない"
    assert_not_includes articles, article3, "未来の記事は含まれない"
    assert_includes articles, article4, "expiredがnilの場合"
    assert_not_includes articles, article5, "会員限定記事は含まれない"

    articles = Article.readable_for(FactoryGirl.create(:member))
    assert_includes articles, article5, "会員限定記事が含まれる"
  end
end
