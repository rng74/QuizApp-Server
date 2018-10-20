namespace :parse do
  desc "Parsing shikimori.org using json file"
  task take_anime: :environment do
    require "nokogiri"
    require "open-uri"
    require "json"

    url = "https://shikimori.org"
    search_url = "#{url}/animes?search="
    res = ""
    document = File.open(File.join("lib/tasks/","anim_info.json"), "r").each do |str|
      res += str
    end

    anime_info = JSON.parse(res)

    hentai = 0
    not_found = 0
    ok = 0
    anime_info.each do |anime|
      html = Nokogiri::HTML(open("#{search_url}#{anime["title_orig"]}"))
      if html.at_css(".cc-entries .c-column") # if such anime exist
        link = html.css(".cc-entries .c-column a")[0]["href"]
        ok+=1
      else
        if html.at_css(".age-restricted-warning")
          hentai+=1
        else
          not_found+=1
        end
      end
    end

    puts("+18: #{hentai}\nnot_found: #{not_found}\nok: #{ok}")

  end
end
