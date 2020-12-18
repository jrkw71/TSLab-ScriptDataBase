SELECT 
  sp.day_pl
  , sp.channel_id
  , s.title
  , s.artist
  , s.duration
  , sp.hour 
FROM 
  songs_in_playlists sp
  INNER JOIN songs s ON sp.song_id = s.id
WHERE
  sp.day_pl = '2020-11-26'
;


SELECT 
  id
  , file
  , artist
  , title
  , duration
  , file_exists
  , file_size 
FROM 
  songs s;

