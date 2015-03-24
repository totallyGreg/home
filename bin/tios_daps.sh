#!/usr/bin/ksh
# Author John Clutter - john.clutte@citigroup.com
#
# tios_daps.sh 
# 
# This script will recursively run tios and dap scans on a list of servers in the following files

daps_list="daps_list"
tios_list="tios_list" 
exceptions_list="exceptions"

function run_tios {
## Recursive function that will run the dap

## INPUTS: takes the following inputs in the following order
## server list, exceptions list, interation number, scan type 1=tios 2=daps

## PROCESS:
## creates a pre_list file from the original list minus the exceptions file
## fires off tios or dap scan in backgroud for all servers in the pre_list
## successful runs are collected in the post_file                        
## function waits for 5 minutes then determines the failed files by compareing the pre and post files
## function then calls itself with using the list of failed servers it determined from the previous step

	# set local scope
	# set varibles
	typeset run_list=$1
	typeset exceptions_list=$2
	typeset count=$3
	typeset post_temp="$run_list"_post.tmp
	typeset pre_temp="$run_list"_pre.tmp
	typeset scan_type=$4        
      
	# debug

#	echo "**** DEBUG ****"
#	echo $count 
#	echo $run_list
#	echo $pre_temp
#	echo $post_temp
#	echo $exceptions_list
#	echo $scan_type
#	echo 

	#clean up any previous temp files from a failed run   
        
	if [[ -e "$post_temp" ]] 
	then
		rm $post_temp
	fi	

	if [[ -e  "$pre_temp" ]]
	then
		rm $pre_temp	
	fi
		
	if [[ -e "$run_list"_failures ]]
	then
		rm "$run_list"_failures	
	fi 
       
	# create Pre File            
	egrep -v -f $exceptions_list $run_list >> $pre_temp
      
	# seed Post file - done because egrep sucks
	touch $post_temp
	print " " > $post_temp

	# set local scope
	typeset i         

	# loop that run through pre list  and fires off either dap or tios scan 
	for i in `cat $pre_temp` ; do
       		echo "processing scan for $i"
		if [[ $scan_type -eq 1 ]]
		then
        		ssh $i "/opt/TIscan/bin/scan -c /opt/TIscan/etc/sysscan.cfg -t -o" 2>&1 |grep Uploading |grep OK |awk -F"/" '{print $3}' |awk -F"." '{print $1}'>> "$post_temp" &
        		sleep 1 
		elif [[ $scan_type -eq 2 ]]
		then
			 ssh $i "/opt/TIscan/bin/scan -e /opt/TIscan/etc -t" 2>&1 |grep Uploading |grep OK | awk -F"/" '{print $3}' |awk -F"." '{print $1}'>> "$post_temp" &
			sleep 1	
		fi	
	done             
              
	sleep 300 
       
	# compare pre and post and determine failures then create new runlist
	egrep -v -f $post_temp $pre_temp > $run_list 

	# clean up pre and post files
	if [[ -e "$pre_temp" ]]
        then
                rm $pre_temp 
        fi

	if [[ -e "$post_temp" ]]
        then
                rm $post_temp  
        fi
	
	# recursive fun! only run 3 times. change if statement to go through more interations
	if [[ $count -lt 3 ]]; then 
		# call ourself with failed server list and incrementing the count
		run_tios $run_list $exceptions_list $((count+=1)) $scan_type 
	fi

	# move the failed list to a destictive fail name	
	if [[ -e "$run_list" ]]
        then
       		mv "$run_list" "$run_list"_failures 
	fi

}

## MAIN

tios_num=`wc -l $tios_list |awk '{print $1}'`
daps_num=`wc -l $daps_list |awk '{print $1}'`
echo "$tios_num TIOS scans to process"
echo "$daps_num DAP scans to process"
#

# create a copy of orginal dap and tios lists so we don't overwrite them

if [[ -e "$tios_list" ]]
        then      
		cp $tios_list "$tios_list"_run
	else
		echo "ERROR - $tios_list does not exist" 
        fi                  


if [[ -e "daps_list" ]]
        then                
       		cp $daps_list "$daps_list"_run
	else
		echo "ERROR - $daps_list does not exist" 
	fi                  

# create files with list of exception severs

if [[ -e "$exceptions_list" ]]
	then 
		egrep -f $exceptions_list $tios_list > "$tios_list".exceptions_to_be_run
		egrep -f $exceptions_list $daps_list > "$daps_list".exceptions_to_be_run
	else
		echo "ERROR - $exceptions_list does not exist"
	fi

# Kick off scan function setting count number to 0   
run_tios "$tios_list"_run $exceptions_list 0 1 
run_tios "$daps_list"_run $exceptions_list 0 2 


