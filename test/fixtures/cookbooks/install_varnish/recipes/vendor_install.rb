
node.override['varnish']['configure']['ncsa']['action'] = :configure

include_recipe 'varnish::configure'
