Dynamic event for dayz epoch developer by Mig.</br>

Updated 24.10.2018 and remove multiples bugs and errors.

![alt text](https://github.com/MigSDev5/TheFugitive_event/blob/master/thefugitive.png)

<b>** INSTALLATION **</br>
  - Download the archive.</br>
  
  - Place the file the_fugitive_event.sqf in your modules folder (dayz_server\modules).</br>
  - Find this line:</br>
  
        EpochEvents = [["any","any","any","any",30,"crash_spawner"],["any","any","any","any",0,"crash_spawner"],["any","any","any","any",15,"supply_drop"]];
     
   change to this:<br/>
   
      EpochEvents = [["any","any","any","any",40,"the_fugitive_event"],["any","any","any","any",30,"crash_spawner"],["any","any","any","any",0,"crash_spawner"],["any","any","any","any",15,"supply_drop"]];
      
   done
   
   The Fugitive is an event for Dayz Epoch,</br> 
   
   it takes place in several stages:</br>
   1 The event starts an Ai appeared in a marker and begins to move on the map.</br>
   2 Ai received weapon</br>
   3 AI received a simple vehicle.</br>
   4 Ai received a armed vehicle.</br>
   4 AI received reinforcement.</br>
   
   You can configure various options.
