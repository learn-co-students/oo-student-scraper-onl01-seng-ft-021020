require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    students_array = []
    students = doc.css(".student-card")

    students.each do |student|
      student_info = {
        :name => student.css(".student-name").text,
        :location => student.css(".student-location").text,
        :profile_url => student.css('a')[0]['href']
      }
      students_array << student_info
    end

    students_array
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    profile = {}

    socials = doc.css(".social-icon-container")
    socials.css("a").each do |link|
      if link['href'].include?("twitter")
        profile[:twitter] = link['href']
      elsif link['href'].include?("linkedin")
        profile[:linkedin] = link['href']
      elsif link['href'].include?("github")
        profile[:github] = link['href']
      else
        profile[:blog] = link['href']
      end
    end

    profile[:profile_quote] = doc.css(".profile-quote").text
    profile[:bio] = doc.css(".description-holder p").text

    profile
  end

end

# html = open(index_url)
# doc = Nokogiri::HTML(html)
# students = doc.css(".student-card")
# students_array = []

# students.each do |student|
#   name = student.css(".student-name").text
#   location = student.css(".student-location").text
#   profile_url = student.css('a')[0]['href']
# end

#   student_hash = {
#     name: name,
#     location: location,
#     profile_url: profile_url
#   }

#   students_array << student_hash

# twitter = socials.css("a")[0]['href'] 
# linkedin = socials.css("a")[1]['href']
# github = socials.css("a")[2]['href']
# blog = socials.css("a")[3]['href']

# profile[:twitter] = twitter if twitter
# profile[:linkedin] = linkedin if linkedin
# profile[:github] = github if github
# profile[:blog] = blog if blog