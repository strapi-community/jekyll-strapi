# frozen_string_literal: true
require "down"

module Jekyll
      class StrapiStaticFile < StaticFile
        def initialize(site, base, dir, name, collection = nil)
          @site = site
          @base = base
          @dir  = dir
          @name = name
          @collection = collection
          # TODO: Check if user can change 'assets' path
          @relative_path = File.join(*["assets", @name].compact)
          @extname = File.extname(@name)
        end
      end

    module StrapiImageFilter
      def asset_url(input)
        assets_path = "assets" # TODO: to figure our in which conditions it can change
        strapi_endpoint = @context.registers[:site].config['strapi']['endpoint']
        uri_path = "#{strapi_endpoint}#{input['url']}"
        if not Dir.exist?('_tmp_assets')
          # TODO: Check if there is not ability to overwrite from the _config
          Jekyll.logger.info "_tmp_assets directory does not exist, I am going to create one"
          Dir.mkdir '_tmp_assets'
        end
        ##
        # TODO: Investigate if there is a better way to download binaries
        # Check if we need authenticate to get medias
        Down.download(uri_path, destination: "_tmp_assets/#{input['name']}")
        ##
        # To perform copying of the assets in the cycle of Jenkins
        # https://jekyllrb.com/docs/rendering-process/
        site = Jekyll.sites.first 
        site.static_files << StrapiStaticFile.new(site, site.source, "_tmp_assets", "#{input['name']}")
        "/assets/#{input['name']}"
      end
    end
  end
Liquid::Template.register_filter(Jekyll::StrapiImageFilter)
