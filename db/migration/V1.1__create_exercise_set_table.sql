-- Create Exercise Set Table

create table exercise_sets
  ( 
     ex_set_id uuid  not null, 
     ex_rec_id uuid  references exercise_records(ex_rec_id), 
     weight          integer not null default 0, 
     reps            integer not null default 0, 
     primary key(ex_set_id) 
  );