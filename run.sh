#!/bin/bash

init_script () {
	#Get info from user
	echo "Please enter Domain name"
	read domainName
	echo "Please enter IP"
        read ip
	echo "Please enter User name"
        read userName
	#Enter information into the host file
	echo "[appservers-php]" > hosts
	echo $domainName" ansible_ssh_host="$ip" ansible_ssh_user="$userName >> hosts
	#Execute inint file
	ansible-playbook -i hosts wordpress.yml -kK
}
install_script () {
        # Install ansible
        sudo apt-get update
        sudo apt-get install -y software-properties-common
        yes '' | sudo apt-add-repository ppa:ansible/ansible
        sudo apt-get update;sudo apt-get install -y ansible
}

print_help () {
	echo
	echo "Plase enter commad that should be executed"
	echo "There are next options: "
	echo "  install: install ansible packages on local host"
	echo "  deploy: deploy wordpress and all necessary packages on remote host"
	echo "  rollback: return remote host to previous state"
	echo "  test: run common services smoke tests"
	echo "  service <service name> <service action>: service php7.2-fpm/nginx/mysql start/stop/restart service"
	echo
}

control_service () {
	#convert code to ansimble code
	action=$2
	if [ "$2" == "start" ] || [ "$2" == "restart" ]
	then
		action=$action"ed"
	fi
	if [ "$2" == "stop" ]
        then
                action=$action"ped"
        fi

	result=$((ansible-playbook -i hosts act/services.yml -kK --extra-vars "service_action=$action service_name=$1") | tee /dev/tty )
	echo
	if [[ "$result" == *"ok=1"* ]]
	then
		echo "Service $1 $action"
	else
		echo "Unable to $2 $1 service"
	fi
}

test_deploy () {
	domainVar=$(cat hosts | awk 'FNR==2 {print $1}')
	ipVar=$(cat hosts | awk 'FNR==2 {print $2}' | cut -f2 -d"=")
	ansible-playbook -i hosts act/tests.yml -kK --extra-vars "domain=$domainVar ip=$ipVar"
}

rollback_func () {
	ansible-playbook -i hosts act/rollback.yml -kK
}

if [ "$1" == "install" ]
then
        install_script
        exit 0
fi


if [ "$1" == "deploy" ]
then
	init_script
	exit 0
fi

if [ "x$1" == "x" ]
then
	echo "Error no command entered"
	print_help
	exit 1
fi

if [ "$1" == "-h" ]
then
	print_help
	exit 0
fi

if [ "$1" == "service" ]
then 
	if [ "x$2" == "x" ]
	then
		echo "Service name not passed"
		exit 1
	fi

	if [ "x$3" == "x" ]
        then
                echo "Service action not passed"
		exit 1
        fi

	control_service $2 $3
	exit 0
fi

if [ "$1" == "rollback" ]
then
        rollback_func
        exit 0
fi

if [ "$1" == "test" ]
then
        test_deploy
        exit 0
fi

echo "Command unknown:" "$1"

print_help

