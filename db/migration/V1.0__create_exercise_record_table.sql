-- Create Exercise Record Table

create table exercise_records
  ( 
     ex_rec_id    uuid not null, 
     ex_name      text not null, 
     ex_id        uuid not null, 
     workout_id   uuid not null, 
     user_id      text not null, 
     created_date timestamptz not null, 
     primary key(ex_rec_id) 
  ); 

create index exercise_records_ex_id_idx on exercise_records (ex_id);
create index exercise_records_ex_name_idx on exercise_records (ex_name);
create index exercise_records_workout_id_idx on exercise_records (workout_id);
create index exercise_records_user_id_idx on exercise_records (user_id);
create index exercise_records_created_date_idx on exercise_records (created_date);