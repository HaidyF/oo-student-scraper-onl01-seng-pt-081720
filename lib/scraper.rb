require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    output = []
    doc = Nokogiri::HTML(open("https://learn-co-curriculum.github.io/student-scraper-test-page/index.html" ))
    student = doc.css("div.student-card")
    student.each do |student|
      student_name = student.css(".student-name").text
      student_location  = student.css(".student-location").text
      student_url = student.css("a").attribute("href").value
      hash = {:name => student_name, :location => student_location, profile_url: student_url}
      output<<hash
    end
   output
  end

  def self.scrape_profile_page(profile_url)
    output_student = {}
    docs = Nokogiri::HTML(open(profile_url))
    accounts = docs.css(".social-icon-container a").collect{|icon| icon.attribute("href").value}
    accounts.each do |link|
      if link.include?("twitter")
        output_student[:twitter] = link
      elsif link.include?("linkedin")
        output_student[:linkedin] = link
      elsif link.include?("github")
        output_student[:github] = link
      elsif link.include?(".com")
        output_student[:blog] = link
      end
    end
    output_student[:profile_quote] = docs.css(".profile-quote").text
    output_student[:bio] = docs.css("div.description-holder p").text
    output_student
end
end

