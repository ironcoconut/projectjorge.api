CREATE EXTENSION "uuid-ossp";

CREATE TABLE users
(
  user_id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  email varchar(255) UNIQUE,
  name varchar(255),
  hash varchar(255),
  recovery_hash varchar(255),
  created_at timestamp,
  updated_at timestamp
);

CREATE TABLE charities
(
  charity_id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  name varchar(255),
  slug varchar(255) UNIQUE,
  subtitle varchar(255),
  summary varchar(255),
  content text,
  media_url varchar(255),
  created_at timestamp,
  updated_at timestamp
);

CREATE TABLE volunteers
(
  volunteer_id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  user_id uuid REFERENCES users,
  charity_id uuid REFERENCES charities,
  admin boolean,
  member boolean,
  created_at timestamp,
  updated_at timestamp
);

CREATE TABLE donees
(
  volunteer_id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  user_id uuid REFERENCES users,
  charity_id uuid REFERENCES charities,
  raised money,
  goal money,
  created_at timestamp,
  updated_at timestamp
);
