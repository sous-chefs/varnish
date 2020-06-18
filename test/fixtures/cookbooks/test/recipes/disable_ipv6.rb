# Encoding: utf-8
bash 'disable ipv6 for testing' do
  code <<-EOS
    echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
    echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6
  EOS
end

bash 'overwrite resolv.conf to work around ipv6 bug' do
  code <<-EOS
    echo nameserver 8.8.8.8 > /etc/resolv.conf
  EOS
end
