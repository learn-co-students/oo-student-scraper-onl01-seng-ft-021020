require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    
    student_array = []
    
    doc.css("div.student-card").each do |student|
      name = student.css(".student-name").text
      location = student.css(".student-location").text
      student_url = student.css("a").attribute("href").value 
      student_info = {:name => name,
                :location => location,
                :profile_url => student_url}
      student_array << student_info
      
    end
    student_array
    
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    students = {}
    container = doc.css(".social-icon-container a").collect{|icon| icon.attribute("href").value}
    container.each do |link|
      if link.include?("twitter")
        students[:twitter] = link
      elsif link.include?("linkedin")
        students[:linkedin] = link
      elsif link.include?("github")
        students[:github] = link
      elsif link.include?(".com")
        students[:blog] = link
      end
    end
    students[:profile_quote] = doc.css(".profile-quote").text
    students[:bio] = doc.css("div.description-holder p").text
    students
  end

end

