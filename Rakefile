##
# Rakefile https://ruby-doc.org/stdlib-3.1.2/libdoc/rake/rdoc/Rake/TestTask.html
multitask :default => [:test]

require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

require "rdoc/task"
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  # rdoc.title = "#{name} #{version}"
  rdoc.title = "jekyll-strapi-4 1.0.7"
  rdoc.rdoc_files.include("README*")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

desc "Build jekyll-strapi-4 into pkg/"
task :build do
  sh "gem build"
end
