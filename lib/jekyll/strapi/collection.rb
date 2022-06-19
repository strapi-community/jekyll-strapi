require "net/http"
require "ostruct"
require "json"

module Jekyll
  module Strapi
    class StrapiCollection
      attr_accessor :collection_name, :config

      def initialize(site, collection_name, config)
        @site = site
        @collection_name = collection_name
        @config = config
      end

      def generate?
        @config['output'] || false
      end

      def each
        # Initialize the HTTP query
        path = "/#{@config['type'] || @collection_name}?_limit=10000"
        uri = URI("#{@site.endpoint}/api#{path}")
        Jekyll.logger.debug "StrapiCollection main:" "#{collection_name} #{uri}"
        # Let's use StrapiHTTP :)
        response = strapi_request(uri)
        data = response.data
        data.each do |document|
          document.type = collection_name
          document.collection = collection_name
          document.id ||= document._id
          Jekyll.logger.debug "StrapiCollection iterating over document:" "#{collection_name} #{document.id}"
          uri_document = URI("#{@site.endpoint}/api/#{collection_name}/#{document.id}?populate=*")
          Jekyll.logger.debug "StrapiCollection iterating uri_document:" "#{uri_document}"

          document_response = strapi_request(uri_document)
          # We will keep attributes in strapi_attributes
          document.strapi_attributes = document_response['data']["attributes"]
          document.url = @site.strapi_link_resolver(collection_name, document)
        end
        data.each {|x| yield(x)}
      end
    end
  end
end
