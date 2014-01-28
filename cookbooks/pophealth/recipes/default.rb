#
# Cookbook Name:: pophealth
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

bash "install passenger" do
  user 1000
  cwd "/home/vagrant"
  code <<-EOH
    source /home/vagrant/.rvm/scripts/rvm
    rvm use 2.0.0
    gem install passenger
  EOH
end

rvm_shell "install passenger/apache2" do
  user "vagrant"
  cwd "/home/vagrant"
  code "passenger-install-apache2-module --auto"
end

bash "generate passenger snippet" do
  user 1000
  cwd "/home/vagrant"
  creates "/home/vagrant/passenger.snippet"
  code <<-EOH
    source /home/vagrant/.rvm/scripts/rvm
    rvm use 2.0.0
    passenger-install-apache2-module --snippet > /home/vagrant/passenger.snippet
  EOH
end

bash "generate passenger modules" do
  creates "/etc/apache2/mods-available/passenger.load"
  code <<-EOH
    head -n 1 /home/vagrant/passenger.snippet > /etc/apache2/mods-available/passenger.load
    tail -n 4 /home/vagrant/passenger.snippet > /etc/apache2/mods-available/passenger.conf
    a2enmod passenger
  EOH
end

template "/etc/apache2/sites-available/pophealth" do
  mode "644"
  source "pophealth.conf"
  notifies :run, "execute[disable_default_site]"
  notifies :run, "execute[enable_pophealth_site]"
end

ssh_known_hosts_entry 'github.com'

git "/home/vagrant/pophealth" do
   user "vagrant"
   group "vagrant"
   repository "git://github.com/pophealth/popHealth.git"
   revision 'master'
   action :sync
end

rvm_shell "bundle install" do
  ruby_string "2.0.0"
  user        "vagrant"
  group       "vagrant"
  cwd         "/home/vagrant/pophealth"
  code        %{bundle install}
end

bash "get measure bundles" do
  user "vagrant"
  creates "/home/vagrant/bundle-latest.zip"
  code "curl -u #{node['pophealth']['nlm_username']}:#{node['pophealth']['nlm_password']} http://demo.projectcypress.org/bundles/bundle-latest.zip -o /home/vagrant/bundle-latest.zip"
end

rvm_shell "import measure bundles" do
  ruby_string "2.0.0"
  user        "vagrant"
  group       "vagrant"
  cwd         "/home/vagrant/pophealth"
  code        %{bundle exec rake bundle:import[/home/vagrant/bundle-latest.zip]}
end

rvm_shell "seed database" do
  ruby_string "2.0.0"
  user        "vagrant"
  group       "vagrant"
  cwd         "/home/vagrant/pophealth"
  code        %{bundle exec rake db:seed}
end

rvm_shell "create admin account" do
  ruby_string "2.0.0"
  user        "vagrant"
  group       "vagrant"
  cwd         "/home/vagrant/pophealth"
  creates "/home/vagrant/run_create_admin_account"
  code        <<-EOH
    bundle exec rake admin:create_admin_account
    touch /home/vagrant/run_create_admin_account
  EOH
end

execute "start_delayed_worker" do
  command "start delayed_worker"
  action :nothing
end

execute "disable_default_site" do
  command "a2dissite default"
  action :nothing
end

execute "enable_pophealth_site" do
  command "a2ensite pophealth"
  action :nothing
  notifies :run, "execute[restart_apache]"
end

execute "restart_apache" do
  command "service apache2 reload"
  action :nothing
end

template "/home/vagrant/start_delayed_job.sh" do
  mode "755"
  source "delayed_job.sh"
end

template "/etc/init/delayed_worker.conf" do
  mode "644"
  source "delayed_worker.conf"
  notifies :run, "execute[start_delayed_worker]"
end




