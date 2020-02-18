require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    @doc = Nokogiri::HTML(open(index_url))
    scrape_arr = Array.new.tap do |arr|
      @doc.css(".student-card").each do |noko| 
        hash = {
          location: noko.css(".student-location").text,
          name: noko.css(".student-name").text,
          profile_url: noko.css("a")[0]['href']
        }
        arr << hash
      end
    end
  end

  def self.scrape_profile_page(profile_url)
    @doc = Nokogiri::HTML(open(profile_url))
    scrape_hash = {}
    @doc.css(".social-icon-container a").each do |noko|
       scrape_hash[:twitter] = noko['href'] if noko['href'].include?("twitter")
       scrape_hash[:github] = noko['href'] if noko['href'].include?("github")
       scrape_hash[:linkedin] = noko['href'] if noko['href'].include?("linkedin")
       scrape_hash[:blog] = noko['href'] if noko.css('img')[0]['src'].include?("rss-icon")
    end
    scrape_hash[:profile_quote] = @doc.css(".profile-quote").text
    scrape_hash[:bio] = @doc.css(".bio-content.content-holder .description-holder p").text
    scrape_hash
  end
end

