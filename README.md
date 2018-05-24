# Wordpress Deploy

Set of ansible playbooks and scripts to deploy Wordpress and all necessary packages
on remote host.

## Getting Started

Run
``` 
git clone https://github.com/VoldemarsPunte/wordpressdeploy.git
```
Then
``` 
cd wordpressdeploy/
```
Run main script without parameters for help
```
./run.sh
```
### Prerequisites

This script require ansible 2.5.3 installed. To install latest ansible packages run:
```
./run.sh install
```
Tested on Ubuntu Server 18.04 LTS

### Configuration

Deployment configuration stored under "vars" section in wordpress.yml file. 
Configuration file include variables for Wordpress database name, username, password and installation path on remote host.

### Deploying

To deploy Wordpress and all necessary packages to remote host run
```
./run.sh deploy
```
You will be asked for the Wordpress site domain name, remote host IP and remote host username.
Ansible requires ssh password and sudo password to complete all steps.

Deploy script installs Nginx, Percona-MySQL, php-fpm, memcached packages with apt 
and install Wordpress using archive from download_url variable

Deploy script will enable UFW firewall with access to 22, 80, 443 ports from internet.  

### Testing

To test deployment run
```
./run.sh test
```
This will test access to ssh, mysql, nginx services and wordpress main web page on remote host


### Rollback

To rollback all changes made on remote host run
```
./run.sh rollback
```
This command will uninstall all installed packages and will remove all files installed on remote host.

Also UFW firewall will be disabled on remote host.


### Service Management

You can control services on remote host using command
```
./run.sh service <service name> <service action>
```
Where available service name is 
* nginx 
* mysql
* php7.2-fpm

and service action is 
* start
* stop
* restart


## Built With

* [Ansible](https://www.ansible.com)


### Acknowledgments
Partialy using code from 
* [wp2vps](https://github.com/DmitriyLyalyuev/wp2vps)

