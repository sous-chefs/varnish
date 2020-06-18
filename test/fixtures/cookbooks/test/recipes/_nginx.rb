package 'nginx'

cookbook_file '/etc/nginx/nginx.conf'

# avoid depending on init system
execute 'nginx_restart' do
  command 'pkill nginx; nginx'
end

public_html = '/var/www/public_html'

directory public_html do
  recursive true
end

file "#{public_html}/index.html" do
  content 'Hello World!'
end
