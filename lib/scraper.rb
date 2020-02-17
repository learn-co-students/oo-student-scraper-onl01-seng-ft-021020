# require 'Nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    student_hash = doc.css(".student-card a")
    student_hash.collect do |ele|
      {
        :name => ele.css(".student-name").text,
        :location => ele.css(".student-location").text,
        :profile_url => ele.attr("href")
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    final_hash = {}
    profile_links = doc.css(".vitals-container .social-icon-container a")
    profile_links.each do |ele|
      if ele.attr('href').include?("twitter")
        final_hash[:twitter] = ele.attr("href")
      elsif ele.attr('href').include?("linkedin")
        final_hash[:linkedin] = ele.attr("href")
      elsif ele.attr('href').include?("github")
        final_hash[:github] = ele.attr("href")
      elsif ele.attr('href').include?("http://")
        final_hash[:blog] = ele.attr("href")
      end
    end
    #  final_hash[:blog] = "http://flatironschool.com"
    final_hash[:profile_quote] = doc.css(".vitals-text-container .profile-quote").text
    final_hash[:bio] = doc.css(".details-container .bio-block  .description-holder p").text
  
  final_hash
  end

end

