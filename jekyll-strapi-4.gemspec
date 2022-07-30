$:.unshift(File.expand_path("../lib", __FILE__))
require "jekyll/strapi4/version"

Gem::Specification.new do |spec|
  spec.version = Jekyll::Strapi::VERSION
  spec.homepage = "https://github.com/bluszcz/jekyll-strapi-4"
  spec.authors = ["Strapi Solutions", "Rafał Zawadzki", "Michał Krajewski"]
  spec.email = ["bluszcz@bluszcz.net"]
  spec.files = %W(README.md LICENSE) + Dir["lib/**/*"]
  spec.summary = "Strapi.io integration for Jekyll"
  spec.required_ruby_version = '>= 3.0.0'
  spec.name = "jekyll-strapi-4"
  spec.license = "MIT"
  spec.require_paths = ["lib"]
  spec.description = spec.description = <<-DESC
    A Jekyll plugin for retrieving content from a Strapi 4 API
  DESC

  spec.add_runtime_dependency("down", "~> 5.0")
  spec.add_runtime_dependency("jekyll", "~> 4")
  spec.add_runtime_dependency("http", "~> 3.2")
  spec.add_runtime_dependency("json", "~> 2.1")

end
