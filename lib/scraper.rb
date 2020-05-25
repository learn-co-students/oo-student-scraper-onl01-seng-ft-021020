require 'open-uri'
require 'pry'

class Scraper

  #name, location, profileURL

  def self.scrape_index_page(index_url)

    @doc = Nokogiri::HTML(open(index_url))

    result = Array.new

    @doc.css(".student-card").each do |card|
      name = card.css(".student-name").inner_html
      location = card.css(".student-location").inner_html
      profile_url = card.css('a').attribute('href').value
      result << {
        name: name,
        location: location,
        profile_url: profile_url
      }


    end

    return result
    
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))


    
    result = {
      profile_quote: doc.css(".profile-quote").inner_html,
      bio: doc.css(".bio-content p").inner_html,
    }

    l = doc.css('.social-icon-container a').map { |link| link['href'] }
    l.each do |link|
      if link.include?("linkedin.com")
        result[:linkedin] = link
      elsif link.include?("twitter.com")
        result[:twitter] = link
      elsif link.include?("github.com")
        result[:github] = link
      else
        result[:blog] = link
      end
        
    end

    return result
    
  end

end

