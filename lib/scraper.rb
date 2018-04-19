require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students = []
    doc.css(".student-card").each do |student|
      students << {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a").attr("href").value
      }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    profile = {}

    links = doc.css(".social-icon-container").children.css("a").map { |e| e.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        profile[:linkedin] = link
      elsif link.include?("github")
        profile[:github] = link
      elsif link.include?("twitter")
        profile[:twitter] = link
      else
        profile[:blog] = link
      end
    end

    #if doc.at_css("div.social-icon-container a[href*='twitter']") != nil
    #  profile = {
    #    :twitter => doc.css("div.social-icon-container a[href*='twitter']").attr("href").value,
    #    :linkedin => doc.css("div.social-icon-container a[href*='linkedin']").attr("href").value,
    #    :github => doc.css("div.social-icon-container a[href*='github']").attr("href").value,
        #:blog => doc.css("div.social-icon-container a[href*='blog']").attr("href").value,
        profile[:profile_quote] = doc.css("div.profile-quote").text,
        profile[:bio] = doc.css("div.description-holder p").text
    #  }
    #else
    #  profile = {
    #    :twitter => doc.css("div.social-icon-container a[href*='twitter']").attr("href").value,
    #    :linkedin => doc.css("div.social-icon-container a[href*='linkedin']").attr("href").value,
    #    :github => doc.css("div.social-icon-container a[href*='github']").attr("href").value,
    #    :profile_quote => doc.css("div.profile-quote").text,
    #    :bio => doc.css("div.description-holder p").text
    #  }
    #end
    profile
  end

end
