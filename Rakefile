require "jekyll"
require "tmpdir"

require "net/http"

GITHUB_REPONAME = "sgoettschkes/sgoettschkes.github.io"
GITHUB_REMOTE = "https://#{ENV['GH_TOKEN']}@github.com/#{GITHUB_REPONAME}"
SITEMAP_PATH = "http%3A%2F%2Fsgoettschkes.me%2Fsitemap.xml"

desc "Generate blog files"
task :generate do
    Jekyll::Site.new(Jekyll.configuration({
        "source"      => ".",
        "destination" => "_site"
    })).process
end

desc "Serve blog from localhost"
task :serve do
    system "jekyll serve --watch --force_polling"
end

desc "Generate and publish blog to master"
task :publish => [:generate] do
    fail "Not on Travis" if "#{ENV['TRAVIS']}" != "true"

    Dir.mktmpdir do |tmp|
        cp_r "_site/.", tmp

        pwd = Dir.pwd
        Dir.chdir tmp

        system "git init"
        system "git config user.name 'Sebastian Göttschkes'"
        system "git config user.email 'sebastian.goettschkes@googlemail.com'"

        system "git add ."
        message = "Site updated at #{Time.now.utc}"
        system "git commit -m #{message.inspect}"
        system "git remote add origin #{GITHUB_REMOTE}"
        system "git push --force origin master"

        Dir.chdir pwd
    end

    Rake::Task["ping"].invoke
end

desc "Push sitemap to Google and Bing"
task :ping do
    urls = [
        "http://www.google.com/webmasters/tools/ping?sitemap=#{SITEMAP_PATH}",
        "http://www.bing.com/webmaster/ping.aspx?siteMap=#{SITEMAP_PATH}"]
    urls.each do |url|
        uri = URI.parse(url)
        req = Net::HTTP::Get.new(uri.to_s)
        res = Net::HTTP.start(uri.host, uri.port) { |http|
            http.request(req)
        }
    end
end
