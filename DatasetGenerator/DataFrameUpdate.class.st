Class {
	#name : #DataFrameUpdate,
	#superclass : #Object,
	#category : #DatasetGenerator
}

{ #category : #abstract }
DataFrameUpdate class >> API_key: api_key ChannelId: channel_id Dataframe: df [

	"Provide the YouTube API key and a YouTube channel ID.
	Create a Dataframe by running this code in the Pharo Playground:
	Metacello new
  baseline: 'DataFrame';
  repository: 'github://PolyMathOrg/DataFrame/src';
  load.
	df:=DataFrame new: 50@6.

	df columnNames: #(video_id video_title upload_date view_count like_count comment_count).
	
	DataFrameUpdate API_key: api_key ChannelId: channel_id Dataframe: df.
	"
	|response content content_stat n n_stat qo ind h j1 h2 j v_id v_title v_date vc lc cc |
	
response := ZnClient new 
    url: 'https://www.googleapis.com/youtube/v3/search?key=',api_key,'&channelId=',channel_id,'&part=snippet,id&order=date&maxResults=100';
    get;
    response.
content := response contents.

ind:=0.
n:=content size.
qo:=$".

1 to: n-12 do: 
[ :i|h:= content copyFrom: i to: i+6.
	h='videoId'
	ifTrue: [ v_id:= content copyFrom: i+11 to: i+21.
		
		response := ZnClient new 
    	url: 		'https://www.googleapis.com/youtube/v3/videos?id=',v_id,'&part=statistics&key=',api_key;
    get;
    response.
		content_stat := response contents.
		n_stat:= content_stat size.
		1 to: n_stat-20 do: 
            [ :i1|h:= content_stat copyFrom: i1 to: i1+8.
					h='viewCount'
					ifTrue: [ vc:=''.
						j1:=i1+13.
						h2:=content_stat at:j1.
						[h2 =qo] whileFalse:[
						vc:=vc,h2 asString.
						j1:=j1+1.
						h2:=content_stat at: j1.
						]
					].
				   h='likeCount'
					ifTrue: [ lc:=''.
						j1:=i1+13.
						h2:=content_stat at:j1.
						[h2 =qo] whileFalse:[
						lc:=lc,h2 asString.
						j1:=j1+1.
						h2:=content_stat at: j1.
						]
					].
				h:= content_stat copyFrom: i1 to: i1+11.
					h='commentCount'
					ifTrue: [ cc:=''.
						j1:=i1+16.
						h2:=content_stat at:j1.
						[h2 =qo] whileFalse:[
						cc:=cc,h2 asString.
						j1:=j1+1.
						h2:=content_stat at: j1.
						]
					].
				]
	         	  
		      
		
		].
		
	h:= content copyFrom: i to: i+4.
	h='title'
	ifTrue: [ v_title:=''.
		j:=i+9.
		h2:=content at:j.
		[h2 =qo] whileFalse:[
		v_title:=v_title,h2 asString.
		j:=j+1.
		h2:=content at: j.
		]
		].
	
	h:= content copyFrom: i to: i+10.
	h='publishTime'
	ifTrue: [ v_date:= content copyFrom: i+15 to: i+24.
		ind:=ind+1.
		DataFrameUpdate dataframe:df 
		                index: ind 
		                video_id:v_id 
		            		 video_title:v_title 
				          video_date:v_date 
				          vid_v:vc 
				          vid_l:lc 
				          vid_c:cc.
		].
	
 ] .
]

{ #category : #'as yet unclassified' }
DataFrameUpdate class >> dataframe:df index: ind video_id:v_id video_title:v_title video_date:v_date vid_v:vc vid_l:lc vid_c:cc [
	"Updates DataFrame"

	   df at: ind at:1  put: v_id. 
		df at: ind at:2  put: v_title.
		df at: ind at:3  put: v_date.
		df at: ind at:4  put: vc.
		df at: ind at:5  put: lc.
		df at: ind at:6  put: cc.
]
