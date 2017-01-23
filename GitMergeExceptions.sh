#!/bin/bash

usage(){
	echo "usage: $0 [-a branchname] [-p branchname] [-d directory] [directory ...]"
	# echo
	# echo "Where:-"
	# echo
	# echo "a : name of the branch which is accepting the changes;"
	# echo
	# echo "p : name of the branch which is providing the changes;"
	# echo
	# echo "d : list of directory names to exclude while merging. \
	# Separate multiple directory names using a blank space."
	# echo
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
git checkout "$BRANCH_ACCEPTOR" 

# 2. merge the providing branch but don't commit and no fast forward
git merge --no-commit --no-ff "$BRANCH_PROVIDER" 

# 3. merges are now staged, so reset and delete the directories
resetDirectory "$DIR"

for MORE_DIR in "$@"; do
	resetDirectory "$MORE_DIR"
done

# 4. finally commit the merge
git commit -m "Merged $BRANCH_PROVIDER into $BRANCH_ACCEPTOR successfully" 

