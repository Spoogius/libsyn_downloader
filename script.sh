DL_LOCATION="podcasts/"
TMP_LOCATION="tmp_web_dl/"

ID3_ARTIST="Dr. Jordan Cooper"
ID3_ALBUM="Just and Sinner Podcast"
ID3_TITLE="" # To be derived from filename


mkdir -p $DL_LOCATION
mkdir -p $TMP_LOCATION

ID3_TRACK_NUM=1
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


  # Edit ID3v2 mp3 tags
  ID3_TITLE=$DATE_STAMP"_"$SHOW_TITLE
  id3v2 -a "$ID3_ARTIST" -A "$ID3_ALBUM" -t "$ID3_TITLE" -T $ID3_TRACK_NUM -2 $DL_LOCATION/$FILENAME

  # Prefix filename with sortable date string
  mv $DL_LOCATION/$FILENAME $DL_LOCATION/$DATE_STAMP"_"$SHOW_TITLE".mp3"
	
  ID3_TRACK_NUM=$((ID3_TRACK_NUM+1))

done < "$1"
rm -rf $TMP_LOCATION
