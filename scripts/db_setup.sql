CREATE EXTENSION "uuid-ossp";

CREATE TABLE users
(
  id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  email varchar(255) UNIQUE,
  handle varchar(255) UNIQUE,
  phone varchar(255) UNIQUE,
  password_hash varchar(255),
  recovery_hash varchar(255),
  prefer_email boolean,
  prefer_phone boolean,
  avatar varchar(255),
  contact_frequency varchar(255),
  created_at timestamp,
  updated_at timestamp
);

CREATE TABLE events
(
  id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  name varchar(255),
  avatar varchar(255),
  description text,
  location varchar(255),
  degrees int,
  starts_at timestamp,
  ends_at timestamp,
  created_at timestamp,
  updated_at timestamp
);

CREATE TABLE rsvps
(
  id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  castor_id uuid REFERENCES users,
  pollux_id uuid REFERENCES users,
  event_id uuid REFERENCES events,
  accepted boolean,
  declined boolean,
  admin boolean,
  created_at timestamp,
  updated_at timestamp
);
