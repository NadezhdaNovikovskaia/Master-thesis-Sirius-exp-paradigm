response_matching = simple_matching;
active_buttons = 1;
button_codes = 1;
default_font_size = 27;  #font size
default_background_color = 125, 125, 125;   #background color in RGB format , max 255
default_text_color = 0, 0, 0;    # text color in RGB format
default_font = "Arial";    # font Times New Roman
response_port_output = false;
response_logging = log_active;

write_codes=true; #this is for allowing triggering

begin;
#instruction screen
trial {
   trial_duration = forever;      #time to present the instruction
   trial_type = first_response;
   stimulus_event {
      picture {
         text { caption = "Press the button"; } instruction;
         x = 0; y = 0;
       
      };
      response_active = true;
      
   };
} instruction_trial;
# end of instruction screen
#resting screen
trial {
   trial_duration = forever;      #time to present the instruction
   trial_type = first_response;
   stimulus_event {
      picture {
         text { caption = "Press the button"; } resting;
         x = 0; y = 0;
       
      };
      response_active = true;
      
   };
} resting_trial;
# end of resting screen

# blank screen
trial {
   
   trial_duration = 300;      #time to present the blank screen between words in ms
   trial_type = first_response;
   stimulus_event {
   
      picture {
         text { caption = " "; } blank;
         x = 0; y = 0;
       
      };
   } blank_stim;
} blank_trial;
# end of blank screen
trial {
   stimulus_event {
		nothing {};    
   } empty_stim;
} trial_for_info;
# word trial
trial {
	trial_duration = 500; # !!!!!!!!!!!!!!!!!!!!!!!!!!time to present the single word in ms
start_delay = 100;   
stimulus_event {
	picture {
		text { caption = "Hello"; 
      #font_size = 24; 
      }my_text;
		x = 0; y = 0;
	} my_picture;
	port_code = 1; #ower trigger
	} my_stimul1;
} trial1;    #trial to present single word
#end of word trial

trial {
   trial_duration = 5000; #time to present the sentence - 5sec
   trial_type = first_response;
   stimulus_event {
      picture {
         text { caption = "Для продолжения нажмите пробел"; } scentence;
         x = 0; y = 0;
       
      }scentence_pic;
      response_active = true;
      
   };
} scentence_trial;  #trial to present whole scentence with possibility to cancel it by pressing space button

#cross
trial {
   #font_size = 33;
   trial_duration = 1000; #time to present the cross
   
   stimulus_event {
      picture {
         text { caption = "+"; } cross;
         x = 0; y = 0;
       
      };
      #response_active = true;
      
   };
} cross_trial;
#end of cross trial


begin_pcl;
int last_word=8; 
int single_cross_duration=500; #duration of single cross
int triple_cross_duration=2000; #duration of triple cross
int traning_block=0;  #end of training session
int block_amount=16;
int brake_block=8;
int neutral_port_code=0;
int my_port_code=0;
array<string> strings2[0][0]; #scenteces 
array<string> temps[0]; #temporal string array
array<string> words[0];
array <int> trialsN[0];
array<int> ids[0];
array<int> words_ids[0];
array<int> word_id_relation[0];
array<int> block_id_relation[0];
array<int> types[0];    #types
string info;             # Accumulate information about trials
string tab = "	";        #tab
string new_string = "\n";#new string 
string filename2 = logfile.subject() + "_additional" + ".log"; #output file name
# read scentences
input_file f = new input_file;
# function read Text from File
sub string readTxtFile ( string filename, input_file fl )
begin
	string txt="";
   fl.open( filename );
   loop until
   fl.end_of_file() 
   begin
     txt=txt+f.get_string()+" ";
   end;
   fl.close();
   return txt;
end;
# end reading text from file
sub putTextToText(string txt, text t)
begin
	t.set_caption(txt);
   t.set_max_text_width(1000);
   t.redraw();
end;

sub string getLastWordForBlockByWordId(int word_id)
begin
	string word = "";

	int counter = 1;
	loop until counter>words_ids.count() || words_ids[counter]==word_id 
	begin
		counter=counter+1;
	end;
	word = words[counter];
	return word;
end;


#showing phrase
sub showingPhrase(int phraseID, string last_word_text, int word_id, int blockID)
begin
	putTextToText("+",cross); cross_trial.set_duration(single_cross_duration);cross_trial.set_start_delay(1);
cross_trial.present();
	loop int j=1;
	until j>last_word 
	begin
		 my_port_code=neutral_port_code;
       if j==last_word then
		   my_text.set_caption(last_word_text);
         my_text.redraw();
		   term.print_line(last_word_text);
			if(blockID > 8 && blockID <= 16) then
				my_port_code = 251;
			end;
			if(blockID >= 1 && blockID <= 8) then
				my_port_code = 250;
			end;
       end;
       if j<last_word then
		   my_text.set_caption(strings2[phraseID][j]);
         my_text.redraw();
			term.print_line(strings2[phraseID][j]);
	      my_port_code=240+j;
       end;
       my_stimul1.set_port_code( my_port_code);
       
       term.print_line( my_port_code);
		trial1.set_start_delay(100);
      trial1.present();                    # presenting the word
		blank_stim.set_port_code(0);
		blank_trial.set_duration(300);
		if j==last_word then
			blank_stim.set_port_code(blockID);
			blank_trial.set_duration(100);
			blank_trial.present();
			blank_stim.set_port_code(word_id);
			blank_trial.set_duration(100);
			blank_trial.present();
			blank_stim.set_port_code(ids[phraseID]);
			blank_trial.set_duration(100);
		end;
       blank_trial.present();               # presenting the blank screen
	
      if j==last_word then
			 string txt="";
			 loop int k=1;
			 until k>last_word-1 begin
				 txt=txt+strings2[phraseID][k]+" ";
				 k=k+1;
			 end;
			 txt= txt+ last_word_text;
			 scentence.set_caption(txt);
			 scentence.redraw();
			 scentence_trial.present(); # presenting the scentence
			#RT
			 stimulus_data last = stimulus_manager.last_stimulus_data();
			 int reaction_time =  last.reaction_time();
			 term.print_line("RT: "+string(reaction_time));
			 info.append(string(my_port_code)+tab+string(blockID)+tab+string(word_id)+tab+string(ids[phraseID])+tab+string(reaction_time) + new_string);
			#end RT
			#if count5 != 5 then cross_trial.present(); end; # presenting the cross		
      end;
       j=j+1;
       
	end;
end;
#end shoing phrase

#showing block
sub showingBlock(int blockID)
begin
	int first=1;
	loop until first>types.count() || types[first]==blockID 
	begin
		first=first+1;
	end;
	int counter=1;
	loop until counter>block_id_relation.count() || block_id_relation[counter]==blockID 
	begin
		counter=counter+1;
	end;
	int word_id = word_id_relation[counter];
	string last_word_text = getLastWordForBlockByWordId(word_id);
	showingPhrase(first, last_word_text, word_id, blockID);
	showingPhrase(first+1, last_word_text, word_id, blockID);	
	showingPhrase(first+2, last_word_text, word_id, blockID);
	showingPhrase(first+3, last_word_text, word_id, blockID);
	showingPhrase(first+4, last_word_text, word_id, blockID);
	putTextToText("+++",cross);
	cross_trial.set_duration(triple_cross_duration);
	cross_trial.present();
end;
#end showing block


#reading the phrases file
f.open( "phrases training.txt" );
f.set_delimiter( '\t' );
int count = 1;
loop until
   f.end_of_file() 
begin
   if f.end_of_file() then break;
   end;
   
   if count==1 then ids.add(f.get_int()); types.add(f.get_int());
   end;
   if count>1 then temps.add(f.get_string());
   end;
		count = count + 1;
		if count>last_word then
		strings2.add(temps);
		temps.resize(0);
		count=1;
	end;
end;
f.close();

#reading words
f.open( "words training.txt" );
f.set_delimiter( '\t' );
loop until
   f.end_of_file() 
begin
   if f.end_of_file() then break;
   end;
	words.add(f.get_string());
	words_ids.add(f.get_int());
end;
f.close();


#reading words - block relations
f.open( "Generated.txt" );
f.set_delimiter( '\t' );
loop until
   f.end_of_file() 
begin
   if f.end_of_file() then break;
   end; 
	word_id_relation.add(f.get_int());
	block_id_relation.add(f.get_int());
end;
f.close();
term.print_line(word_id_relation);
term.print_line(block_id_relation);
#making random types array and add words to phrase
array<int> block_type[block_amount];
loop int k=1; until k>block_amount 
begin 
	block_type[k]=k; k=k+1;
end;
block_type.shuffle();

#showing the instruction
putTextToText(readTxtFile("instruction.txt",f), instruction);
instruction_trial.present();
putTextToText(readTxtFile("instruction2.txt",f), resting);

#showing phrases


loop int i=1;
until i>block_amount #|| i>2
begin
showingBlock(block_type[i]);	
if i==brake_block then putTextToText(readTxtFile("instruction3.txt",f), resting); resting_trial.present(); end;
i=i+1;
	
end;

#saving log file
# recording info to the output file
output_file file = new output_file;
file.open(filename2, true);
string information = "NAME: " + tab + logfile.subject() + new_string;
information.append("abs"+tab+"sem"+tab+"id"+tab+"sent"+tab+"RT"+new_string);
information.append(info);
file.print(information);
file.close();