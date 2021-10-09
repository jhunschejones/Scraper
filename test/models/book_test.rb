require_relative "../test_helper"

class BookTest < Test::Unit::TestCase

  def test_sets_title_and_author
    book = Book.new(title: "The REIGN: Out of Tribulation", author: "Jeffrey McClain Jones")
    assert_equal book.title, "The REIGN: Out of Tribulation"
    assert_equal book.author, "Jeffrey McClain Jones"
  end

  def test_extracts_short_title_with_colon
    book = Book.new(title: "The REIGN: Out of Tribulation", author: "Jeffrey McClain Jones")
    assert_equal book.short_title, "The REIGN"
  end

  def test_extracts_short_title_with_parens
    book = Book.new(title: "Hearing Jesus (Seeing Jesus Book 2)", author: "Jeffrey McClain Jones")
    assert_equal book.short_title, "Hearing Jesus"
  end

  def test_extracts_subtitle_with_colon
    book = Book.new(title: "The REIGN: Out of Tribulation", author: "Jeffrey McClain Jones")
    assert_equal book.sub_title, "Out of Tribulation"
  end

  def test_extracts_subtitle_with_parens
    book = Book.new(title: "Hearing Jesus (Seeing Jesus Book 2)", author: "Jeffrey McClain Jones")
    assert_equal book.sub_title, "Seeing Jesus Book 2"
  end

  def test_returns_expected_values_when_no_subtitle_is_present
    book = Book.new(title: "Seeing Jesus", author: "Jeffrey McClain Jones")
    assert_equal book.short_title, "Seeing Jesus"
    assert_equal book.sub_title, nil
  end
end
