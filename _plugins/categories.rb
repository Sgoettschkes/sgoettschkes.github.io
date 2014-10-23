module Jekyll
  class CategoryPage < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = category + '.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category.html')
      self.data['category'] = category

      category_title_prefix = site.config['category_title_prefix'] || 'Category: '
      self.data['title'] = "#{category_title_prefix}#{category}"
    end
  end

  class CategoryPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'category'
        dir = 'c'
        site.categories.keys.each do |category|
          site.pages << CategoryPage.new(site, site.source, dir, category)
        end
      end
    end
  end
end