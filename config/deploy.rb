set :application, "lawrencecurtis.co.uk" # www. auto prefixed
set :repository,  "git://github.com/lawrencecurtis/lawrencecurtis.co.uk.git" 
set :scm, "git" 

set :user, "deploy" 
set :runner, user
# starting port
set :mongrel_port, 3000

# threads required, 3 should be ample
set :mongrel_servers, 3 

# If you aren't deploying to /u/apps/#{application} on the target%
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/srv/#{application}" 

role :app, "yellowpad.co.uk" 
role :web, "yellowpad.co.uk" 
role :db,  "yellowpad.co.uk", :primary => true