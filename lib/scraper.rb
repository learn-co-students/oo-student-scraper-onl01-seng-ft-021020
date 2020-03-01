require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    
    doc = Nokogiri::HTML(open(index_url))
    @students_array =[]

    doc.css("div.roster-cards-container").each do |student|
      student.css(".student-card a").each do |x| 
        student_name = x.css(".student-name").text
        student_location = x.css(".student-location").text
        student_profile = "#{x.attr('href')}"
        @students_array << {
        name: student_name,
        location: student_location,
        profile_url: student_profile
        }
      end
    end
    @students_array
  end

  def self.scrape_profile_page(profile_url)
    
    doc = Nokogiri::HTML(open(profile_url))
    @student_hash = {}

    doc.css("div.main-wrapper div.vitals-container").each do |info|
      info.css(".social-icon-container a").map { |link| link['href'] }.each do |x|
        if x.include?("twitter")
          twitter = x
          @student_hash[:twitter] = twitter
        elsif x.include?("linkedin")
          linkedin = x
          @student_hash[:linkedin] = linkedin
        elsif x.include?("github")
          github = x
          @student_hash[:github] = github
        else 
          blog = x
          @student_hash[:blog] =blog
        end
      end
    end
    profile_quote = doc.css("div.main-wrapper div.vitals-container").css("div.vitals-text-container").css("div.profile-quote").text
    bio = doc.css("div.main-wrapper").css("div.details-container").css("div.description-holder p").text
    @student_hash[:bio] = bio
    @student_hash[:profile_quote] = profile_quote
    @student_hash
  end
end        
        
