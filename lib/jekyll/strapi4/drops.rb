module Jekyll
  module Strapi
    # Strapi Document access in Liquid
    class StrapiDocumentDrop < Liquid::Drop
      attr_accessor :document

      def initialize(document)
        @document = document
      end

      def [](attribute)
        value = @document[attribute]

        case value
        when OpenStruct
          StrapiDocumentDrop.new(value)
        when Array
          StrapiCollectionDrop.new(value)
        else
          value
        end
      end
    end

    # Handles a single Strapi collection in Liquid
    class StrapiCollectionDrop < Liquid::Drop
      def initialize(collection)
        @collection = collection
      end

      def to_liquid
        results = []
        @collection.each do |result|
          results << StrapiDocumentDrop.new(result)
        end
        results
      end
    end

    # Handles Strapi collections in Liquid, and creates the collection on demand
    class StrapiCollectionsDrop < Liquid::Drop
      def initialize(collections)
        @collections = collections
      end

      def [](collection_name)
        StrapiCollectionDrop.new(@collections[collection_name])
      end
    end

    # Main Liquid Drop, handles lazy loading of collections to drops
    class StrapiDrop < Liquid::Drop
      def initialize(site)
        @site = site
      end

      def collections
        @collections ||= StrapiCollectionsDrop.new(@site.strapi_collections)
      end
    end
  end
end
