module Jekyll
  # Add helper methods for dealing with Strapi to the Site class
  class Site
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
      has_strapi? and @config['strapi']['endpoint'] or "http://localhost:1337"
    end

    def strapi_link_resolver(collection = nil, document = nil)
      return "/" unless collection != nil and @config['strapi']['collections'][collection]['permalink'] != nil

      url = Jekyll::URL.new(
        :template => @config['strapi']['collections'][collection]['permalink'],
        :placeholders => {
          :id => document.id.to_s,
          :uid => document.uid,
          :slug => document.slug,
          :type => document.type
        }
      )

      url.to_s
    end

    def strapi_collection(collection_name)
      strapi_collections[collection_name]
    end
  end
end
