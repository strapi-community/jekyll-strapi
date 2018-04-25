module Jekyll
  module Strapi
    # Generates pages for all collections with have the "generate" option set to True
    class StrapiGenerator < Generator
      safe true

      def generate(site)
        site.strapi_collections.each do |collection_name, collection|
          if collection.generate?
            collection.each do |document|
              site.pages << StrapiPage.new(site, site.source, document, collection)
            end
          end
        end
      end
    end

    class StrapiPage < Page
      def initialize(site, base, document, collection)
        @site = site
        @base = base
        @collection = collection
        @document = document

        @dir = @collection.config['output_dir'] || collection.collection_name
        # Default file name, can be overwritten by permalink frontmatter setting
        @name = "#{document.id}.html"

        self.process(@name)
        self.read_yaml(File.join(base, "_layouts"), @collection.config['layout'])

        # Use the permalink collection setting if it is set
        if @collection.config.key? 'permalink'
          self.data['permalink'] = @collection.config['permalink']
        end

        self.data['document'] = StrapiDocumentDrop.new(@document)
      end

      def url_placeholders
        requiredValues = @document.to_h.select {|k, v|
          v.class == String and @collection.config['permalink'].include? k.to_s
        }

        Utils.deep_merge_hashes(requiredValues, super)
      end
    end
  end
end
