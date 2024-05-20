DL_LOCATION="podcasts/"
TMP_LOCATION="tmp_web_dl/"

mkdir -p $DL_LOCATION
mkdir -p $TMP_LOCATION

while IFS= read -r POD_PAGE
do
  wget $POD_PAGE -O $TMP_LOCATION/webpage
 
  DL_LINK=$(cat $TMP_LOCATION/webpage | grep -Eo https.*.mp3) 

  # Extract Show Information
  SHOW_TITLE=$(grep -oP '(?<=title>).*?(?=</title>)' $TMP_LOCATION/webpage)
  SHOW_DATE=$(grep -oP '(?<=class="date">).*?(?=</p>)' $TMP_LOCATION/webpage)
  
  # Replace spaces with '_' in title
  SHOW_TITLE=${SHOW_TITLE// /_}
  # Reformat Date to sortable format
  DATE_STAMP=$(date -d"$SHOW_DATE" +%Y%m%d)

  # Download Audio File  
  FILENAME=$(echo $DL_LINK | grep -Eo "[^/]*mp3") 
  wget $DL_LINK -O $DL_LOCATION/$FILENAME

  # Prefix filename with sortable date string
  mv $DL_LOCATION/$FILENAME $DL_LOCATION/$DATE_STAMP"_"$SHOW_TITLE".mp3"

done < "$1"
rm -rf $TMP_LOCATION
