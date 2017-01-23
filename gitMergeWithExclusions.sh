#!/bin/bash

usage(){
	echo "-----------------------------------------------------------------------------------------------------------"
	echo "==Purpose==" 
	echo "This script can be used to exclude a list of directories when merging from one git branch to another"
	echo
	echo "==Usage=="
	echo "bash $0 [-a branchname] [-p branchname] [-d directory] [directory ...]"
	echo
	echo "==Options=="
	echo "a : name of the branch which is accepting the changes;"
	echo "p : name of the branch which is providing the changes;"
	echo "d : list of directory names to exclude while merging. Separate multiple directory names using a blank space."
	echo
	echo "Note: you will have to perform a manual push to the remote repo after this script has finished running."
	echo
	echo "==Author=="
	echo "Piyush Agarwal"
	echo "www.impiyush.com"
	echo "1/23/2017"
	echo "------------------------------------------------------------------------------------------------------------"
	exit
}

resetDirectory(){
	git reset -- "$1"
	rm -rf "$1"
}

if [ "$#" = 0 ] 
then
	usage
fi

while [ "$1" != "" ]; do
	case $1 in
		-a )	BRANCH_ACCEPTOR=$2; shift;;
		-p )	BRANCH_PROVIDER=$2; shift;;
		-d )	DIR=$2; shift;;
		-* )	usage;;
		* ) break;;
	esac
	shift
done

if [ "$BRANCH_ACCEPTOR" = "" ] 
then
	usage
fi

if [ "$BRANCH_PROVIDER" = "" ] 
then
	usage
fi

if [ "$DIR" = "" ] 
then
	usage
fi


# git commands


# 1. checkout the accepting branch
echo "Step-1 Checkout the accepting branch"
git checkout "$BRANCH_ACCEPTOR" 
echo

# 2. merge the providing branch but don't commit and no fast forward
echo "Step-2 Merge with no-commit and no fast-forward"
git merge --no-commit --no-ff "$BRANCH_PROVIDER" 
echo

# 3. merges are now staged, so reset and delete the directories
resetDirectory "$DIR"

for MORE_DIR in "$@"; do
	resetDirectory "$MORE_DIR"
done
echo "Step-3 resetting and deleting the specified exclusion directories successful"
echo

# 4. finally commit the merge
echo "Step-4 Finally, commit the merged changes"
git commit -m "Merged $BRANCH_PROVIDER into $BRANCH_ACCEPTOR with specified exclusions"
echo
echo "Merge with exclusions successful. Please verify and push to remote repo"
