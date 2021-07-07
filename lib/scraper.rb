require 'nokogiri'
require 'open-uri'
require 'pry'

# require_relative './student.rb'
class Scraper

  
  def self.scrape_index_page(index_url)
  scraped_students = []
  index_url= open("https://learn-co-curriculum.github.io/student-scraper-test-page/index.html")
  doc = Nokogiri::HTML(index_url)
  
  doc.css("div.student-card").each do |student|
    name = student.css(".student-name").text
    location = student.css(".student-location").text
    profile_url = student.css("a").attribute("href").value
    student_hash =        {:name => name,
                           :location => location,
                           :profile_url => profile_url}
    
    scraped_students << student_hash
    end
    scraped_students
    #binding.pry
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    student = {}
    
     container = profile_page.css(".social-icon-container a").collect{|icon| icon.attribute("href").value}
      container.each do |link|
        if link.include?("twitter")
          student[:twitter] = link
        elsif link.include?("linkedin")
          student[:linkedin] = link
        elsif link.include?("github")
          student[:github] = link
        elsif link.include?(".com")
          student[:blog] = link
        end
      end
      student[:profile_quote] = profile_page.css(".profile-quote").text
      student[:bio] = profile_page.css("div.description-holder p").text
      student
  end
    
end