#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2013, OpenStreetMap Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "nginx"

# admins = data_bag_item("nginx", "admins")

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0o644
end

directory "/var/cache/nginx/fastcgi-cache" do
  owner "www-data"
  group "root"
  mode 0o755
  only_if { node[:nginx][:cache][:fastcgi][:enable] }
end

directory "/var/cache/nginx/proxy-cache" do
  owner "www-data"
  group "root"
  mode 0o755
  only_if { node[:nginx][:cache][:proxy][:enable] }
end

service "nginx" do
  action [:enable]
  supports :status => true, :restart => true, :reload => true
  subscribes :restart, "template[/etc/nginx/nginx.conf]"
end
