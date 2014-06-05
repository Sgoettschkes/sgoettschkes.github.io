require "rubygems"
require "tmpdir"

require "bundler/setup"
require "jekyll"

require "net/http"

# Change your GitHub reponame
GITHUB_REPONAME = "sgoettschkes/sgoettschkes.github.io"

desc "Update repository"
task :update do
    system "git stash save"
    system "git pull"
    system "git push"
    system "git stash pop"
end

desc "Generate blog files"
task :generate do
    Jekyll::Site.new(Jekyll.configuration({
        "source"      => ".",
        "destination" => "_site"
    })).process
end

desc "Generate and publish blog to gh-pages"
task :publish => [:generate] do
    Dir.mktmpdir do |tmp|
        cp_r "_site/.", tmp

        pwd = Dir.pwd
        Dir.chdir tmp

        system "git init"
        system "git add ."
        message = "Site updated at #{Time.now.utc}"
        system "git commit -m #{message.inspect}"
        system "git remote add origin git@github.com:#{GITHUB_REPONAME}.git"
        system "git push origin master --force"

        Dir.chdir pwd
    end

    Rake::Task["ping"].invoke

    system "git push origin source"
end

desc "Push sitemap to Google and Bing"
task :ping do
    url = URI.parse('http://www.google.com/webmasters/tools/ping?sitemap=http%3A%2F%2Fsgoettschkes.me%2Fsitemap.xml')
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http|
        http.request(req)
    }

    url = URI.parse('http://www.bing.com/webmaster/ping.aspx?siteMap=http%3A%2F%2Fsgoettschkes.me%2Fsitemap.xml')
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http|
        http.request(req)
    }
end
