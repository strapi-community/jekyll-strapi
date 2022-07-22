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
        Jekyll.logger.debug "Jekyll Collection init:" "#{site.config} #{collection_name} #{config}"
      end

      def generate?
        @config['output'] || false
      end

      def get_data
        # path = "/#{@config['type'] || @collection_name}?_limit=10000"
        # This seems be not working anymore:
        # https://docs.strapi.io/developer-docs/latest/developer-resources/database-apis-reference/rest-api.html#api-parameters
        # and pagination is now done in following way:
        # https://docs.strapi.io/developer-docs/latest/developer-resources/database-apis-reference/rest/sort-pagination.html#pagination-by-page
        uri = URI("#{@site.endpoint}/api/#{endpoint}#{path_params}")
        Jekyll.logger.debug "StrapiCollection get_document:" "#{collection_name} #{uri}"
        response = strapi_request(uri)
        response.data
      end

      def get_document(did)
        uri_document = URI("#{@site.endpoint}/api/#{endpoint}/#{did}?populate=#{populate}")
        Jekyll.logger.debug "StrapiCollection iterating uri_document:" "#{uri_document}"
        strapi_request(uri_document)
        # document
      end

      def each
        data = get_data
        data.each do |document|
          Jekyll.logger.debug "StrapiCollection iterating over document:" "#{collection_name} #{document.id}"
          document.type = collection_name
          document.collection = collection_name
          document.id ||= document._id
          document_response = get_document(document.id)
          # We will keep all the attributes in strapi_attributes
          document.strapi_attributes = document_response['data']["attributes"]
          document.url = @site.strapi_link_resolver(collection_name, document)
        end
        data.each {|x| yield(x)}
      end

      def endpoint
        @config['type'] || @collection_name
      end

      def populate
        @config["populate"] || "*"
      end

      def path_params
        string = "?"
        return_params = false

        if @config["parameters"]
          return_params = true

          @config["parameters"].each do |k, v|
            string += "&#{k}=#{v}"
          end
        end

        if custom_path_params.length != 0
          return_params = true

          string += custom_path_params
        end

        return_params ? string : ""
      end

      def custom_path_params
        # Define custom logic in your _plugins/file_name.rb
        ""
      end
    end
  end
end
