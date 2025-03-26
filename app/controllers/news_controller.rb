require 'open-uri'
require 'nokogiri'

class NewsController < ApplicationController
  def index
    @years = (2022..2025).to_a 
  end

  def months
    @year = params[:year]
    @months = (1..12).to_a  # January - December
  end

  def monthly_news

    @year = params[:year] || Time.now.year
    @month = params[:month] || Time.now.month
    page = params[:page] || 1

    base_url= "https://www.theverge.com/archives"

    all_news = []

    (1..15).each do |page|
      # url = "#{base_url}/#{year}/#{month}/1"

      url = "#{base_url}/#{@year}/#{@month}/#{page}"
        doc = Nokogiri::HTML(URI.open(url))

      logger.info("scraping #{url}")
      doc.css("div.duet--content-cards--content-card").each do |card|
        timestamp = card.at_css("span.duet--article--timestamp time")
        link = card.at_css("a._1lkmsmo1")

        if link
          title = link.text.strip
          time = timestamp.text.strip
          logger.info("title #{link}")
          next if title.blank?

          all_news << {title: title, url: link['href'], time: time}
        end
      end

    end

    @news = Kaminari.paginate_array(all_news).page(params[:page]).per(20)
  end

#   def fetch_titles
#     year = params[:year] || Time.now.year
#     month = params[:month] || Time.now.month
#     page = params[:page] || 1
# 
#     link = "https://www.theverge.com/archives"
# 
#     @news = []
# 
#     # (2022..2025).each do |year|
#     #   (1..12).each do |month|
#     #     (1..15).each do |page|
#     url = "#{link}/#{year}/#{month}/#{page}"
#     logger.info("scraping #{url}")
#     doc = Nokogiri::HTML(URI.open(url))
# 
#     doc.css("a#_1lkmsmo1").each do |link|
#       title = link.text.strip
#       next if title.blank?
# 
#       @news << {title: title, url: link['href']}
#       # News.find_or_create_by(title: title, url: link['href'])
#     end
#     #     end
#     #   end
#     # end
#   end
end

