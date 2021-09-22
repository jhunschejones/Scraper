class Book
  CSV_HEADERS = ["Title", "Subtitle", "Author"].freeze

  attr_reader :title, :author

  def initialize(title:, author:)
    @title = title
    @author = author
  end

  def short_title
    title[/(.+)(\(.*?\)|:.*)/, 1]&.strip || title
  end

  def sub_title
    title[/(.+)(\(.*?\)|:.*)/, 2]&.gsub(": ", "")&.gsub("(", "")&.gsub(")", "")
  end

  def as_csv_row
    [short_title, sub_title, author]
  end
end
