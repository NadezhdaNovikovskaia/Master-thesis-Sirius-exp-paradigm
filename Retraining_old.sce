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
   start_delay = 7;
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
   start_delay = 7;
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
   
   trial_duration = 208;      #time to present the blank screen between words in ms
   trial_type = first_response;
   start_delay = 100;
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
	trial_duration = 501; # !!!!!!!!!!!!!!!!!!!!!!!!!!time to present the single word in ms
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
start_delay = 7;
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
   start_delay = 7;
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
int single_cross_duration=492; #duration of single cross
int triple_cross_duration=2000; #duration of triple cross
int traning_block=0;  #end of training session
int block_amount=16;
int brake_block=8;
int neutral_port_code=0;
int my_port_code=0;
array<string> strings2[0][0]; #scenteces 
array<string> strings_temp[0][0]; #scenteces 
array<string> temps[0]; #temporal string array
array<string> words[0];
array <int> trialsN[0];
array <int> relearning_type[0];
array<int> ids[0];
array<int> ids_temp[0];
array<int> words_ids[0];
array<int> word_id_relation[0];
array<int> block_id_relation[0];
array<int> types[0];    #types
array<int> types_temp[0];    #types
string info;             # Accumulate information about trials
string tab = "	";        #tab
string space = " "; 
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
	     my_port_code=blockID;
       end;
       if j<last_word then
		   my_text.set_caption(strings2[phraseID][j]);
         my_text.redraw();
			term.print_line(strings2[phraseID][j]);
	      my_port_code=240+j;
			blank_stim.set_port_code(0);
        end;
       if types[phraseID]==0 then
	     my_port_code=0;
	    end;
       my_stimul1.set_port_code( my_port_code);
       
       term.print_line( my_port_code);
		if(j==last_word)then
			empty_stim.set_port_code(word_id);
			trial_for_info.present();
		end;
		trial1.set_start_delay(100);
       trial1.present();                    # presenting the word
		if(j==last_word)then
			blank_stim.set_port_code(ids[phraseID]);
		end;
       blank_trial.present();               # presenting the blank screen
	
      if j==last_word then
			 empty_stim.set_port_code(relearning_type[phraseID]);
			 trial_for_info.present();
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
			 info.append(string(phraseID)+tab+string(reaction_time) + new_string);
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

#determined phrases
#making random types array
array<int> block_type_determined[brake_block];
loop int k=1; until k>brake_block 
begin 
	block_type_determined[k]=k; k=k+1;
end;
block_type_determined.shuffle();
#reading the phrases file
f.open( "201_learning_determined.txt" );
f.set_delimiter( '\t' );
int count = 1;
loop until
   f.end_of_file() 
begin
   if f.end_of_file() then break;
   end;
   
   if count==1 then ids_temp.add(f.get_int()); types_temp.add(f.get_int());
   end;
   if count>1 then temps.add(f.get_string());
   end;
		count = count + 1;
		if count>last_word then
		strings_temp.add(temps);
		temps.resize(0);
		count=1;
	end;
end;
f.close();
int first=1;
loop until first>types_temp.count() || types_temp[first]==block_type_determined[1] 
begin
	first=first+1;
end;
int counter = 0;
loop until counter > 4
begin
	strings2.add(strings_temp[first+counter]);
	ids.add(ids_temp[first+counter]);
	types.add(types_temp[first+counter]);
	relearning_type.add(201);
	counter = counter + 1;
end;
first=1;
loop until first>types_temp.count() || types_temp[first]==block_type_determined[2] 
begin
	first=first+1;
end;
counter = 0;
loop until counter > 4
begin
	strings2.add(strings_temp[first+counter]);
	ids.add(ids_temp[first+counter]);
	types.add(types_temp[first+counter]);
	relearning_type.add(201);
	counter = counter + 1;
end;

ids_temp.resize(0);
types_temp.resize(0);
strings_temp.resize(0);

#reading the phrases file
f.open( "203_clarification_determined.txt" );
f.set_delimiter( '\t' );
count = 1;
loop until
   f.end_of_file() 
begin
   if f.end_of_file() then break;
   end;
   
   if count==1 then ids_temp.add(f.get_int()); types_temp.add(f.get_int());
   end;
   if count>1 then temps.add(f.get_string());
   end;
		count = count + 1;
		if count>last_word then
		strings_temp.add(temps);
		temps.resize(0);
		count=1;
	end;
end;
f.close();
first=1;
loop until first>types_temp.count() || types_temp[first]==block_type_determined[3] 
begin
	first=first+1;
end;
counter = 0;
loop until counter > 4
begin
	strings2.add(strings_temp[first+counter]);
	ids.add(ids_temp[first+counter]);
	types.add(types_temp[first+counter]);
	relearning_type.add(203);
	counter = counter + 1;
end;
first=1;
loop until first>types_temp.count() || types_temp[first]==block_type_determined[4] 
begin
	first=first+1;
end;
counter = 0;
loop until counter > 4
begin
	strings2.add(strings_temp[first+counter]);
	ids.add(ids_temp[first+counter]);
	types.add(types_temp[first+counter]);
	relearning_type.add(203);
	counter = counter + 1;
end;

ids_temp.resize(0);
types_temp.resize(0);
strings_temp.resize(0);

#reading the phrases file
f.open( "205_generalization_determined.txt" );
f.set_delimiter( '\t' );
count = 1;
loop until
   f.end_of_file() 
begin
   if f.end_of_file() then break;
   end;
   
   if count==1 then ids_temp.add(f.get_int()); types_temp.add(f.get_int());
   end;
   if count>1 then temps.add(f.get_string());
   end;
		count = count + 1;
		if count>last_word then
		strings_temp.add(temps);
		temps.resize(0);
		count=1;
	end;
end;
f.close();
first=1;
loop until first>types_temp.count() || types_temp[first]==block_type_determined[5] 
begin
	first=first+1;
end;
counter = 0;
loop until counter > 4
begin
	strings2.add(strings_temp[first+counter]);
	ids.add(ids_temp[first+counter]);
	types.add(types_temp[first+counter]);
	relearning_type.add(205);
	counter = counter + 1;
end;
first=1;
loop until first>types_temp.count() || types_temp[first]==block_type_determined[6] 
begin
	first=first+1;
end;
counter = 0;
loop until counter > 4
begin
	strings2.add(strings_temp[first+counter]);
	ids.add(ids_temp[first+counter]);
	types.add(types_temp[first+counter]);
	relearning_type.add(205);
	counter = counter + 1;
end;

ids_temp.resize(0);
types_temp.resize(0);
strings_temp.resize(0);

#reading the phrases file
f.open( "207_destruction_determined.txt" );
f.set_delimiter( '\t' );
count = 1;
loop until
   f.end_of_file() 
begin
   if f.end_of_file() then break;
   end;
   
   if count==1 then ids_temp.add(f.get_int()); types_temp.add(f.get_int());
   end;
   if count>1 then temps.add(f.get_string());
   end;
		count = count + 1;
		if count>last_word then
		strings_temp.add(temps);
		temps.resize(0);
		count=1;
	end;
end;
f.close();
first=1;
loop until first>types_temp.count() || types_temp[first]==block_type_determined[7] 
begin
	first=first+1;
end;
counter = 0;
loop until counter > 4
begin
	strings2.add(strings_temp[first+counter]);
	ids.add(ids_temp[first+counter]);
	types.add(types_temp[first+counter]);
	relearning_type.add(207);
	counter = counter + 1;
end;
first=1;
loop until first>types_temp.count() || types_temp[first]==block_type_determined[8] 
begin
	first=first+1;
end;
counter = 0;
loop until counter > 4
begin
	strings2.add(strings_temp[first+counter]);
	ids.add(ids_temp[first+counter]);
	types.add(types_temp[first+counter]);
	relearning_type.add(207);
	counter = counter + 1;
end;

ids_temp.resize(0);
types_temp.resize(0);
strings_temp.resize(0);

#abstract phrases
#making random types array
array<int> block_type_abstract[brake_block];
loop int k=9; until k>brake_block*2 
begin 
	block_type_abstract[k-8]=k; k=k+1;
end;
block_type_abstract.shuffle();
#reading the phrases file
f.open( "202_learning_abstract.txt" );
f.set_delimiter( '\t' );
count = 1;
loop until
   f.end_of_file() 
begin
   if f.end_of_file() then break;
   end;
   
   if count==1 then ids_temp.add(f.get_int()); types_temp.add(f.get_int());
   end;
   if count>1 then temps.add(f.get_string());
   end;
		count = count + 1;
		if count>last_word then
		strings_temp.add(temps);
		temps.resize(0);
		count=1;
	end;
end;
f.close();
first=1;
loop until first>types_temp.count() || types_temp[first]==block_type_abstract[1] 
begin
	first=first+1;
end;
counter = 0;
loop until counter > 4
begin
	strings2.add(strings_temp[first+counter]);
	ids.add(ids_temp[first+counter]);
	types.add(types_temp[first+counter]);
	relearning_type.add(202);
	counter = counter + 1;
end;
first=1;
loop until first>types_temp.count() || types_temp[first]==block_type_abstract[2] 
begin
	first=first+1;
end;
counter = 0;
loop until counter > 4
begin
	strings2.add(strings_temp[first+counter]);
	ids.add(ids_temp[first+counter]);
	types.add(types_temp[first+counter]);
	relearning_type.add(202);
	counter = counter + 1;
end;

ids_temp.resize(0);
types_temp.resize(0);
strings_temp.resize(0);

#reading the phrases file
f.open( "204_clarification_abstract.txt" );
f.set_delimiter( '\t' );
count = 1;
loop until
   f.end_of_file() 
begin
   if f.end_of_file() then break;
   end;
   
   if count==1 then ids_temp.add(f.get_int()); types_temp.add(f.get_int());
   end;
   if count>1 then temps.add(f.get_string());
   end;
		count = count + 1;
		if count>last_word then
		strings_temp.add(temps);
		temps.resize(0);
		count=1;
	end;
end;
f.close();
first=1;
loop until first>types_temp.count() || types_temp[first]==block_type_abstract[3] 
begin
	first=first+1;
end;
counter = 0;
loop until counter > 4
begin
	strings2.add(strings_temp[first+counter]);
	ids.add(ids_temp[first+counter]);
	types.add(types_temp[first+counter]);
	relearning_type.add(204);
	counter = counter + 1;
end;
first=1;
loop until first>types_temp.count() || types_temp[first]==block_type_abstract[4] 
begin
	first=first+1;
end;
counter = 0;
loop until counter > 4
begin
	strings2.add(strings_temp[first+counter]);
	ids.add(ids_temp[first+counter]);
	types.add(types_temp[first+counter]);
	relearning_type.add(204);
	counter = counter + 1;
end;

ids_temp.resize(0);
types_temp.resize(0);
strings_temp.resize(0);

#reading the phrases file
f.open( "206_generalization_abstract.txt" );
f.set_delimiter( '\t' );
count = 1;
loop until
   f.end_of_file() 
begin
   if f.end_of_file() then break;
   end;
   
   if count==1 then ids_temp.add(f.get_int()); types_temp.add(f.get_int());
   end;
   if count>1 then temps.add(f.get_string());
   end;
		count = count + 1;
		if count>last_word then
		strings_temp.add(temps);
		temps.resize(0);
		count=1;
	end;
end;
f.close();
first=1;
loop until first>types_temp.count() || types_temp[first]==block_type_abstract[5] 
begin
	first=first+1;
end;
counter = 0;
loop until counter > 4
begin
	strings2.add(strings_temp[first+counter]);
	ids.add(ids_temp[first+counter]);
	types.add(types_temp[first+counter]);
	relearning_type.add(206);
	counter = counter + 1;
end;
first=1;
loop until first>types_temp.count() || types_temp[first]==block_type_abstract[6] 
begin
	first=first+1;
end;
counter = 0;
loop until counter > 4
begin
	strings2.add(strings_temp[first+counter]);
	ids.add(ids_temp[first+counter]);
	types.add(types_temp[first+counter]);
	relearning_type.add(206);
	counter = counter + 1;
end;

ids_temp.resize(0);
types_temp.resize(0);
strings_temp.resize(0);

#reading the phrases file
f.open( "208_destruction_abstract.txt" );
f.set_delimiter( '\t' );
count = 1;
loop until
   f.end_of_file() 
begin
   if f.end_of_file() then break;
   end;
   
   if count==1 then ids_temp.add(f.get_int()); types_temp.add(f.get_int());
   end;
   if count>1 then temps.add(f.get_string());
   end;
		count = count + 1;
		if count>last_word then
		strings_temp.add(temps);
		temps.resize(0);
		count=1;
	end;
end;
f.close();
first=1;
loop until first>types_temp.count() || types_temp[first]==block_type_abstract[7] 
begin
	first=first+1;
end;
counter = 0;
loop until counter > 4
begin
	strings2.add(strings_temp[first+counter]);
	ids.add(ids_temp[first+counter]);
	types.add(types_temp[first+counter]);
	relearning_type.add(208);
	counter = counter + 1;
end;
first=1;
loop until first>types_temp.count() || types_temp[first]==block_type_abstract[8] 
begin
	first=first+1;
end;
counter = 0;
loop until counter > 4
begin
	strings2.add(strings_temp[first+counter]);
	ids.add(ids_temp[first+counter]);
	types.add(types_temp[first+counter]);
	relearning_type.add(208);
	counter = counter + 1;
end;

ids_temp.resize(0);
types_temp.resize(0);
strings_temp.resize(0);


#reading words
f.open( "words.txt" );
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
f.open( "Generated8.txt" );
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

#making random types array
array<int> block_type[block_amount];
loop int k=1; until k>block_amount 
begin 
	block_type[k]=k; k=k+1;
end;
block_type.shuffle();

term.print_line(strings2);
term.print_line(ids);
term.print_line(types);
term.print_line(relearning_type);

output_file file_relearning = new output_file;
file_relearning.open("Relearning_type_block_relation.txt", true);
string out = "";
counter = 1;
loop until counter > types.count()
begin
	out.append(string(relearning_type[counter])+space+string(types[counter])+new_string);
	counter = counter + 5;
end;
file_relearning.print(out);
file_relearning.close();

#showing the instruction
putTextToText(readTxtFile("instruction.txt",f), instruction);
instruction_trial.present();

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
information.append("id"+tab+"RT"+new_string);
information.append(info);
file.print(information);
file.close();