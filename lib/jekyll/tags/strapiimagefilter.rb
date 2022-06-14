# frozen_string_literal: true
require "down"

module Jekyll
    module StrapiImageFilter
      def asset_url(input)
        strapi_endpoint = @context.registers[:site].config['strapi']['endpoint']
        uri_path = "#{strapi_endpoint}#{input['url']}"
        if not Dir.exist?('assets')
          # TODO: Check if there is not ability to overwrite from the _config
          Jekyll.logger.info "assets directory does not exist, I am going to create one"
          Dir.mkdir 'assets'
        end
        Down.download(uri_path, destination: "assets/#{input['name']}")
        "/assets/#{input['name']}"
      end
    end
  end
Liquid::Template.register_filter(Jekyll::StrapiImageFilter)
