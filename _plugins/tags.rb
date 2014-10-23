module Jekyll
  class TagPage < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = tag.gsub(' ','_').downcase + '.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag.html')
      self.data['tag'] = tag
      self.data['posts'] = site.tags[tag]
    end
  end

  class TagPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'tag'
        dir = 't'
        site.tags.keys.each do |tag|
          site.pages << TagPage.new(site, site.source, dir, tag)
        end
      end
    end
  end
end