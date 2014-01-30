#
# Cookbook Name:: gvm
# Recipe:: default
#
# Copyright 2014, Nathan Mische
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

gvm_pkgs = value_for_platform_family({
  "debian" => ["curl","unzip","sed"],
  "default" => ["curl","unzip","sed"]
})

gvm_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

bash "gvm_install" do
  user        node.gvm.user
  cwd         node.gvm.home
  environment Hash['HOME' => node.gvm.home, 'gvm_user_install_flag' => '1']
  code        <<-SH
  curl -s get.gvmtool.net -o /tmp/gvm-installer &&
  bash /tmp/gvm-installer
  rm /tmp/gvm-installer
  SH
  not_if      { File.directory?("#{node.gvm.home}/.gvm") }
end