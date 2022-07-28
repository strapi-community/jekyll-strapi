module Jekyll
  module Strapi
    class StrapiCollectionPermalink
      attr_reader :collection, :lang

      def initialize(collection:, lang: nil)
        @collection = collection
        @lang = lang
      end

      def directory
        use_different? ? permalinks[lang].split("/")[1] : collection.collection_name
      end

      def exist?
        config.key? 'permalink'
      end

      def to_s
        use_different? ? permalinks[lang] : config['permalink']
      end

      private

      def config
        collection.config
      end

      def permalinks
        config['permalinks']
      end

      def use_different?
        permalinks && permalinks[lang]
      end
    end
  end
end
