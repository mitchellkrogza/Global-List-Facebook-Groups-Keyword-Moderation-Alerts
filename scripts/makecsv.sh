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

# RUN TRIGGERS
echo "Generating CSV"
SortList
GenerateCSV
echo "Finished"