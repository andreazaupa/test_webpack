server 'staging.megiston.com', user: 'deploy', roles: %w{app db web}

set :rvm_type, :auto                     # Defaults to: :auto
set :rvm_ruby_version, '2.5.0'
set :branch, "master"

set :rails_env, 'staging'
set :deploy_to, "/home/deploy/apps/#{fetch(:rails_env)}/#{fetch(:application)}"

set :puma_bind, "tcp://localhost:8860"
set :puma_threads, [1, 2]

# set :npm_flags, '--silent --no-progress'    # default
# set :npm_flags, ''

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

namespace :deploy do
  desc "Uploads a robots.txt that mandates the site as off-limits to crawlers"
  task :block_robots do
    content = [
      '# This is a staging site. Do not index.',
      'User-agent: *',
      'Disallow: /'
    ].join($/)
    on roles(:all) do
      within release_path do
        puts "Uploading blocking robots.txt"
        execute(:echo, "\"#{content}\" > public/robots.txt")
      end
    end
  end
end

after "deploy:cleanup", "deploy:block_robots"
