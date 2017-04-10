
node.override['varnish']['configure']['repo']['action'] = :nothing
node.override['varnish']['configure']['ncsa']['action'] = :configure
node.override['varnish']['configure']['ncsa']['ncsa_format_string'] = 'ncsa_format_string_test|%h|%l|%u|%t|\"%r\"|%s|%b|\"%{Referer}i\"|\"%{Varnish:hitmiss}x\"|\"%{User-agent}i\"'

include_recipe 'varnish::configure'
