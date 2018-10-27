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

    puts("take info from json...")
    anime_info = JSON.parse(res)

    puts("parsing begins")
    hentai = 0
    not_found = 0
    ok = 0
    anime_info.each do |anime|
      html = Nokogiri::HTML(open("#{search_url}#{anime["title_orig"]}"))
      if html.at_css(".cc-entries .c-column") # if such anime exist
        link = html.css(".cc-entries .c-column a")[0]["href"]
        cur_html = Nokogiri::HTML(open("#{url}#{link}"))
        if html.css(".cc-entries .c-column a")[0].at_css(".name-ru")
          title = html.css(".cc-entries .c-column a")[0].css(".name-ru")[0]["data-text"]
        else
          title = anime["title_orig"]
        end
        if cur_html.at_css(".age-restricted-warning")
          hentai+=1
          puts("Hentai!!!")
        else
          ok+=1
          puts("Adding #{title}")

          from_page = JSON.parse(cur_html.css(".l-menu .b-animes-menu .block")[1].css("#rates_statuses_stats")[0]["data-stats"])
          rating = from_page[0]["value"]

          if anime["album_name"].include?("OP")
            tip = "OP"
          elsif anime["album_name"].include?("ED")
            tip = "ED"
          elsif anime["album_name"].include?("OST")
            tip = "OST"
          end

          Anime.create("title_orig"=>anime["title_orig"], "title_ru"=>title, "poster_link"=>anime["poster_link"], "rating"=>rating, "tip"=>tip, "song_name"=>anime["song_name"], "song_link"=>anime["song_link"])
        end
      else
        puts("No such anime")
        not_found+=1
      end
    end

    puts("+18: #{hentai}\nnot_found: #{not_found}\nok: #{ok}")

  end
end
