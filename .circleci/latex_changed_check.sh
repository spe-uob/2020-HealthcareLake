#######################
### commit_check.sh ###
#######################

set -e

# latest commit
LATEST_COMMIT=$(git rev-parse HEAD)

# latest commit where path/to/folder1 was changed
FOLDER1_COMMIT=$(git log -1 --format=format:%H --full-diff docs)

if [ $FOLDER1_COMMIT = $LATEST_COMMIT ];
    then
        exit 0;
else
     exit 1;
fi
