module Jekyll
  # Add helper methods for dealing with Strapi to the Site class
  class Site
    attr_accessor :lang

    def strapi
      return nil unless has_strapi?
    end

    def strapi_collections
      return Array.new unless has_strapi_collections?
      @strapi_collections ||= Hash[@config['strapi']['collections'].map {|name, config| [name, Strapi::StrapiCollection.new(self, name, config)]}]
    end

    def has_strapi?
      @config['strapi'] != nil
    end

    def has_strapi_collections?
      has_strapi? and @config['strapi']['collections'] != nil
    end

    def endpoint
      has_strapi? and ENV['STRAPI_ENDPOINT'] or @config['strapi']['endpoint'] or "http://localhost:1337"
    end

    def strapi_link_resolver(collection = nil, document = nil)
      return "/" unless collection != nil and @config['strapi']['collections'][collection]['permalink'] != nil
      url = Jekyll::URL.new(
        :template => url_template(collection),
        :placeholders => {
          :id => document.id.to_s,
          :uid => document.uid,
          :slug => document.attributes.slug,
          :type => document.attributes.type,
          :date => document.attributes.date,
          :title => document.title
        }
      )

      url.to_s
    end

    def strapi_collection(collection_name)
      strapi_collections[collection_name]
    end

    def url_template(collection)
      permalink = @config['strapi']['collections'][collection]['permalink']
      permalinks = @config['strapi']['collections'][collection]['permalinks']

      return permalink unless permalinks && permalinks[lang]
      "/#{lang}#{permalinks[lang]}"
    end
  end
end
