# frozen_string_literal: true
require "down"

module Jekyll
    module StrapiImageFilter
      def asset_url(input)
        strapi_endpoint = @context.registers[:site].config['strapi']['endpoint']
        uri_path = "#{strapi_endpoint}#{input['url']}"
        Down.download(uri_path, destination: "assets/#{input['name']}")
        "/assets/#{input['name']}"
      end
    end
  end
Liquid::Template.register_filter(Jekyll::StrapiImageFilter)
