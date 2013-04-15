#
# Author:: Joey O'Neill (<joey@cheezburger.com>)
# Cookbook Name:: chz-firewall
# Recipe:: default
#
# Copyright 2013, Cheezburger, Inc.

#This recipe just figures out the correct firewall and launches that recipe
case node["chz-firewall"]["firewall_type"]
when "windows"
  include_recipe "chz-firewall::windows"
when "csf"
  include_recipe "chz-firewall::csf"
when "iptables"
  include_recipe "chz-firewall::iptables"
end
