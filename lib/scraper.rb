require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  
  
  
  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    @all = []
    # doc.css("div.student-card")
    
    doc.css("div.student-card").each do |index|
      student = {}
      student[:name] = index.css("h4.student-name").text
      student[:location] = index.css("p.student-location").text
      student[:profile_url] = index.css("a").attribute("href").value
      @all << student
      # binding.pry
    end 
    @all
    # binding.pry
  end

  def self.scrape_profile_page(profile_url)
    links={}
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
   
    social = doc.css("div.vitals-container .social-icon-container a")
    social.each do |index|
      if index.attribute("href").value.include?("twitter")
        links[:twitter] = index.attribute("href").value
      elsif index.attribute("href").value.include?("linkedin")
        links[:linkedin] = index.attribute("href").value
      elsif index.attribute("href").value.include?("github")
        links[:github] = index.attribute("href").value
      else index.attribute("href").value.include?("blog")
        links[:blog] = index.attribute("href").value
       end 
    end 
    
    links[:profile_quote] = doc.css("div.vitals-container .vitals-text-container div.profile-quote").text
    
    links[:bio] = doc.css(".details-container .bio-block .bio-content .description-holder p").text
    
    # binding.pry
    links
  end
end

