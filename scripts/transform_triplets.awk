#  _                        __                     
# | |                      / _|                    
# | |_ _ __ __ _ _ __  ___| |_ ___  _ __ _ __ ___  
# | __| '__/ _` | '_ \/ __|  _/ _ \| '__| '_ ` _ \ 
# | |_| | | (_| | | | \__ \ || (_) | |  | | | | | |
#  \__|_|  \__,_|_| |_|___/_| \___/|_|  |_| |_| |_|
                                                 
#  _        _       _      _       
# | |      (_)     | |    | |      
# | |_ _ __ _ _ __ | | ___| |_ ___ 
# | __| '__| | '_ \| |/ _ \ __/ __|
# | |_| |  | | |_) | |  __/ |_\__ \
#  \__|_|  |_| .__/|_|\___|\__|___/
#            | |                   
#            |_|             

BEGIN {
  FS="<SEP>";
  OFS=",";
  users_iterator=0;

  while(( getline line < "db/tmp/songs.hash") > 0  ) {
    split(line, song_id, ",");
    songs_hashmap[song_id[2]]=song_id[1];
  }

  # date_iterator can be used to create dates.in relation. however it's not efficient to use it anyway, so we don't do that.
  date_iterator=0;
}

{
  if (!($1 in users)) {
    users[$1] = users_iterator;
    users_iterator++;
  }

  # we can create relation dates, but for this assignment, it's not efficient to use it, because we only need month information and we can store it in activities.in
  date_hash_key=strftime("%Y", $3, 1) "," strftime("%m", $3, 1) "," strftime("%d", $3, 1)
  if (date_hash_key in dates) {
    dates[date_hash_key];
  } else {
    dates[date_hash_key]=date_iterator;
    date_iterator++;
  }
  print dates[date_hash_key], strftime("%Y", $3, 1), strftime("%m", $3, 1), strftime("%d", $3, 1) > "db/dates.in";

  # we only need a month from the date for our operations, so we don't extract it. strftime("%m", $3)
  print users[$1], songs_hashmap[$2], strftime("%m", $3,1) > "db/activities.in"
}

END {
  for (i in users) {
    print users[i], i > "db/users.in"
  }
}

# FNR - record number (in the current file)
# $2 - song id
# $3 - artist
# $4 - song