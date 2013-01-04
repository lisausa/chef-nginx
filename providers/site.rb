action :create do
  template "#{node.nginx.dir}/sites-available/#{new_resource.name}" do
    owner "root"
    group "root"
    mode 00644
    source new_resource.source
    cookbook new_resource.cookbook if new_resource.cookbook
    variables new_resource.variables
    notifies :reload, 'service[nginx]'
    action :create
  end
end

action :enable do
  action_create
  execute "nxensite #{new_resource.name}" do
    command "/usr/sbin/nxensite #{new_resource.name}"
    notifies :reload, "service[nginx]"
    not_if do ::File.symlink?("#{node.nginx.dir}/sites-enabled/#{new_resource.name}") end
  end
end

action :disable do
  execute "nxdissite #{new_resource.name}" do
    command "/usr/sbin/nxdissite #{new_resource.name}"
    notifies :reload, "service[nginx]"
    only_if do ::File.symlink?("#{node.nginx.dir}/sites-enabled/#{new_resource.name}") end
  end
end

action :delete do
  action_disable
  template "#{node.nginx.dir}/sites-available/#{new_resource.name}" do
    action :delete
  end
end