pcl_file = "LexicalDesicion.pcl";
response_matching = simple_matching;
active_buttons = 2;
button_codes = 1,2;
default_font_size = 24;
default_background_color = 125, 125, 125;
default_text_color =  0, 0, 0;  
default_font = "Arial";    # font Times New Roman
write_codes=true; #this is for allowing triggering
response_port_output = false;
begin;
#instruction
trial {
   trial_duration = 100000; #time to present the instruction
   trial_type = first_response;

   stimulus_event {
      picture {
         text { caption = "+"; } instruction;
         x = 0; y = 0;
       
      };
      response_active = true;
      
   };
} instruction_trial;

#word
trial {
   trial_duration = 600; 
   trial_type = fixed ;

   stimulus_event {
      picture {
         text { caption = "Press the button"; } word;
         x = 0; y = 0;
       
      }word_pic;
      response_active = true;
     port_code = 1; #ower trigger 
   }word_st;
} word_trial;  #trial to present whole scentence with possibility to cancel it by pressing space button
#end of word trial
#cross
trial {
   #font_size = 33;
   trial_duration = 1400; #time to present the cross
   
   stimulus_event {
      picture {
         text { caption = "+"; } cross;
         x = 0; y = 0;
       
      };
   } cross_stim;
} cross_trial;
#end of cross trial