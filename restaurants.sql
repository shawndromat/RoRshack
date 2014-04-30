CREATE TABLE restaurants (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  chef_id INTEGER NOT NULL,

  FOREIGN KEY(chef_id) REFERENCES users(id)
);

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE reservations (
  id INTEGER PRIMARY KEY,
  restaurant_id INTEGER NOT NULL REFERENCES restaurants(id),
  user_id INTEGER NOT NULL REFERENCES users(id)
);


INSERT INTO
  users (fname, lname)
VALUES
  ("Thomas", "Keller"), ("Shawna", "M"), ("David", "Chang");

INSERT INTO
  restaurants (name, chef_id)
VALUES
  ("The French Laundry", 1), ("Momofuku", 3), ("Momofuku Milk Bar", 3);
  
INSERT INTO
  reservations (restaurant_id, user_id)
VALUES
  (2, 2), (3, 2), (1, 3), (3, 1);
