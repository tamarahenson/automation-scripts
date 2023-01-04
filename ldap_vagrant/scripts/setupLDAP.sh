#!/usr/bin/env bash
echo "Installing Docker"

 curl -fsSL get.docker.com | CHANNEL=stable sh
 sudo apt install docker-ce
 sudo apt-get install docker-ce docker-ce-cli containerd.io

echo "Enable Docker Service"

 systemctl status docker
 sudo systemctl enable docker.service
 sudo systemctl enable containerd.service 

echo "Restart Docker Service"

sudo systemctl restart docker

echo "Creating LDAP container"

docker run -p 389:389 -p 636:636 --name ldap --hostname ldap.portainer.io \
	--env LDAP_ORGANISATION=Portainer \
	--env LDAP_DOMAIN=portainer.io \
	--env LDAP_ADMIN_PASSWORD=admin \
	--env LDAP_CONFIG_PASSWORD=config \
	--detach osixia/openldap:1.5.0

echo "Creating ldif"

sudo docker exec -it ldap /bin/bash

cat <<EOF >> ldap_seed.ldif
dn: ou=groups,dc=portainer,dc=io
objectClass: organizationalunit
objectClass: top
ou: groups
description: groups of users

dn: ou=users,dc=portainer,dc=io
objectClass: organizationalunit
objectClass: top
ou: users
description: users

dn: cn=portainer,ou=users,dc=portainer,dc=io
objectclass: inetOrgPerson
objectclass: posixAccount
objectClass: person
objectClass: top
cn: portainer
sn: portainer
uid: portainer
uidnumber: 1000
gidnumber:  500
homedirectory: /home/users/portainer
memberOf: cn=dev,ou=groups,dc=portainer,dc=io
userPassword: portainer

dn: cn=dev,ou=groups,dc=portainer,dc=io
objectClass: groupofnames
objectClass: top
description: testing group for dev
cn: dev
member: cn=portainer,ou=users,dc=portainer,dc=io
EOF

echo “Updating LDAP”
sudo apt install ldap-utils
ldapadd -x -D "cn=admin,dc=portainer,dc=io" -w admin -f ldap_seed.ldif



