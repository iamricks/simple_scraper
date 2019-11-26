require 'nokogiri'
require 'httparty'
require 'byebug'


def scraper

	page = 1
	reached_last_page = false
	books = Array.new

	while !reached_last_page do

		puts "We are on page " + page.to_s

		start_count = books.count

		url = "http://books.toscrape.com/catalogue/page-" + page.to_s + ".html"
		unparsed_page = HTTParty.get(url)
		parsed_page = Nokogiri::HTML(unparsed_page)

		# Entire div of book box
		books_boxs = parsed_page.css('article.product_pod')

		# Loop through objects
		books_boxs.each do |book_box|

			# Create obj
			book = {
				thumbnail: "http://books.toscrape.com/" + book_box.css('a img')[0]['src'],
				price: book_box.css('p.price_color').text.gsub('£', ''),
				title: book_box.css('h3')[0].text
			}

			books << book
		end

		end_count = books.count

		reached_last_page = true if start_count == end_count

		page += 1
	end

	puts "We collected " + books.count.to_s + " books."

	puts "This is our array of books"
	puts books

end

scraper