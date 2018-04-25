module Jekyll
  module Strapi
    # Add Strapi Liquid variables to all templates
    Jekyll::Hooks.register :site, :pre_render do |site, payload|
      payload['strapi'] = StrapiDrop.new(site)
    end
  end
end
