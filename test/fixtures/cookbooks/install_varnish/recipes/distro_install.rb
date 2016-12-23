
node.override['varnish']['configure']['repo']['action'] = :nothing
node.override['varnish']['configure']['ncsa']['action'] = :configure

include_recipe 'varnish::configure'
