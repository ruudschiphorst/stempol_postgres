CREATE DATABASE stempol_notes;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
CREATE TABLE IF NOT EXISTS notes(id SERIAL, noteID UUID DEFAULT public.uuid_generate_v4(), title varchar(40) NOT NULL CHECK (title <> ''), note_text text, version integer, owner varchar(20), created_by varchar(20), generated_at timestamp DEFAULT now(), is_public boolean DEFAULT true, is_deleted boolean DEFAULT false, grondslag integer DEFAULT 8, autorisatieniveau numeric(2), afhandelcode integer DEFAULT 11, PRIMARY KEY (noteID, version));
CREATE TABLE IF NOT EXISTS multimedia (id SERIAL PRIMARY KEY, multimediaID UUID DEFAULT public.uuid_generate_v4() NOT NULL, title varchar(40) NOT NULL CHECK (title <> ''), filepath varchar(250), filetype varchar(40), noteID UUID NOT NULL REFERENCES notes (noteID) UNIQUE (multimediaID));
CREATE TABLE IF NOT EXISTS note_transcripts (id SERIAL PRIMARY KEY, noteID UUID NOT NULL, noteVersion integer NOT NULL, transcriptID varchar(50), transcript_text text, FOREIGN KEY (noteID, noteVersion) REFERENCES notes (noteID, version));
CREATE TABLE IF NOT EXISTS shared_notes (id SERIAL PRIMARY KEY, noteID UUID NOT NULL, noteVersion integer NOT NULL, shared_with_username varchar(20), shared_with_groupname varchar(30), FOREIGN KEY (noteID, noteVersion) REFERENCES notes (noteID, version) UNIQUE(noteID, shared_with_username, shared_with_groupname));
ALTER TABLE shared_notes ADD COLUMN is_deleted boolean DEFAULT false;
ALTER TABLE multimedia ADD COLUMN is_deleted boolean DEFAULT false;
CREATE TABLE IF NOT EXISTS roles (id SERIAL PRIMARY KEY, rolename varchar(50), may_create boolean DEFAULT false, may_read boolean DEFAULT true, may_update boolean DEFAULT false, may_delete boolean DEFAULT false);
ALTER TABLE shared_notes ADD COLUMN roleid integer REFERENCES roles(id);
CREATE TABLE IF NOT EXISTS roles (id SERIAL PRIMARY KEY, rolename varchar(50), may_create boolean DEFAULT false, may_read boolean DEFAULT true, may_update boolean DEFAULT false, may_delete boolean DEFAULT false);
ALTER TABLE shared_notes ADD COLUMN roleid integer REFERENCES roles(id);
INSERT INTO roles (rolename, may_create, may_read, may_update, may_delete) VALUES ('admin', true, true, true, true);
INSERT INTO roles (rolename, may_create, may_read, may_update, may_delete) VALUES ('reader', false, true, false, false);
INSERT INTO roles (rolename, may_create, may_read, may_update, may_delete) VALUES ('writer', true, true, true, false);

