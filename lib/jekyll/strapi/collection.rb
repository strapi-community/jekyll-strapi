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
        # Get entries
        Jekyll.logger.info "Jekyll Strapi:", "Fetching entries from #{uri}"
        # response = Net::HTTP.get_response(uri)
        response = strapi_request(uri)
        # Check response code
        if response.code == "200"
          _result = JSON.parse(response.body, object_class: OpenStruct)
          result = _result.data 
        elsif response.code == "401"
          raise "The Strapi server sent a error with the following status: #{response.code}. Please make sure you authorized the API access in the Users & Permissions section of the Strapi admin panel."
        else
          raise "The Strapi server sent a error with the following status: #{response.code}. Please make sure it is correctly running."
        end
        # Add necessary properties
        result.each do |document|
          document.type = collection_name
          document.collection = collection_name
          document.id ||= document._id
          document.title = document.attributes.Title
          # During the iteration we pull the whole document using populate=*
          path_document =         path = "/#{@collection_name}/#{document.id}"
          uri_document = URI("#{@site.endpoint}/api/#{collection_name}/#{document.id}?populate=*")
          # _document_response = Net::HTTP.get_response(uri_document)
          _document_response = strapi_request(uri_document)
          document_response = JSON.parse(_document_response.body)
          document.strapi_attributes = document_response['data']["attributes"]
          document.url = @site.strapi_link_resolver(collection_name, document)
        end
        result.each {|x| yield(x)}
      end
    end
  end
end
