set(:vhosts) { "" }

class Capistrano::Configuration
  ##
  # Read a file and evaluate it as an ERB template.
  # Path is relative to this file's directory.

  def render_erb_template(filename)
    reason = ENV['REASON']
    deadline = ENV['UNTIL']
    
    template = File.read(filename)
    result   = ERB.new(template).result(binding)
  end
end

namespace :yellowpad do

  desc "Generate spin script from variables"
  task :generate_spin_script, :roles => :app do
    result = render_erb_template(File.dirname(__FILE__) + "/templates/spin.erb")
    put result, "#{release_path}/script/spin", :mode => 0755
  end
  after "deploy:update_code", "yellowpad:generate_spin_script"
  
  task :create_db, :roles => :db, :only => { :primary => true } do
    rake = fetch(:rake, "rake")
    rails_env = fetch(:rails_env, "production")
    migrate_env = fetch(:migrate_env, "")
    migrate_target = fetch(:migrate_target, :latest)

    directory = case migrate_target.to_sym
      when :current then current_path
      when :latest  then current_release
      else raise ArgumentError, "unknown migration target #{migrate_target.inspect}"
      end

    run "cd #{directory}; #{rake} RAILS_ENV=#{rails_env} #{migrate_env} db:create"
  end
  before "deploy:migrate", "yellowpad:create_db"
  
  desc "Setup Nginx vhost config"
  task :nginx_vhost, :roles => :app do
    result = render_erb_template(File.dirname(__FILE__) + "/templates/nginx.vhost.conf.erb")
    put result, "/tmp/nginx.vhost.conf"
    sudo "mkdir -p /srv/vhost.d"
    sudo "cp /tmp/nginx.vhost.conf /srv/vhost.d/#{application}.conf"
    sudo "/etc/init.d/nginx reload" 
    sudo "chown -R #{user}:#{runner} /srv/#{application}"
  end
  after "deploy:setup", "yellowpad:nginx_vhost"

end

namespace :deploy do
  namespace :web do
    desc <<-DESC
      Present a maintenance page to visitors. Disables your application's web \
      interface by writing a "maintenance.html" file to each web server. The \
      servers must be configured to detect the presence of this file, and if \
      it is present, always display it instead of performing the request.

      By default, the maintenance page will just say the site is down for \
      "maintenance", and will be back "shortly", but you can customize the \
      page by specifying the REASON and UNTIL environment variables:

        $ cap deploy:web:disable \\
              REASON="hardware upgrade" \\
              UNTIL="12pm Central Time"

      Further customization will require that you write your own task.
    DESC
    task :disable, :roles => :web, :except => { :no_release => true } do
      require 'erb'
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }

      result = render_erb_template(File.dirname(__FILE__) + "/templates/maintenance.erb.html")

      put result, "#{shared_path}/system/maintenance.html", :mode => 0644
    end

    desc <<-DESC
      Makes the application web-accessible again. Removes the \
      "maintenance.html" page generated by deploy:web:disable, which (if your \
      web servers are configured correctly) will make your application \
      web-accessible again.
    DESC
    task :enable, :roles => :web, :except => { :no_release => true } do
      run "rm #{shared_path}/system/maintenance.html"
    end
  end
end