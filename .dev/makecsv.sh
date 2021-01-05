#!/bin/bash

set -e

# ******************
# Set Some Variables
# ******************

input1=${TRAVIS_BUILD_DIR}/facebook-groups-keywords.txt
output1=${TRAVIS_BUILD_DIR}/facebook-groups-keywords.txt

# SORT LIST
sort -u ${input1} -o ${input1}

#GENERATE CSV
GenerateCSV () {
tr '\n' ',' < ${input1} > ${output1}
}


#PREPARE TRAVIS
PrepareTravis () {
    git remote rm origin
    git remote add origin https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git
    git config --global user.email "${GIT_EMAIL}"
    git config --global user.name "${GIT_NAME}"
    git config --global push.default simple
    git checkout "${GIT_BRANCH}"
}

# DEPLOY UPDATE
CommitData () {
commitdate=$(date +%F)
committime=$(date +%T)
timezone=$(date +%Z)
cd ${TRAVIS_BUILD_DIR}
git remote rm origin
git remote add origin https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git
git config --global user.email "${GIT_EMAIL}"
git config --global user.name "${GIT_NAME}"
git config --global push.default simple
git checkout master
git add -A
git commit -am "V.${TRAVIS_BUILD_NUMBER} (${commitdate} ${committime} ${timezone}) [ci skip]"
git push origin master    
}

# RUN TRIGGERS
GenerateCSV
PrepareTravis
CommitData

# **********************
# Exit With Error Number
# **********************

exit ${?}

