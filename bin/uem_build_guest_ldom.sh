#!/bin/bash
# This script is used to create one or many Guest LDOM's 
# If given a single argument of a hostname will step through the creation
# If given a file containing multiple LDOM's it will check resources and 
# allocate according to the specifications
# -OPTIONS  <hostname>  or -f <filename> -n (dry run just print available info)

## Any Errors stop the script immediately **
set -e 

#Debugging 
#if Debugging 
set -x
[ ls ] && echo "ls executed successfully"

# Step 1 - Gather currently available resources
# - vCPU
# - MAU
# - Memory
# - Disk /opt/vcapcoll/bin/disk_free ?
# - current number of LDOMs
# - Root pool created? 


# Step 2 - Single LDOM Case - Gather specifications 

# Step 2b - Multiple LDOM's passed through file - Read in Specifications

# Step 3 - Given input determine if LDOM(s) can be created
# if disks in root pool already total N+1 including new N don't add new drive
# otherwise add new drive to root pool 

# Step 4 - Generate Display of New build(s) to verify before creation

# Step 5 - Create LDOM(s)
# Create Root Disk
	# if there is is no root pool create with 2 disks
	# if ldom root disk already exists prompt to reuse
	# if root_disk_count <= ldom_count +1 then add new disk
# Create each data disk
# Create guest with the values provided earlier                               
# domain=$1                                                                   
# num_cpu=$2                                                                  
# num_mau=$3                                                                  
# num_memory=$4                                                               
