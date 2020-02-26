pcl_file = "DefinitionChoose.pcl";
response_matching = simple_matching;
active_buttons = 4;
button_codes = 1,2,3,4;
default_font_size = 27;
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
 picture {
         text { caption = "+"; } cross;
         x = 0; y = 0;
       
      }cross_pic;
trial {
   trial_duration = forever; #time to present the sentence - 5sec
   trial_type = first_response;

   stimulus_event {
      picture {
         text { caption = "Press the button"; } word;
         x = 0; y = 0;
       
      }word_pic;
      response_active = true;
      
   }word_st;
   #picture cross_pic;
   #time = 600;
} word_trial;  #trial to present whole scentence with possibility to cancel it by pressing space button
#end of word trial