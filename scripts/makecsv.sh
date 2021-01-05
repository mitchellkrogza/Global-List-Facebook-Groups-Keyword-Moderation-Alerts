# ******************
# Set Some Variables
# ******************

input1="./facebook-groups-keywords.txt"
output1="./facebook-groups-keywords.csv"

# SORT LIST
SortList () {
sort -u ${input1} -o ${input1}
}

#GENERATE CSV
GenerateCSV () {
tr '\n' ',' < ${input1} > ${output1}
}

# RUN TRIGGERS
SortList
GenerateCSV
