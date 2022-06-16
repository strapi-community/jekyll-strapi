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
        # Let's use StrapiHTTP :)
        response = strapi_request(uri)
        data = response.data
        data.each do |document|
          document.type = collection_name
          document.collection = collection_name
          document.id ||= document._id
          uri_document = URI("#{@site.endpoint}/api/#{collection_name}/#{document.id}?populate=*")
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
