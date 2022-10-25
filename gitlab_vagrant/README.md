Vagrant Gitlab Server

Quickly set up a local Gitlab CE server using Vagrant.

Run vagrant up to setup the virtual server.

Server Details
    Installs latest Docker
    Installs latest Gitlab CE
    Installs latest Gitlab Multi Runner
    Server at http://192.168.2.21 (http://gitlab.local.dev)

To fetch the root user password

vagrant ssh
sudo vim /etc/gitlab/initial_root_password



