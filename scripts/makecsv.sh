set -e
set -o pipefail

# ******************
# Set Some Variables
# ******************

# SORT LIST
SortList () {
sort -u ./facebook-groups-keywords.txt -o ./facebook-groups-keywords.txt
}

#GENERATE CSV
GenerateCSV () {
tr '\n' ',' < ./facebook-groups-keywords.txt > ./facebook-groups-keywords.csv
}

#UPDATE README
UpdateReadme () {
startmarker="_______________"
endmarker="____________________"
totalphrases=$(wc -l < ./facebook-groups-keywords.txt)

printf '%s\n%s\n' "${startmarker}" "#### Total Keywords and Phrases: ${totalphrases}" "${endmarker}" >> ./tmprdme
mv ./tmprdme ./tmprdme2
ed -s ./tmprdme2<<\IN
1,/_______________/d
/____________________/,$d
,d
.r ./README.md
/_______________/x
.t.
.,/____________________/-d
w ./README.md
q
IN
rm ./tmprdme2
}


# RUN TRIGGERS
echo "Generating CSV"
SortList
GenerateCSV
UpdateReadme
echo "Finished"