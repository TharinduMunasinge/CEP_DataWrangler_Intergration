/*
* Created by Chathuranga on 17/01/2015
*/

var string_val= ["Alpha", "Bravo", "Charlie", "Delta", "Echo",
		 "Foxtrot", "Golf", "Hotel", "India", "Juliet",
		 "Kilo", "Lima", "Mike", "November", "Oscar", "Papa", 
		 "Quebec", "Romeo", "Sierra", "Tango", "Uniform",
		 "Victor", "Whiskey", "X-ray", "Yankee", "Zulu"]; // 26 Strings

var int_val = [57, 23, 100, 12, 34, 91, 0, -1, 16, -25, 
		1, 3, 8, 17, 19, 75, 87, 1001, 101, 203, 
	       49, 63, 547, 281, 99, -23, -100, -78, -12, -566]; // 30 numbers

var float_val = [21.2, 10.0, 22.5, 101.4, 11.1, 9.8, 0.2, -23.5, 5.6, -0.7,  
		 49.6, 103.1, 0.1, 99.8, -34.1, -66.0, 49.0, 100.0, 100.9, 118.7, 
		705.8, 111.3, 0.9, 4.4, 3.3, 4.6, -10.9, 77.2, -89.6, 69.6]; // 30 numbers

var double_val = [21.2, 10.0, 22.5, 101.4, 11.1, 9.8, 0.2, -23.5, 5.6, -0.7,  
		  49.6, 103.1, 0.1, 99.8, -34.1, -66.0, 49.0, 100.0, 100.9, 118.7, 
		 705.8, 111.3, 0.9, 4.4, 3.3, 4.6, -10.9, 77.2, -89.6, 69.6]; // 30 numbers

var long_val =  [57, 23, 100, 12, 34, 91, 0, -1, 16, -25, 
		  1, 3, 8, 17, 19, 75, 87, 1001, 101, 203, 
	         49, 63, 547, 281, 99, -23, -100, -78, -12, -566]; // 30 numbers

var bool_val = ["false", "true"]; 
	
var text="";
var def_prompt="";
var inputArea = dw.jq('textArea').attr('id','wranglerInput');
var single=true; // controlled by 'option' radio button on wrangler.html
var stream=["empty"];

function getSample(stream_def){
	text="";
	
	if(stream[0]==="empty"){
		inputArea.attr('value', "Not selcted a valid input stream");
		return null;
	}

	stream=stream_def;
	var rand=0;
	var events=1;
	if(!single)
		events=5;
		
	for(k=0; k<events; k++){
		if(k!=0)
			text += "\n";	
		for(i=0; i<stream_def.length; i++){
			
			rand=Math.floor(Math.random()*26)
			if(stream_def[i]==="STRING"){
				text += string_val[rand];
				if(i != stream_def.length -1){
					text += ",";
				}
			}
	
			rand=Math.floor(Math.random()*30)
			if(stream_def[i]==="INT"){
				text += int_val[rand];
				if(i != stream_def.length -1){
					text += ",";
				}
			}

			rand=Math.floor(Math.random()*30)
			if(stream_def[i]==="FLOAT"){
				text += float_val[rand];
				if(i != stream_def.length -1){
					text += ",";
				}
			}

			rand=Math.floor(Math.random()*30)
			if(stream_def[i]==="LONG"){
				text += long_val[rand];
				if(i != stream_def.length -1){
					text += ",";
				}
			}

			rand=Math.floor(Math.random()*30)
			if(stream_def[i]==="DOUBLE"){
				text += double_val[rand];
				if(i != stream_def.length -1){
					text += ",";
				}
			}

			rand=Math.floor(Math.random()*2)
			if(stream_def[i]==="BOOL"){
				text += bool_val[rand];
				if(i != stream_def.length -1){
					text += ",";
				}
			}
		}

		
	}
	inputArea.attr('value', text);
	return text;
}

function getStreamDef(list){
	def_prompt = "Input Stream Format: [ ";
	for(i=0; i<list.length; i++){
		def_prompt += list[i];
		if(i != list.length-1)
			def_prompt += " , ";
	}
	def_prompt += " ]";
}
