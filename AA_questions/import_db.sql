PRAGMA foreign_keys = ON;

DROP TABLE if exists question_likes;
DROP TABLE if exists replies;
DROP TABLE if exists question_follows;
DROP TABLE if exists questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body VARCHAR(255) NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body VARCHAR(255) NOT NULL,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  parent_reply_id INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  liked BOOLEAN,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Angel', 'Reyes'),
  ('Nikolas', 'Moyseos'),
  ('Brad', 'Pitt');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('Assignment', 'What is an Assignment?', (SELECT id FROM users WHERE lname = 'Reyes')),
  ('Question', 'What are we doing?', (SELECT id FROM users WHERE lname = 'Moyseos'));

INSERT INTO
  question_follows (user_id, question_id) 
VALUES
  ((SELECT id FROM users WHERE lname = 'Reyes'),  
    (SELECT id FROM questions WHERE user_id = (SELECT id FROM users WHERE lname = 'Reyes'))),
  ((SELECT id FROM users WHERE lname = 'Reyes'),  
    (SELECT id FROM questions WHERE user_id = (SELECT id FROM users WHERE lname = 'Moyseos'))),
  ((SELECT id FROM users WHERE lname = 'Moyseos'),  
    (SELECT id FROM questions WHERE user_id = (SELECT id FROM users WHERE lname = 'Moyseos')));

INSERT INTO
  replies (body, question_id, user_id, parent_reply_id) 
VALUES
  ('An assignment is when you are tested on your understanding of the days material', 
    (SELECT id FROM questions WHERE user_id = (SELECT id FROM users WHERE lname = 'Reyes')), 
    (SELECT id FROM users WHERE lname = 'Reyes'), NULL),
  ('I am chillin', 
    (SELECT id FROM questions WHERE user_id = (SELECT id FROM users WHERE lname = 'Moyseos')), 
    (SELECT id FROM users WHERE lname = 'Pitt'), NULL);

INSERT INTO
  replies (body, question_id, user_id, parent_reply_id) 
VALUES
  ('No, and assignment is where you excel', 
    (SELECT id FROM questions WHERE id = 1), 
    (SELECT id FROM users WHERE lname = 'Moyseos'), 
    (SELECT id FROM replies WHERE body = 'An assignment is when you are tested on your understanding of the days material'));

INSERT INTO
  question_likes (liked, question_id, user_id)
VALUES
  (true, (SELECT id FROM questions WHERE user_id = (SELECT id FROM users WHERE lname = 'Reyes')),
    (SELECT id FROM users WHERE lname = 'Reyes')),
  (false, (SELECT id FROM questions WHERE user_id = (SELECT id FROM users WHERE lname = 'Moyseos')), 
    (SELECT id FROM users WHERE lname = 'Moyseos'));