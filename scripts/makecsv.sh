set -e
set -o pipefail

# ******************
# Set Some Variables
# ******************

VERSIONNUMBER=$(date "+%F")
LATESTBUILD="V.${VERSIONNUMBER}"

# SORT LIST
SortList () {
sort -u ./facebook-groups-keywords.txt -o ./facebook-groups-keywords.txt
}

#GENERATE CSV
GenerateCSV () {
cnum=0
while mapfile -t -n 21 ary && ((${#ary[@]})); do
    cnum=$((${cnum}+1))
    printf '%s,' "${ary[@]}" > ./facebook-groups-keywords-${cnum}.csv
    printf -- "--- Generating facebook-groups-keywords-${cnum}.csv ---\n"
done < ./facebook-groups-keywords.txt

tr '\n' ',' < ./facebook-groups-keywords.txt > ./facebook-groups-keywords-complete.csv
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

PlainTextLinks (){
startmarker2="---------------"
endmarker2="--------------------"

printf '%s\n%s\n' "${startmarker2}" >> ./tmprdme

for filename in `ls -v *.csv`;
do
 echo "Processing ${filename}"
 charcount=$(printf %d $(wc -c <${filename}))
printf '%s\n' "* [${filename}](https://raw.githubusercontent.com/mitchellkrogza/Global-List-Facebook-Groups-Keyword-Moderation-Alerts/main/${filename}) (Char Count: ${charcount})" >> ./tmprdme
done

printf '%s\n'"${endmarker2}" >> ./tmprdme
mv ./tmprdme ./tmprdme2
ed -s ./tmprdme2<<\IN
1,/---------------/d
/--------------------/,$d
,d
.r ./README.md
/---------------/x
.t.
.,/--------------------/-d
w ./README.md
q
IN
rm ./tmprdme2
}

CommitAndPush () {
          git config --global user.name "mitchellkrogza"
          git config --global user.email "mitchellkrog@gmail.com"
          git add -A
          git commit -m "${LATESTBUILD}"
          git push
}

# RUN TRIGGERS
echo "Generating CSV"
SortList
GenerateCSV
UpdateReadme
PlainTextLinks
CommitAndPush
echo "Finished"
