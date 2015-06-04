begin
  require 'rspec/core/rake_task'
  require 'bundler/gem_tasks'
  require 'coveralls/rake/task'

  Coveralls::RakeTask.new
  RSpec::Core::RakeTask.new(:spec) do |task|
    task.rspec_opts = ['--color', '--format documentation']
  end

  task :default => [:specs, 'coveralls:push']
rescue
end
