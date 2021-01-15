#!/bin/bash

# A simple script to install packages after installing linux
# packagelist.txt file has the list of packages to be installed.

SU=sudo
CMD=apt
INSTALL=install
PACKAGES=packagelist.txt

Update() {
    echo
    echo "Initiate Update and Upgrade"
    $SU $CMD update
    $SU $CMD upgrade $1
}

Install() {
    echo
    echo "Package Name: $1"
    $SU $CMD $INSTALL $1 $2
}

Info() {
    echo "A simple script to install packages"
    echo "Read a list of packages in packagelist.txt"
    echo "Execute:"
    echo "  $ bash install_tool.sh <options>"
    echo "Options:"
    echo "  -c = select only commented packages"
    echo "  -y = yes to all packages "
    exit 1
}

PrintPackageList() {
    # Prints package list
    echo "List of packages:"
    count=0
    while read package; do
	case $1 in
	    '')  if [[ ${package:0:1} != '#' ]]
		 then
		     count=$(($count+1))
		     echo "-" $package
		 fi
		 ;;
	    '#') if [[ ${package:0:1} == '#' ]]
		 then
		     count=$(($count+1))
		     echo "-" ${package:1:${#package}}
		 fi
		 ;;
	esac
    done < $PACKAGES
    echo $count" packages to be installed."
    if [[ $count == 0 ]]
    then
	echo "Proceeding update and upgrade only!"
    fi
}

GetStatus() {
    # get status
    echo "Do you want to continue? [Y/n]"
    read status
}

InstallPackages() {
    # read and proceed
    if [[ $status == "y" || $status == "Y" ]]
    then
	# update and install
	Update $2
	while read package; do
	    case $1 in
	    '')  if [[ ${package:0:1} != '#' ]]
		 then
		     Install $package $2
		 fi
		 ;;
	    '#') if [[ ${package:0:1} == '#' ]]
		 then
		     Install ${package:1:${#package}} $2
		 fi
		 ;;
	    esac
	done < $PACKAGES
    else
	echo "Abort"
	exit 1
    fi
}

Main() {
    case $1 in
	'-h' | '--help') Info
	      ;;
	'-c') SELECT='#'
	      ;;
    esac
    PrintPackageList $SELECT
    GetStatus
    InstallPackages $SELECT $2
}

# Execution
Main $1 $2
