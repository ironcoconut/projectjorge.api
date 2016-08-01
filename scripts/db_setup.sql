CREATE EXTENSION "uuid-ossp";

CREATE TABLE users
(
  user_id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
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

CREATE TABLE user_relations
(
  user_relation_id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  castor_id uuid REFERENCES users,
  pollux_id uuid REFERENCES users,
  blocked boolean,
  created_at timestamp,
  updated_at timestamp
);

CREATE TABLE user_event_templates
(
  user_event_template_id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  user_id uuid REFERENCES users,
  event_template_id uuid REFERENCES event_templates,
  admin boolean,
  blocked boolean,
  banned boolean,
  followed boolean,
  created_at timestamp,
  updated_at timestamp
);

CREATE TABLE event_templates
(
  event_template_id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  name varchar(255),
  type varchar(255) UNIQUE,
  recurring varchar(255),
  avatar varchar(255),
  degrees int,
  created_at timestamp,
  updated_at timestamp
);

CREATE TABLE events
(
  event_id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  event_template_id uuid REFERENCES event_templates,
  description text,
  location point,
  image varchar(255),
  created_at timestamp,
  updated_at timestamp
);

CREATE TABLE user_events
(
  user_event_id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  user_id uuid REFERENCES users,
  event_id uuid REFERENCES events,
  accepted boolean,
  blocked boolean,
  created_at timestamp,
  updated_at timestamp
);
