-- Create User Table

create table users 
  ( 
     user_name  text not null, 
     email      text not null, 
     password   text not null, 
     first_name text, 
     last_name  text, 
     age        integer, 
     primary key(user_name) 
  ); 