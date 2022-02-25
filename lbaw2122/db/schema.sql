SET search_path TO lbaw2122;

-----------------------------------------
-- Drop Tables and Types
----------------------------------------- 

DROP TABLE IF EXISTS tag_event;
DROP TABLE IF EXISTS vote;
DROP TABLE IF EXISTS attendee;
DROP TABLE IF EXISTS event_cancelled_notification_user;
DROP TABLE IF EXISTS event_cancelled_notification;
DROP TABLE IF EXISTS transaction;
DROP TABLE IF EXISTS event_report;
DROP TABLE IF EXISTS comment_report;
DROP TABLE IF EXISTS user_report;
DROP TABLE IF EXISTS report;
DROP TABLE IF EXISTS file;
DROP TABLE IF EXISTS rating;
DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS option;
DROP TABLE IF EXISTS poll;
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS tag;
DROP TABLE IF EXISTS invite;
DROP TABLE IF EXISTS request;
DROP TABLE IF EXISTS event;
DROP TABLE IF EXISTS unblock_appeal;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS administrator;

-----------------------------------------
-- Types
-----------------------------------------

DROP TYPE IF EXISTS comment_rating CASCADE;
CREATE TYPE comment_rating AS ENUM ('Upvote', 'Downvote');

-----------------------------------------
-- Tables
-----------------------------------------

-- Note that a plural 'users' name was adopted because user is a reserved word in PostgreSQL.

CREATE TABLE administrator (
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL CONSTRAINT administrator_username_uk UNIQUE,
    password TEXT NOT NULL,
    last_login TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT administrator_last_login_check CHECK (last_login <= NOW())
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL CONSTRAINT user_username_uk UNIQUE,
    email TEXT NOT NULL CONSTRAINT user_email_uk UNIQUE CONSTRAINT user_email_check CHECK (email LIKE '%@%.%'),
    password TEXT NOT NULL,
    name TEXT NOT NULL,
    profile_pic TEXT,
    account_creation_date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT user_account_creation_date_check CHECK (account_creation_date <= NOW()),
    birthdate DATE NOT NULL,
    description TEXT,
    block_motive TEXT,
    CONSTRAINT user_birthdate_check CHECK (birthdate <= account_creation_date)
);

CREATE TABLE unblock_appeal (
    id_user SERIAL PRIMARY KEY REFERENCES users ON UPDATE CASCADE,
    message TEXT NOT NULL
);

CREATE TABLE event (
   id SERIAL PRIMARY KEY,
   id_host INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE,
   title TEXT NOT NULL,
   event_image TEXT NOT NULL,
   description TEXT NOT NULL,
   location TEXT NOT NULL,
   creation_date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT event_creation_date_check CHECK (creation_date <= NOW()),
   realization_date TIMESTAMP NOT NULL,
   is_visible BOOLEAN NOT NULL,
   is_accessible BOOLEAN NOT NULL,
   capacity INT NOT NULL CHECK (capacity > 0),
   price DECIMAL(2) NOT NULL CHECK (price >= 0),
   number_attendees INT NOT NULL DEFAULT 0 CONSTRAINT event_number_attendees CHECK (number_attendees >= 0 AND number_attendees <= capacity),
   CONSTRAINT check_realization_date CHECK (creation_date < realization_date)
);

CREATE TABLE tag (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL CONSTRAINT tag_name_uk UNIQUE
);

CREATE TABLE post (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    creation_date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT post_creation_date_check CHECK (creation_date <= NOW()),
    id_event INTEGER NOT NULL REFERENCES event ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE poll (
    id_post INTEGER PRIMARY KEY REFERENCES post ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE option (
    id SERIAL PRIMARY KEY,
    id_poll INTEGER NOT NULL REFERENCES poll ON UPDATE CASCADE ON DELETE CASCADE,
    description TEXT NOT NULL,
    votes INTEGER NOT NULL DEFAULT 0 CONSTRAINT option_votes_check CHECK (votes >= 0)
);

CREATE TABLE comment (
    id SERIAL PRIMARY KEY,
    id_author INTEGER REFERENCES users ON UPDATE CASCADE,
    id_event INTEGER NOT NULL REFERENCES event ON UPDATE CASCADE ON DELETE CASCADE,
    content TEXT NOT NULL,
    number_upvotes INTEGER NOT NULL DEFAULT 0 CONSTRAINT comment_number_upvotes CHECK (number_upvotes >= 0),
    number_downvotes INTEGER NOT NULL DEFAULT 0 CONSTRAINT comment_number_downvotes CHECK (number_downvotes >= 0),
    creation_date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT comment_creation_date_check CHECK (creation_date <= NOW())
);

CREATE TABLE rating (
    id_comment INTEGER REFERENCES comment ON UPDATE CASCADE,
    id_reader INTEGER REFERENCES users ON UPDATE CASCADE,
    vote comment_rating NOT NULL,
    PRIMARY KEY (id_comment, id_reader)
);

CREATE TABLE file (
    id_comment INTEGER PRIMARY KEY REFERENCES comment ON UPDATE CASCADE ON DELETE CASCADE,
    path TEXT NOT NULL CONSTRAINT file_path_uk UNIQUE
);

CREATE TABLE request (
    id SERIAL PRIMARY KEY,
    id_event INTEGER NOT NULL REFERENCES event ON UPDATE CASCADE ON DELETE CASCADE,
    date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT request_date_check CHECK (date <= NOW()),
    accepted BOOLEAN NOT NULL DEFAULT false,
    id_requester INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE
);

CREATE TABLE invite (
    id SERIAL PRIMARY KEY,
    id_event INTEGER NOT NULL REFERENCES event ON UPDATE CASCADE ON DELETE CASCADE,
    date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT invite_date_check CHECK (date <= NOW()),
    accepted BOOLEAN NOT NULL DEFAULT false,
    id_inviter INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE,
    id_invitee INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE,
    CONSTRAINT invite_invitter_invitee_id_check CHECK (id_inviter <> id_invitee)
);

CREATE TABLE report (
    id SERIAL PRIMARY KEY,
    id_author INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE,
    report_date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT report_date_check CHECK (report_date <= NOW()),
    motive TEXT NOT NULL,
    dismissal_date TIMESTAMP CONSTRAINT report_dismissal_date_check1 CHECK (dismissal_date <= NOW()),
    CONSTRAINT report_dismissal_date_check2 CHECK (dismissal_date IS NULL OR (dismissal_date >= report_date AND dismissal_date <= NOW()))
);

CREATE TABLE user_report (
    id_report INTEGER PRIMARY KEY REFERENCES report ON UPDATE CASCADE,
    target INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE
);

CREATE TABLE comment_report (
    id_report INTEGER PRIMARY KEY REFERENCES report,
    target INTEGER NOT NULL REFERENCES comment ON UPDATE CASCADE
);

CREATE TABLE event_report (
    id_report INTEGER PRIMARY KEY REFERENCES report ON UPDATE CASCADE,
    target INTEGER NOT NULL REFERENCES event ON UPDATE CASCADE
);

CREATE TABLE transaction (
    id SERIAL PRIMARY KEY,
    id_user INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE,
    amount DECIMAL(2) NOT NULL CONSTRAINT transaction_amount_check CHECK(amount > 0),
    date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT transaction_date_check CHECK (date <= NOW())
);

CREATE TABLE event_cancelled_notification (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    notification_date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT event_cancelled_notification_check CHECK (notification_date <= NOW())
);

CREATE TABLE attendee (
    id_user INTEGER REFERENCES users ON UPDATE CASCADE,
    id_event INTEGER REFERENCES event ON UPDATE CASCADE,
    PRIMARY KEY (id_user, id_event)
);

CREATE TABLE vote (
    id_user INTEGER REFERENCES users,
    id_option INTEGER REFERENCES option ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (id_user, id_option)
);

CREATE TABLE event_cancelled_notification_user (
    id_notification INTEGER REFERENCES event_cancelled_notification ON UPDATE CASCADE ON DELETE CASCADE,
    id_user INTEGER REFERENCES users ON UPDATE CASCADE,
    PRIMARY KEY (id_notification, id_user)
);

CREATE TABLE tag_event (
    id_tag INTEGER REFERENCES tag ON UPDATE CASCADE,
    id_event INTEGER REFERENCES event ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (id_tag, id_event)
);


DROP INDEX IF EXISTS user_event_attendee;
DROP INDEX IF EXISTS event_comment;
DROP INDEX IF EXISTS comment_rating;
DROP INDEX IF EXISTS search_idx;
DROP TRIGGER IF EXISTS event_search_update ON event;
DROP FUNCTION IF EXISTS event_search_update;
ALTER TABLE event DROP COLUMN IF EXISTS tsvectors;

-- ========================== Performance Indexes ===========================

CREATE INDEX user_attendee ON attendee USING hash (id_user);
CREATE INDEX event_comment ON comment USING hash (id_event);
CREATE INDEX comment_rating ON rating USING hash (id_comment);

-- ======================== Full-text Search Indexes ========================

ALTER TABLE event ADD COLUMN tsvectors TSVECTOR;

CREATE FUNCTION event_search_update() RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    NEW.tsvectors = (
      setweight(to_tsvector('english', NEW.title), 'A') ||
      setweight(to_tsvector('english', NEW.description), 'B')
    );
  END IF;
  IF TG_OP = 'UPDATE' THEN
      IF (NEW.title <> OLD.title OR NEW.description <> OLD.description) THEN
        NEW.tsvectors = (
          setweight(to_tsvector('english', NEW.title), 'A') ||
          setweight(to_tsvector('english', NEW.description), 'B')
        );
      END IF;
  END IF;
  RETURN NEW;
END $$
LANGUAGE plpgsql;

CREATE TRIGGER event_search_update
  BEFORE INSERT OR UPDATE ON event
  FOR EACH ROW
  EXECUTE PROCEDURE event_search_update();

CREATE INDEX search_idx ON event USING GIN (tsvectors);



-- =========================================== TRIGGER01 ===========================================

DROP TRIGGER IF EXISTS event_attendee_dif_host ON attendee;
DROP FUNCTION IF EXISTS event_attendee_dif_host;
CREATE FUNCTION event_attendee_dif_host() RETURNS TRIGGER AS 
$BODY$
BEGIN
    IF EXISTS (SELECT * FROM event WHERE NEW.id_event = event.id AND NEW.id_user = event.id_host) THEN
        RAISE EXCEPTION 'The user you''re trying to add to attendees is the event host';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER event_attendee_dif_host
    BEFORE INSERT OR UPDATE ON attendee
    FOR EACH ROW
    EXECUTE PROCEDURE event_attendee_dif_host();

-- =========================================== TRIGGER02 ===========================================

DROP TRIGGER IF EXISTS event_request ON request;
DROP FUNCTION IF EXISTS event_request;
CREATE FUNCTION event_request() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF EXISTS (SELECT * FROM event WHERE (event.id=NEW.id_event AND is_accessible)) THEN
        RAISE EXCEPTION 'Cannot send request to an accessible event';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER event_request
    BEFORE INSERT OR UPDATE ON request
    FOR EACH ROW
    EXECUTE PROCEDURE event_request();

-- =========================================== TRIGGER03 ===========================================

DROP TRIGGER IF EXISTS user_report_trigger ON user_report;
DROP FUNCTION IF EXISTS user_report;
CREATE FUNCTION user_report() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF EXISTS (SELECT * FROM report WHERE (id=NEW.id_report AND id_author=NEW.target)) THEN
        RAISE EXCEPTION 'Users can not report themselves.';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER user_report_trigger
    BEFORE INSERT OR UPDATE ON user_report
    FOR EACH ROW
    EXECUTE PROCEDURE user_report();

-- =========================================== TRIGGER04 ===========================================

DROP TRIGGER IF EXISTS comment_report_trigger ON comment_report;
DROP FUNCTION IF EXISTS comment_report;
CREATE FUNCTION comment_report() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF EXISTS (
        SELECT * FROM comment
            WHERE (comment.id=NEW.target AND comment.id_author
                IN (SELECT id_author FROM report WHERE id=NEW.id_report))        
    ) THEN
        RAISE EXCEPTION 'Users can not report their own comment.';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER comment_report_trigger
    BEFORE INSERT OR UPDATE ON comment_report
    FOR EACH ROW
    EXECUTE PROCEDURE comment_report();

-- =========================================== TRIGGER05 ===========================================

DROP TRIGGER IF EXISTS event_report_trigger ON event_report;
DROP FUNCTION IF EXISTS event_report;
CREATE FUNCTION event_report() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF EXISTS (
        SELECT * FROM event 
            WHERE (event.id=NEW.target AND event.id_host 
                IN (SELECT id_author FROM report WHERE id=NEW.id_report))        
    ) THEN
        RAISE EXCEPTION 'Users can not report their own event.';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER event_report_trigger
    BEFORE INSERT OR UPDATE ON event_report
    FOR EACH ROW
    EXECUTE PROCEDURE event_report();

-- =========================================== TRIGGER06 ===========================================

DROP TRIGGER IF EXISTS host_invite ON invite;
DROP FUNCTION IF EXISTS host_invite;
CREATE FUNCTION host_invite() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF EXISTS (SELECT * FROM event WHERE (NEW.id_event = id AND NEW.id_invitee = id_host))
        THEN
            RAISE EXCEPTION 'Host cannot be invited to his own event.';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER host_invite
    BEFORE INSERT OR UPDATE ON invite
    FOR EACH ROW
    EXECUTE PROCEDURE host_invite();

-- =========================================== TRIGGER07 ===========================================

DROP TRIGGER IF EXISTS vote_increase ON vote;
DROP FUNCTION IF EXISTS vote_increase;
CREATE FUNCTION vote_increase() RETURNS TRIGGER AS
$BODY$
BEGIN
    UPDATE option SET votes = votes + 1 WHERE NEW.id_option = option.id;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER vote_increase
    AFTER INSERT ON vote
    FOR EACH ROW
    EXECUTE PROCEDURE vote_increase();

-- =========================================== TRIGGER08 ===========================================

DROP TRIGGER IF EXISTS user_report_disjoint ON user_report;
DROP FUNCTION IF EXISTS user_report_disjoint;
CREATE FUNCTION user_report_disjoint() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF EXISTS (
        SELECT id_report FROM comment_report WHERE id_report = NEW.id_report
        UNION
        SELECT id_report FROM event_report WHERE id_report = NEW.id_report)
        THEN
            RAISE EXCEPTION 'A report cannot have multiple types';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER user_report_disjoint
    BEFORE INSERT OR UPDATE ON user_report
    FOR EACH ROW
    EXECUTE PROCEDURE user_report_disjoint();
    
-- =========================================== TRIGGER09 ===========================================

DROP TRIGGER IF EXISTS comment_report_disjoint ON comment_report;
DROP FUNCTION IF EXISTS comment_report_disjoint;
CREATE FUNCTION comment_report_disjoint() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF EXISTS (
        SELECT id_report FROM user_report WHERE id_report=NEW.id_report
        UNION
        SELECT id_report from event_report WHERE id_report=NEW.id_report)
        THEN
            RAISE EXCEPTION 'A report cannot have multiple types';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER comment_report_disjoint
    BEFORE INSERT OR UPDATE ON comment_report
    FOR EACH ROW
    EXECUTE PROCEDURE comment_report_disjoint();

-- =========================================== TRIGGER10 ===========================================

DROP TRIGGER IF EXISTS event_report_disjoint ON event_report;
DROP FUNCTION IF EXISTS event_report_disjoint;
CREATE FUNCTION event_report_disjoint() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF EXISTS (
        SELECT id_report FROM comment_report WHERE id_report=NEW.id_report
        UNION 
        SELECT id_report FROM user_report WHERE id_report=NEW.id_report)
        THEN
            RAISE EXCEPTION 'A report cannot have multiple types';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER event_report_disjoint
    BEFORE INSERT OR UPDATE ON event_report
    FOR EACH ROW
    EXECUTE PROCEDURE event_report_disjoint();

-- =========================================== TRIGGER11 ===========================================

DROP TRIGGER IF EXISTS comment_author_belongs_to_event ON comment;
DROP FUNCTION IF EXISTS comment_author_belongs_to_event;
CREATE FUNCTION comment_author_belongs_to_event() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF NEW.id_author = 0 -- Anonymous user
    THEN
        RETURN NEW;
    END IF;
    IF
        EXISTS (SELECT * FROM event WHERE id_host=NEW.id_author AND id=NEW.id_event) 
        OR 
        EXISTS (SELECT * FROM attendee WHERE id_user=NEW.id_author AND id_event=NEW.id_event)
        THEN
            RETURN NEW;
    END IF;
    RAISE EXCEPTION 'Comment author must be a part of the event the comment belongs to';
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER comment_author_belongs_to_event
    BEFORE INSERT OR UPDATE ON comment
    FOR EACH ROW
    EXECUTE PROCEDURE comment_author_belongs_to_event();

-- =========================================== TRIGGER12 ===========================================

DROP TRIGGER IF EXISTS comment_reader_belongs_to_event ON rating;
DROP FUNCTION IF EXISTS comment_reader_belongs_to_event;
CREATE FUNCTION comment_reader_belongs_to_event() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF NEW.id_reader = 0 -- Anonymous user
    THEN
        RETURN NEW;
    END IF;
    IF 
        EXISTS (SELECT * FROM ((SELECT id_event FROM comment WHERE id = NEW.id_comment) AS event_comment JOIN event ON (id_event=event.id)) WHERE id_host=NEW.id_reader)
        OR
        EXISTS (SELECT * FROM ((SELECT id_event FROM comment WHERE id = NEW.id_comment) AS event_comment JOIN attendee ON (event_comment.id_event=attendee.id_event)) WHERE id_user=NEW.id_reader)
        THEN
            RETURN NEW;
    END IF;
    RAISE EXCEPTION 'Comment reader must be a part of the event the comment belongs to';
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER comment_reader_belongs_to_event
    BEFORE INSERT OR UPDATE ON rating
    FOR EACH ROW
    EXECUTE PROCEDURE comment_reader_belongs_to_event();

-- =========================================== TRIGGER13 ===========================================

DROP TRIGGER IF EXISTS attendee_cannot_send_request ON request;
DROP FUNCTION IF EXISTS attendee_cannot_send_request;
CREATE FUNCTION attendee_cannot_send_request() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF EXISTS (SELECT * FROM attendee WHERE attendee.id_user = NEW.id_requester AND attendee.id_event = NEW.id_event)
        THEN RAISE EXCEPTION 'Attendee can''t send request to join the event';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER attendee_cannot_send_request
    BEFORE INSERT OR UPDATE ON request
    FOR EACH ROW
    EXECUTE PROCEDURE attendee_cannot_send_request();

-- =========================================== TRIGGER14 ===========================================

DROP TRIGGER IF EXISTS vote_made_by_attendee ON vote;
DROP FUNCTION IF EXISTS vote_made_by_attendee;
CREATE FUNCTION vote_made_by_attendee() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF NEW.id_user = 0 -- Anonymous user
    THEN
        RETURN NEW;
    END IF;
    IF
        NEW.id_user IN (
            SELECT id_user FROM attendee WHERE id_event IN (
                SELECT post.id_event FROM
                    post 
                    JOIN 
                    (SELECT * FROM option WHERE (id=NEW.id_option)) AS opt
                    ON (opt.id_poll = post.id)
            )
        )
        THEN
            RETURN NEW;
    END IF;
    RAISE EXCEPTION 'Vote wasn''t made by an event attendee';
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER vote_made_by_attendee
    BEFORE INSERT OR UPDATE ON vote
    FOR EACH ROW
    EXECUTE PROCEDURE vote_made_by_attendee();

-- =========================================== TRIGGER15 ===========================================

DROP TRIGGER IF EXISTS attendees_vote_once ON vote;
DROP FUNCTION IF EXISTS attendees_vote_once;
CREATE FUNCTION attendees_vote_once() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF EXISTS (SELECT * FROM poll, option, vote WHERE poll.id_post = option.id_poll AND option.id = vote.id_option AND NEW.id_user = vote.id_user)
    THEN RAISE EXCEPTION 'An attendee can''t vote twice in the same poll';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER attendees_vote_once
    BEFORE INSERT ON vote
    FOR EACH ROW
    EXECUTE PROCEDURE attendees_vote_once();

-- =========================================== TRIGGER16 ===========================================

DROP TRIGGER IF EXISTS cant_invite_attendee ON invite;
DROP FUNCTION IF EXISTS cant_invite_attendee;
CREATE FUNCTION cant_invite_attendee() RETURNS TRIGGER AS
$BODY$
BEGIN
    IF EXISTS (
        SELECT * FROM attendee WHERE (id_event=NEW.id_event AND id_user=NEW.id_invitee)
    )
    THEN
        RAISE EXCEPTION 'An user cannot be invited to an event he''s already attending';
    END IF;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER cant_invite_attendee
    BEFORE INSERT OR UPDATE ON invite
    FOR EACH ROW
    EXECUTE PROCEDURE cant_invite_attendee();

-- =========================================== TRIGGER17 ===========================================

DROP TRIGGER IF EXISTS increment_number_attendees ON attendee;
DROP FUNCTION IF EXISTS increment_number_attendees;
CREATE FUNCTION increment_number_attendees() RETURNS TRIGGER AS
$BODY$
BEGIN
    UPDATE event SET number_attendees = number_attendees + 1 WHERE NEW.id_event = event.id;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER increment_number_attendees
    BEFORE INSERT ON attendee
    FOR EACH ROW
    EXECUTE PROCEDURE increment_number_attendees();

-- =========================================== TRIGGER18 ===========================================

DROP TRIGGER IF EXISTS decrement_number_attendees ON attendee;
DROP FUNCTION IF EXISTS decrement_number_attendees;
CREATE FUNCTION decrement_number_attendees() RETURNS TRIGGER AS
$BODY$
BEGIN
    UPDATE event SET number_attendees = number_attendees - 1 WHERE OLD.id_event = event.id;
    RETURN OLD;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER decrement_number_attendees
    AFTER DELETE ON attendee
    FOR EACH ROW
    EXECUTE PROCEDURE decrement_number_attendees();

-- =========================================== TRIGGER19 ===========================================

DROP TRIGGER IF EXISTS increment_number_upvotes ON rating;
DROP FUNCTION IF EXISTS increment_number_upvotes;
CREATE FUNCTION increment_number_upvotes() RETURNS TRIGGER AS
$BODY$
BEGIN
    UPDATE comment SET number_upvotes = number_upvotes + 1 WHERE NEW.id_comment = comment.id;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER increment_number_upvotes
    BEFORE INSERT ON rating
    FOR EACH ROW
    EXECUTE PROCEDURE increment_number_upvotes();

-- =========================================== TRIGGER20 ===========================================

DROP TRIGGER IF EXISTS increment_number_downvotes ON rating;
DROP FUNCTION IF EXISTS increment_number_downvotes;
CREATE FUNCTION increment_number_downvotes() RETURNS TRIGGER AS
$BODY$
BEGIN
    UPDATE comment SET number_downvotes = number_downvotes + 1 WHERE NEW.id_comment = comment.id;
    RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER increment_number_downvotes
    BEFORE INSERT ON rating
    FOR EACH ROW
    EXECUTE PROCEDURE increment_number_downvotes();

-- =========================================== TRIGGER21 ===========================================

DROP TRIGGER IF EXISTS decrement_number_upvotes ON rating;
DROP FUNCTION IF EXISTS decrement_number_upvotes;
CREATE FUNCTION decrement_number_upvotes() RETURNS TRIGGER AS
$BODY$
BEGIN
    UPDATE comment SET number_upvotes = number_upvotes - 1 WHERE OLD.id_comment = comment.id;
    RETURN OLD;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER decrement_number_upvotes
    AFTER DELETE ON rating
    FOR EACH ROW
    EXECUTE PROCEDURE decrement_number_upvotes();

-- =========================================== TRIGGER22 ===========================================

DROP TRIGGER IF EXISTS decrement_number_downvotes ON rating;
DROP FUNCTION IF EXISTS decrement_number_downvotes;
CREATE FUNCTION decrement_number_downvotes() RETURNS TRIGGER AS
$BODY$
BEGIN
    UPDATE comment SET number_downvotes = number_downvotes - 1 WHERE OLD.id_comment = comment.id;
    RETURN OLD;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER decrement_number_downvotes
    AFTER DELETE ON rating
    FOR EACH ROW
    EXECUTE PROCEDURE decrement_number_downvotes();