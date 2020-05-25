-- Create Exercise Record Table

create table exercise_records
  ( 
     ex_rec_id    uuid not null, 
     ex_name      text not null, 
     ex_id        serial not null, 
     workout_id   uuid not null, 
     user_id      text not null, 
     created_date timestamptz not null, 
     primary key(ex_rec_id) 
  ); 