create schema if not exists lbaw2122;
SET search_path TO lbaw2122;

-----------------------------------------
-- Drop Tables and Types
----------------------------------------- 

DROP TABLE IF EXISTS event_tag;
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
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS password_resets;

-----------------------------------------
-- Types
-----------------------------------------

DROP TYPE IF EXISTS comment_rating CASCADE;
CREATE TYPE comment_rating AS ENUM ('Upvote', 'Downvote');

-----------------------------------------
-- Tables
-----------------------------------------

-- Note that a plural 'users' name was adopted because user is a reserved word in PostgreSQL.

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL CONSTRAINT user_username_uk UNIQUE,
    email TEXT NOT NULL CONSTRAINT user_email_uk UNIQUE CONSTRAINT user_email_check CHECK (email LIKE '%@%.%'),
    password TEXT,
    name TEXT NOT NULL,
    profile_pic TEXT,
    account_creation_date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT user_account_creation_date_check CHECK (account_creation_date <= NOW()),
    birthdate DATE NOT NULL,
    description TEXT,
    block_motive TEXT,
    remember_token TEXT,
    is_admin BOOLEAN NOT NULL DEFAULT false,
    google_id TEXT,
    google_token TEXT,
    google_refresh_token TEXT,
    CONSTRAINT user_birthdate_check CHECK (birthdate <= account_creation_date)
);

CREATE TABLE unblock_appeal (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users ON UPDATE CASCADE UNIQUE,
    message TEXT NOT NULL
);

CREATE TABLE event (
   id SERIAL PRIMARY KEY,
   host_id INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE,
   title TEXT NOT NULL,
   event_image TEXT NOT NULL,
   description TEXT NOT NULL,
   location TEXT NOT NULL,
   creation_date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT event_creation_date_check CHECK (creation_date <= NOW()),
   realization_date TIMESTAMP NOT NULL,
   is_visible BOOLEAN NOT NULL,
   is_accessible BOOLEAN NOT NULL,
   capacity INT CHECK (capacity = NULL OR capacity > 0),
   price DECIMAL(8, 2) NOT NULL CHECK (price >= 0),
   number_attendees INT NOT NULL DEFAULT 0 CONSTRAINT event_number_attendees CHECK (number_attendees >= 0 AND (capacity = NULL OR number_attendees <= capacity)),
   CONSTRAINT check_realization_date CHECK (creation_date < realization_date)
);

CREATE TABLE tag (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL CONSTRAINT tag_name_uk UNIQUE
);

CREATE TABLE post (
    id SERIAL PRIMARY KEY,
    text TEXT NOT NULL,
    creation_date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT post_creation_date_check CHECK (creation_date <= NOW()),
    event_id INTEGER NOT NULL REFERENCES event ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE poll (
    post_id INTEGER PRIMARY KEY REFERENCES post ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE option (
    id SERIAL PRIMARY KEY,
    poll_id INTEGER NOT NULL REFERENCES poll ON UPDATE CASCADE ON DELETE CASCADE,
    description TEXT NOT NULL,
    votes INTEGER NOT NULL DEFAULT 0 CONSTRAINT option_votes_check CHECK (votes >= 0)
);

CREATE TABLE comment (
    id SERIAL PRIMARY KEY,
    author_id INTEGER REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE,
    event_id INTEGER NOT NULL REFERENCES event ON UPDATE CASCADE ON DELETE CASCADE,
    content TEXT NOT NULL,
    number_upvotes INTEGER NOT NULL DEFAULT 0 CONSTRAINT comment_number_upvotes CHECK (number_upvotes >= 0),
    number_downvotes INTEGER NOT NULL DEFAULT 0 CONSTRAINT comment_number_downvotes CHECK (number_downvotes >= 0),
    creation_date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT comment_creation_date_check CHECK (creation_date <= NOW())
);

CREATE TABLE rating (
    id SERIAL PRIMARY KEY,
    comment_id INTEGER REFERENCES comment ON UPDATE CASCADE ON DELETE CASCADE,
    user_id INTEGER REFERENCES users ON UPDATE CASCADE ON DELETE CASCADE,
    vote comment_rating NOT NULL,
    UNIQUE (comment_id, user_id)
);

CREATE TABLE file (
    file_id SERIAL PRIMARY KEY, 
    comment_id INTEGER REFERENCES comment ON UPDATE CASCADE ON DELETE CASCADE,
    original_name TEXT NOT NULL,
    path TEXT NOT NULL CONSTRAINT file_path_uk UNIQUE
);

CREATE TABLE request (
    id SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL REFERENCES event ON UPDATE CASCADE ON DELETE CASCADE,
    date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT request_date_check CHECK (date <= NOW()),
    accepted BOOLEAN NOT NULL DEFAULT false,
    user_id INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE,
    UNIQUE(user_id, event_id)
);

CREATE TABLE invite (
    id SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL REFERENCES event ON UPDATE CASCADE ON DELETE CASCADE,
    date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT invite_date_check CHECK (date <= NOW()),
    accepted BOOLEAN NOT NULL DEFAULT false,
    inviter_id INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE,
    invitee_id INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE,
    CONSTRAINT invite_invitter_invitee_id_check CHECK (inviter_id <> invitee_id),
    UNIQUE(event_id, inviter_id, invitee_id)
);

CREATE TABLE report (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE,
    report_date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT report_date_check CHECK (report_date <= NOW()),
    motive TEXT NOT NULL,
    dismissal_date TIMESTAMP CONSTRAINT report_dismissal_date_check1 CHECK (dismissal_date <= NOW()),
    CONSTRAINT report_dismissal_date_check2 CHECK (dismissal_date IS NULL OR (dismissal_date >= report_date AND dismissal_date <= NOW()))
);

CREATE TABLE user_report (
    report_id INTEGER PRIMARY KEY REFERENCES report ON UPDATE CASCADE,
    target INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE
);

CREATE TABLE comment_report (
    report_id INTEGER PRIMARY KEY REFERENCES report,
    target INTEGER NOT NULL REFERENCES comment ON UPDATE CASCADE
);

CREATE TABLE event_report (
    report_id INTEGER PRIMARY KEY REFERENCES report ON UPDATE CASCADE,
    target INTEGER NOT NULL REFERENCES event ON UPDATE CASCADE
);

CREATE TABLE transaction (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users ON UPDATE CASCADE,
    amount DECIMAL(8,2) NOT NULL CONSTRAINT transaction_amount_check CHECK(amount > 0),
    date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT transaction_date_check CHECK (date <= NOW())
);

CREATE TABLE event_cancelled_notification (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    notification_date TIMESTAMP NOT NULL DEFAULT NOW() CONSTRAINT event_cancelled_notification_check CHECK (notification_date <= NOW())
);

CREATE TABLE attendee (
    user_id INTEGER REFERENCES users ON UPDATE CASCADE,
    event_id INTEGER REFERENCES event ON UPDATE CASCADE,
    PRIMARY KEY (user_id, event_id)
);

CREATE TABLE vote (
    user_id INTEGER REFERENCES users,
    option_id INTEGER REFERENCES option ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (user_id, option_id)
);

CREATE TABLE event_cancelled_notification_user (
    notification_id INTEGER REFERENCES event_cancelled_notification ON UPDATE CASCADE ON DELETE CASCADE,
    user_id INTEGER REFERENCES users ON UPDATE CASCADE,
    PRIMARY KEY (notification_id, user_id)
);

CREATE TABLE event_tag (
    tag_id INTEGER REFERENCES tag ON UPDATE CASCADE,
    event_id INTEGER REFERENCES event ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (tag_id, event_id)
);

-- Notifications table created by laravel
CREATE TABLE notifications (
    "id" uuid NOT NULL, 
    "type" varchar(255) NOT NULL, 
    "notifiable_type" varchar(255) NOT NULL, 
    "notifiable_id" bigint NOT NULL, 
    "data" text NOT NULL, 
    "read_at" timestamp(0) without time zone null, 
    "created_at" timestamp(0) without time zone null, 
    "updated_at" timestamp(0) without time zone null
);

CREATE TABLE password_resets (
    "email" varchar(255) not null,
    "token" varchar(255) not null,
    "created_at" timestamp(0) without time zone null
);

DROP INDEX IF EXISTS user_event_attendee;
DROP INDEX IF EXISTS event_comment;
DROP INDEX IF EXISTS comment_rating;
DROP INDEX IF EXISTS search_idx;
DROP TRIGGER IF EXISTS event_search_update ON event;
DROP FUNCTION IF EXISTS event_search_update;
ALTER TABLE event DROP COLUMN IF EXISTS tsvectors;

-- ========================== Performance Indexes ===========================

CREATE INDEX user_attendee ON attendee USING hash (user_id);
CREATE INDEX event_comment ON comment USING hash (event_id);
CREATE INDEX comment_rating ON rating USING hash (comment_id);

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
    IF EXISTS (SELECT * FROM event WHERE NEW.event_id = event.id AND NEW.user_id = event.host_id) THEN
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
    IF EXISTS (SELECT * FROM event WHERE (event.id=NEW.event_id AND is_accessible)) THEN
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
    IF EXISTS (SELECT * FROM report WHERE (id=NEW.report_id AND user_id=NEW.target)) THEN
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
            WHERE (comment.id=NEW.target AND comment.author_id
                IN (SELECT user_id FROM report WHERE id=NEW.report_id))        
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
            WHERE (event.id=NEW.target AND event.host_id 
                IN (SELECT user_id FROM report WHERE id=NEW.report_id))        
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
    IF EXISTS (SELECT * FROM event WHERE (NEW.event_id = id AND NEW.invitee_id = host_id))
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
    UPDATE option SET votes = votes + 1 WHERE NEW.option_id = option.id;
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
        SELECT report_id FROM comment_report WHERE report_id = NEW.report_id
        UNION
        SELECT report_id FROM event_report WHERE report_id = NEW.report_id)
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
        SELECT report_id FROM user_report WHERE report_id=NEW.report_id
        UNION
        SELECT report_id from event_report WHERE report_id=NEW.report_id)
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
        SELECT report_id FROM comment_report WHERE report_id=NEW.report_id
        UNION 
        SELECT report_id FROM user_report WHERE report_id=NEW.report_id)
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
    IF NEW.author_id = 0 -- Anonymous user
    THEN
        RETURN NEW;
    END IF;
    IF
        EXISTS (SELECT * FROM event WHERE host_id=NEW.author_id AND id=NEW.event_id) 
        OR 
        EXISTS (SELECT * FROM attendee WHERE user_id=NEW.author_id AND event_id=NEW.event_id)
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
    IF NEW.user_id = 0 -- Anonymous user
    THEN
        RETURN NEW;
    END IF;
    IF 
        EXISTS (SELECT * FROM ((SELECT event_id FROM comment WHERE id = NEW.comment_id) AS event_comment JOIN event ON (event_id=event.id)) WHERE host_id=NEW.user_id)
        OR
        EXISTS (SELECT * FROM ((SELECT event_id FROM comment WHERE id = NEW.comment_id) AS event_comment JOIN attendee ON (event_comment.event_id=attendee.event_id)) WHERE user_id=NEW.user_id)
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
    IF EXISTS (SELECT * FROM attendee WHERE attendee.user_id = NEW.user_id AND attendee.event_id = NEW.event_id)
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
    IF NEW.user_id = 0 -- Anonymous user
    THEN
        RETURN NEW;
    END IF;
    IF
        NEW.user_id IN (
            SELECT user_id FROM attendee WHERE event_id IN (
                SELECT post.event_id FROM
                    post 
                    JOIN 
                    (SELECT * FROM option WHERE (id=NEW.option_id)) AS opt
                    ON (opt.poll_id = post.id)
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
    IF EXISTS (SELECT * FROM poll, option, vote WHERE poll.post_id = option.poll_id AND option.id = vote.option_id AND NEW.user_id = vote.user_id)
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
        SELECT * FROM attendee WHERE (event_id=NEW.event_id AND user_id=NEW.invitee_id)
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
    UPDATE event SET number_attendees = number_attendees + 1 WHERE NEW.event_id = event.id;
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
    UPDATE event SET number_attendees = number_attendees - 1 WHERE OLD.event_id = event.id;
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
    UPDATE comment SET number_upvotes = number_upvotes + 1 WHERE NEW.comment_id = comment.id AND NEW.vote = 'Upvote';
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
    UPDATE comment SET number_downvotes = number_downvotes + 1 WHERE NEW.comment_id = comment.id AND NEW.vote = 'Downvote';
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
    UPDATE comment SET number_upvotes = number_upvotes - 1 WHERE OLD.comment_id = comment.id AND OLD.vote = 'Upvote';
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
    UPDATE comment SET number_downvotes = number_downvotes - 1 WHERE OLD.comment_id = comment.id AND OLD.vote = 'Downvote';
    RETURN OLD;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER decrement_number_downvotes
    AFTER DELETE ON rating
    FOR EACH ROW
    EXECUTE PROCEDURE decrement_number_downvotes();


-- ========================= users =========================

INSERT INTO users(id,username,email,password,name,birthdate) VALUES
  (0,'anonymous','anonymous@eventful.com','OJB30XLR4LU','Anonymous','01/01/1970'),
  (1,'Christian','mauris.sit@protonmail.org','UBM11GKC5ZB','Dominic Juarez','09/07/2003'),
  (2,'Denise','venenatis.a@outlook.org','HWH11QVR1GU','Raymond Elliott','04/10/1972'),
  (3,'Abigail','dignissim.tempor@outlook.org','RSP28SYW2CI','Barrett Robertson','09/24/1978'),
  (4,'Keiko','pretium.aliquet@outlook.couk','KEL46LIZ6CP','Yardley Nielsen','07/23/1955'),
  (5,'Madison','ut.sagittis@yahoo.org','ZOF76RJJ4KQ','Troy Rutledge','07/15/2002'),
  (6,'Xyla','aliquam@outlook.org','FCG83RUG2VI','Brianna Randolph','12/24/2003'),
  (7,'Hillary','in.faucibus@icloud.ca','QPG62PYX2IF','Alyssa Alston','04/07/1986'),
  (8,'Brock','ac.nulla@outlook.net','HRV79QRF1IZ','Ina Wallace','04/11/1965'),
  (9,'Ainsley','a.neque.nullam@google.edu','SHR27WNL8IR','Erica Burch','04/27/1985'),
  (10,'Leigh','tempor.bibendum.donec@aol.couk','BCM77MUJ4NM','Cyrus Spencer','06/19/1950'),
  (11,'Nichole','suscipit.nonummy@aol.ca','ETH12FKJ3IJ','Maxine Leonard','08/13/1963'),
  (12,'Andrew','nunc@yahoo.ca','RCL35ETY4MP','Naomi Nelson','11/29/1978'),
  (13,'Lee','auctor@hotmail.net','IMM81FOQ4OS','Rigel Winters','03/09/1982'),
  (14,'Dana','cursus@icloud.org','XYL85SXG6TW','Hyatt Wiggins','10/13/1958'),
  (15,'Shana','ornare.facilisis.eget@hotmail.org','BVE65MLJ6UD','Halla Carr','04/14/1956'),
  (16,'Julian','quis.arcu@icloud.com','PEV07OVH6UW','Jane Brewer','07/03/2008'),
  (17,'Lydia','lectus.cum@google.ca','GNQ68PGN6RQ','Brooke Sellers','08/18/1968'),
  (18,'Marvin','iaculis.quis@aol.net','JGM26YAC1BO','Drew Mcintosh','02/18/1957'),
  (19,'Germane','nulla@outlook.ca','VMH54WOC2UL','Quemby Henson','07/04/1975'),
  (20,'Owen','vestibulum.lorem.sit@icloud.com','ULS58DSE4RM','Acton Savage','03/21/1959'),
  (21,'Herrod','sem@hotmail.org','IEY18LCE8BQ','Jasper Roman','10/31/1988'),
  (22,'Burton','quam.quis@google.edu','XUU73PLF4UV','Dara Gay','11/06/1972'),
  (23,'mikeg','sociosqu.ad.litora@hotmail.org','TRX78TIO3YN','Gillian Trevino','04/08/1992'),
  (24,'Hayes12','ac.sem@icloud.net','DPM31AKS4WO','Rudyard Montgomery','09/03/1961'),
  (25,'Nell','eu@hotmail.edu','FDY17HQH1TJ','Castor Lewis','01/03/1987'),
  (26,'Beverly','placerat.eget.venenatis@protonmail.net','ZDT50KAD0WT','Bradley Mcmahon','08/18/1953'),
  (27,'Zeph','id@protonmail.com','YBS84ODY2SE','Reed Brock','11/29/1977'),
  (28,'Ivor','tempus.risus@yahoo.org','OGR94QDY6RS','Ivan Haley','07/01/1995'),
  (29,'Joseph','mauris@protonmail.net','HOP96CCK8GH','Kathleen Dawson','01/13/1986'),
  (30,'Shelby','donec@outlook.net','MRS68QQY0SP','Wynne Fleming','03/17/1979'),
  (31,'Brianna','sit@yahoo.com','BHC68TTB1ID','Sopoline Lang','06/07/2009'),
  (32,'Keiko123','rutrum@hotmail.ca','NYR20KOK6MM','Driscoll Flores','07/08/1954'),
  (33,'Lysandra','praesent@aol.edu','ITD27CMW9QH','Maxwell Fernandez','05/17/1979'),
  (34,'Tanya','pharetra.nibh@protonmail.couk','EZL82LKU4EA','Daryl Ortega','03/12/1979'),
  (35,'Shoshana','eu.tempor@protonmail.org','VBZ15MFO3FX','Barrett Washington','07/04/1969'),
  (36,'Maia','natoque.penatibus@hotmail.edu','VWC54IGC4DE','Daria Neal','06/17/1973'),
  (37,'April','ipsum.non@yahoo.ca','BYJ66WEG9XS','Jolene Burch','02/18/1991'),
  (38,'Jakeem','arcu.et@outlook.net','BMI85HYQ5GH','Noah Dudley','06/01/1976'),
  (39,'Brent','aliquet.lobortis@outlook.ca','TCI37DLO5JC','Beck Walker','05/30/1983'),
  (40,'Zahir','amet.consectetuer@hotmail.net','TEO35WLR5CE','Henry Vega','07/18/1950'),
  (41,'Cyrus','luctus.vulputate@outlook.com','DLD61XTK2FG','Aristotle Guthrie','01/23/1984'),
  (42,'Jerome','blandit@outlook.ca','NAC61UXB6GJ','Carl Riddle','07/20/2002'),
  (43,'Chanda','ut.pellentesque@protonmail.ca','ETV83HAJ8FZ','Mark Mcpherson','02/24/1991'),
  (44,'Olympia','nam@google.net','UTH75SYH4HB','Steel Vazquez','04/30/1999'),
  (45,'Ella','nonummy.ultricies@icloud.edu','RWR47LLG2EG','Tamara Mitchell','08/16/1997'),
  (46,'Celeste','quam.curabitur@outlook.ca','HYH28GPW1LN','Orlando Hebert','10/29/2009'),
  (47,'Hiram','urna.vivamus@hotmail.net','WEO26LPJ0OJ','Erin Sweeney','01/23/1962'),
  (48,'Barry5','tristique.aliquet@yahoo.couk','NZY82EJY2EU','Cole Reid','06/04/1988'),
  (49,'Baxter','sapien.imperdiet@google.ca','EIF82SNE4OX','Hadassah Waller','08/08/1969'),
  (50,'Quamar','libero.at@hotmail.couk','GZX37BBE9DC','Simon Brewer','12/26/1957'),
  (51,'Jermaine','orci.phasellus@outlook.edu','BSI75VTQ4OQ','Faith Griffin','07/07/2011'),
  (52,'Jeanette','vitae.odio@icloud.couk','TGZ71CBU0VB','Francesca Diaz','12/30/1959'),
  (53,'Imogene','mauris.ut@protonmail.couk','ZSH54GNV8DD','Chadwick Osborn','05/17/2011'),
  (54,'Akeem','est@outlook.org','IZV20ETS1BK','Aristotle Mcfadden','06/04/1960'),
  (55,'Quyn','malesuada.malesuada@yahoo.ca','SEL79NXQ1LP','Mercedes Bradford','03/29/2015'),
  (56,'Gregory','molestie@yahoo.com','FGC11FPW6PC','Lucian Carroll','08/16/1966'),
  (57,'Walter','curae@google.org','ZGC20BJD7QV','Ahmed Conner','03/11/1999'),
  (58,'Tana','ut.pharetra.sed@aol.org','GYM15SDM3UM','Philip Spencer','02/26/1959'),
  (59,'Nichole2','nisl.elementum@aol.couk','EAC37IQI8KD','Jonas Cantu','11/12/1989'),
  (60,'Avram','leo.elementum@aol.com','ZWP79CMS0RT','Nerea Pate','11/05/1978'),
  (61,'Acton','facilisis@google.couk','GCS32FPT2NF','Jesse Martinez','09/18/2005'),
  (62,'Maggie','nullam.nisl@yahoo.net','SQZ58WBP2DG','Evelyn Pratt','10/14/1997'),
  (63,'Katell','cras.pellentesque.sed@outlook.net','PRQ13KBT6TN','Kai Rodgers','06/15/1980'),
  (64,'Urielle','dictum.mi.ac@google.com','BIF84GCD7FU','Cheryl Sawyer','11/16/1984'),
  (65,'Grady','sed.nunc.est@protonmail.couk','FEG17RIL8NQ','Carly Moreno','12/29/1961'),
  (66,'Noble','rutrum.eu@google.ca','JGA17JGN1RJ','Thor Mathis','12/27/1969'),
  (67,'Devin','tincidunt.congue.turpis@outlook.com','BAE42GYK6BH','Yoshi Parrish','11/14/1959'),
  (68,'Hope','nisi.dictum@aol.net','BOH76VXO1ZT','Rina Snow','06/12/1994'),
  (69,'Urielle2','phasellus.dolor@protonmail.org','QDF84TSS9BQ','Karyn Hines','12/12/1992'),
  (70,'Lilah','proin.nisl@icloud.couk','OCC46BLL5TK','Imani Fischer','03/01/1953'),
  (71,'Asher','duis.cursus@icloud.org','JKT14XDZ8RW','Driscoll Woods','09/21/1955'),
  (72,'Talon','dignissim.lacus.aliquam@aol.net','NJE02TCB2IX','Irene Mooney','09/14/2009'),
  (73,'Marny','nunc@icloud.ca','KVH47MEU7KP','Odessa Bradford','07/19/2014'),
  (74,'Ria','mauris.suspendisse@yahoo.couk','FHA57AYD3CF','Barrett Terry','06/14/1956'),
  (75,'Fallon','eu.tellus.phasellus@protonmail.edu','SFR71KEQ5ST','Erich Burch','06/02/1974'),
  (76,'Ina','etiam.vestibulum@aol.edu','WWF47EQC1HN','Rhiannon Potter','05/19/1958'),
  (77,'Xander','consequat.lectus@aol.edu','GQE67BVQ2KF','Bevis Salinas','02/16/1971'),
  (78,'Veda','vivamus.nisi@icloud.ca','XHQ45DND7OD','Fatima Welch','07/18/1951'),
  (79,'Lynn','maecenas@protonmail.com','HRF45IEW2KU','Evangeline Glass','09/16/1997'),
  (80,'Richard','molestie.tortor@yahoo.ca','SKQ75CGD7KO','Charles Grant','07/15/2009'),
  (81,'Francis','arcu.vestibulum@yahoo.com','XFM68TVK6LP','Anthony Alvarez','07/31/2005'),
  (82,'Rashad','magna@outlook.couk','JMQ11YLB3CM','Christen Phelps','06/26/1977'),
  (83,'Salvador','malesuada.fames@yahoo.ca','BKK77TIU6OB','Tanisha Murphy','08/20/2008'),
  (84,'Tyrone','interdum.libero@icloud.ca','YTB39KMS5WF','Deirdre Mcmahon','09/04/1959'),
  (85,'Nolan','lobortis@aol.org','NRQ13MAP2WV','Britanni Levine','01/07/1997'),
  (86,'Kylan','libero.dui@yahoo.org','LYI49FQR7OV','Nash Osborn','09/27/1975'),
  (87,'Madeson','proin.ultrices.duis@icloud.ca','FOE36EIP3JZ','Galena Diaz','04/10/1950'),
  (88,'MacKensie','convallis.ante@protonmail.couk','PCP27OLD4NQ','Stone Burton','02/01/1974'),
  (89,'Arden','gravida.mauris.ut@protonmail.couk','BCR70WBC6UE','Shaine Norman','10/03/1985'),
  (90,'Orlando','hymenaeos.mauris.ut@outlook.edu','QEO26SSH7OA','Galena Vasquez','10/27/2007'),
  (91,'Madeline','ipsum@google.ca','EIB82CFA2FS','Brianna Webster','07/28/2004'),
  (92,'Edan','nunc.sed@aol.org','MKQ69MPM2EU','Sebastian Wilkinson','02/07/1996'),
  (93,'Jermaine123','lobortis.nisi@icloud.org','FEZ72ZZH6OP','Salvador Myers','04/05/1962'),
  (94,'Rebecca','eget@icloud.com','HYR44ZUJ0VN','Thor Guzman','04/22/1986'),
  (95,'Kelly','varius.et@outlook.org','BRI13DMK3FJ','Shaine Nunez','02/09/1970'),
  (96,'Vernon','gravida@protonmail.edu','UUV12REB6OV','Armando Gibbs','11/08/1977'),
  (97,'Angela','non.quam.pellentesque@yahoo.edu','KCV22WKI1EF','Sophia Booker','02/09/2009'),
  (98,'Demetria','enim.non@protonmail.org','TBB82WDB3ZU','Eve Reyes','08/13/1973'),
  (99,'Halee','lorem.tristique@google.couk','WKA59XFJ0ZL','Karyn Christian','04/11/1964'),
  (100,'Erich','fermentum.vel@yahoo.ca','YPG85MYS8PQ','Blythe Horton','12/03/2001'),
  (101,'Craig','cursus.vestibulum@google.net','NVV16UWT4BN','Callie Mclaughlin','07/22/2013'),
  (102,'Levi','ac@outlook.ca','MFE23GGD7VK','Brody Bass','05/24/1963'),
  (103,'Cody','gravida.non.sollicitudin@hotmail.edu','TRW52VZS2KL','Mark Fox','08/22/1960'),
  (104,'Graham','integer.aliquam.adipiscing@protonmail.net','VME36RMO2CP','Julie Jackson','08/13/1986'),
  (105,'Deirdre','in.lobortis.tellus@hotmail.net','FCI85JXP1SM','Gregory Conley','03/30/1974'),
  (106,'Bruno','sed@icloud.net','WMV05EED7MI','Marah Thompson','01/07/1986'),
  (107,'Ferdinand','tempor@aol.edu','OOF23FDG7SM','Wallace Bailey','06/18/1973'),
  (108,'Lillian','pharetra@outlook.edu','NKP51TKX6MP','Olivia Coffey','06/26/1983'),
  (109,'Galvin','faucibus.orci.luctus@yahoo.couk','FCG52AQL9FK','Martha Haynes','10/16/1984'),
  (110,'Macaulay','nec.ligula.consectetuer@outlook.couk','FWM52HDP0JY','Murphy Boyer','10/14/1997'),
  (111,'Rylee','arcu.curabitur@hotmail.net','XRN86HPH3ES','Kimberly Peterson','08/25/1952'),
  (112,'Frances','purus@hotmail.couk','RPY36ICP1TQ','Dai Whitley','09/16/1984'),
  (113,'Hayes2','ante@google.net','XNW56WDX7TB','Solomon Blackwell','03/12/1983'),
  (114,'Colt','malesuada.fames.ac@icloud.com','OKU36ZRW0BT','Amaya Forbes','10/26/1969'),
  (115,'Medge','quisque.imperdiet.erat@outlook.net','PMC67KFS7LF','Fritz Hester','04/09/1991'),
  (116,'Molly','dapibus.quam.quis@protonmail.couk','NEU57WUZ9JF','Lane Head','01/26/1989'),
  (117,'Barry','auctor.vitae@icloud.edu','GWG97XIW9TJ','Laura Shepherd','07/18/1988'),
  (118,'Roanna','ut.erat.sed@protonmail.couk','IID78TDM1VY','Halee Hayes','03/14/1950'),
  (119,'rylee123','a.ultricies@yahoo.com','VFV91QSO6RU','Germane Huffman','08/20/2014'),
  (120,'Illiana','lacus.mauris@icloud.edu','SFV51KLZ4JG','Sebastian Woods','02/15/1999'),
  (121,'Bompdf','bom.pdf@bom.pdf','KIW46HCE8XO','Bom Pdf', '06/15/1993'),
  (122,'Chastity','ac.facilisis@aol.edu','GUD13CTJ3WE','Ivory Terry','02/15/1975'),
  (123,'Ryan','elit.pellentesque@yahoo.net','YLJ21TKW9VJ','Thomas Shepherd','11/09/1961'),
  (124,'the_real_orlando','est.vitae@outlook.ca','ZYH08DKO0KM','Chaney Beard','04/07/1977'),
  (125,'Aidan','amet.massa.quisque@hotmail.net','NQH17PRH8SW','Ashton Gonzales','11/30/2001'),
  (126,'Hyatt','dui.lectus.rutrum@icloud.com','UMY75YMC5IG','Britanney Haley','09/19/1986'),
  (127,'Kelsey','fermentum.fermentum@yahoo.edu','FVS23PKM0RQ','Armando Hogan','06/12/1959'),
  (128,'Ashton','dolor.egestas@icloud.edu','PPK76TQC1MU','Griffith Velasquez','01/04/1966'),
  (129,'Cody2','odio@yahoo.net','TEC37KMD3XJ','Nicholas Downs','02/04/1980'),
  (130,'Stacey','tortor.nunc.commodo@icloud.net','HDH71PFI1BL','Russell Hampton','01/17/1981'),
  (131,'illi','consequat.auctor.nunc@aol.net','ZVB15TBA2RY','Mia Collier','09/02/2009'),
  (132,'Heather','senectus.et@hotmail.org','HCV74DCD6UJ','Dominique White','01/06/1960'),
  (133,'Armand','id@protonmail.ca','WGE46VKP0WI','Norman Barnes','11/15/1968'),
  (134,'hoid', 'hoid@gmail.com', '$2y$10$GLxQrIGvr9ZWPG/0PZHDn.z.pL15ae5TYcDcV6NfBpk4GSN5EHBT2', 'Hoid', '11/22/1954'),
  (135,'Stella','et.pede@icloud.couk','RYI24TUQ2QW','Michelle Clements','01/24/1955'),
  (136,'Camden','rhoncus@hotmail.couk','XOV91WHN6VU','Hedley Pope','05/22/1972'),
  (137,'Conan','bibendum@icloud.net','SCT69UGJ7AC','Akeem Woods','10/24/1998'),
  (138,'Mechelle','elit@protonmail.edu','LSU33CJW8HC','Kenneth Macdonald','01/22/1999'),
  (139,'Kelsey123','tellus.suspendisse.sed@google.com','UAY32XXW3VE','Barrett Day','11/28/1973'),
  (140,'Kenyon','curae.phasellus@outlook.com','UTO81UMC2MP','Zane Park','12/08/1966'),
  (141,'Ariel','scelerisque@yahoo.edu','DQU24CNQ2LU','Abdul Chang','07/20/2015'),
  (142,'Allistair','erat.volutpat@google.ca','CET26NNI2KV','Erica Glass','11/27/1957'),
  (143,'Seth','vivamus.molestie@google.ca','VHI82LRR6SA','Demetria Turner','03/30/1994'),
  (144,'Yoko','proin.velit.sed@yahoo.org','LBD77EEE1LU','Jescie Middleton','07/18/1961'),
  (145,'Mollie','pharetra.sed.hendrerit@protonmail.ca','UVQ87GVF4FO','Felicia Fowler','07/23/1973'),
  (146,'Justin','nisi.sem.semper@outlook.couk','HMQ19KOV8KW','Octavia Reynolds','11/16/2013'),
  (147,'Nina','dignissim.lacus.aliquam@hotmail.net','JLU31NBX7MT','Judith Holder','07/18/1953'),
  (148,'Clio','egestas.blandit.nam@yahoo.org','RJI68QAI6NW','Katell Mejia','06/09/1958'),
  (149,'manny','manny@gmail.com','$2y$10$dqEP9Wq4kAzewTNid8o9Z.bhS2uWwNeNL9JuXfLFiP0yg0gF918OK','Manny','08/29/2001');

select setval('users_id_seq', (select max(id) from users));
INSERT INTO users(username,is_admin,email,password,name,birthdate) VALUES ('admin','True','admin@eventful.com','$2y$10$TEww9EtxnNwNbst5EUMlbupRzJraYSCzQX848msWUu9aAKvm/hUO.','Admin','01/01/1960');
UPDATE users SET profile_pic='profile_pictures/default.png';
UPDATE users SET block_motive='No apparent reason' WHERE username='manny';

-- ========================= unblock_appeal =========================

INSERT INTO unblock_appeal(user_id,message) VALUES
  (120,'fringilla mi lacinia mattis. Integer eu'),
  (144,'Nullam feugiat placerat velit. Quisque varius. Nam porttitor'),
  (67,'Nulla interdum. Curabitur dictum. Phasellus in felis. Nulla tempor'),
  (14,'Quisque porttitor eros nec tellus. Nunc lectus pede, ultrices'),
  (86,'amet diam eu dolor egestas');

select setval('unblock_appeal_id_seq', (select max(id) from unblock_appeal));

-- ========================= event =========================

INSERT INTO event(id,host_id,title,event_image,description, location,creation_date,realization_date,is_visible,is_accessible,capacity,price) VALUES
  (0,10,'sed, sapien. Nunc','vel,','ac, fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra','P.O. Box 353, 6302 Fringilla Rd.', '2021-02-05 15:43:21', '2021-08-08 16:58:49','True','True',18,1),
  (1,31,'lorem, luctus ut,','non,','Nulla aliquet. Proin velit. Sed malesuada augue ut lacus. Nulla','439-3948 Lobortis St.', '2021-02-20 22:54:17', '2021-03-22 08:57:27','False','False',79,8),
  (2,52,'Nullam lobortis quam','at,','pulvinar arcu et pede. Nunc sed orci lobortis augue scelerisque','786-7331 Tincidunt Ave', '2021-03-17 13:09:55', '2021-04-23 12:04:36','False','True',89,7),
  (3,63,'parturient montes, nascetur','Nullam','nec, imperdiet nec, leo. Morbi neque tellus, imperdiet non, vestibulum','3805 Ipsum St.', '2021-11-19 04:52:55', '2021-12-26 06:44:34','False','True',10,6),
  (4,24,'sagittis placerat. Cras','amet,','est, congue a, aliquet vel, vulputate eu, odio. Phasellus at','3377 Ut Rd.', '2021-11-05 17:21:49', '2021-11-26 16:45:57','True','False',26,2),
  (5,15,'et magnis dis','felis','mus. Aenean eget magna. Suspendisse tristique neque venenatis lacus. Etiam','781-503 Metus Av.', '2020-11-30 09:28:58', '2021-12-24 00:21:46','False','False',44,1),
  (6,96,'a, malesuada id,','fringilla,','nunc sit amet metus. Aliquam erat volutpat. Nulla facilisis. Suspendisse','Ap #230-3870 Et St.', '2021-10-15 23:15:52', '2021-11-23 15:03:09','False','True',54,4),
  (7,127,'convallis ligula. Donec','Pellentesque','Proin vel arcu eu odio tristique pharetra. Quisque ac libero','Ap #925-7741 Pharetra. Road', '2021-03-14 06:25:36', '2021-05-16 02:18:45','False','True',8,1),
  (8,98,'vitae, erat. Vivamus','Nam','purus. Duis elementum, dui quis accumsan convallis, ante lectus convallis','225-5020 Tempor, Rd.', '2021-08-04 10:45:39', '2021-08-30 21:01:19','False','False',37,4),
  (9,49,'dignissim magna a','ante,','Pellentesque tincidunt tempus risus. Donec egestas. Duis ac arcu. Nunc','287-2179 Phasellus Ave', '2021-06-07 17:59:55', '2021-11-18 13:32:24','False','False',14,3),
  (10,110,'scelerisque sed, sapien.','vel','sollicitudin adipiscing ligula. Aenean gravida nunc sed pede. Cum sociis','Ap #305-9474 A, Road', '2021-03-16 15:39:45', '2021-03-19 16:04:28','False','False',91,1),
  (11,11,'adipiscing lobortis risus.','a','Vivamus molestie dapibus ligula. Aliquam erat volutpat. Nulla dignissim. Maecenas','Ap #142-5407 Orci, Av.', '2021-06-01 23:09:06', '2021-06-26 20:07:45','True','True',13,7),
  (12,72,'sit amet orci.','sem','at pretium aliquet, metus urna convallis erat, eget tincidunt dui','916-1172 Accumsan Av.', '2021-03-05 07:13:51', '2021-04-01 10:59:41','False','False',27,7),
  (13,143,'eu eros. Nam','justo','tincidunt adipiscing. Mauris molestie pharetra nibh. Aliquam ornare, libero at','P.O. Box 761, 9496 Elit, Rd.', '2020-01-13 20:19:17', '2020-12-02 13:38:36','True','True',69,10),
  (14,134,'nunc est, mollis','adipiscing','Aliquam ornare, libero at auctor ullamcorper, nisl arcu iaculis enim,','Ap #511-721 Ad St.', '2021-09-17 02:33:13', '2021-10-02 06:51:33','False','True',91,9),
  (15,15,'mi lacinia mattis.','ipsum','Nulla aliquet. Proin velit. Sed malesuada augue ut lacus. Nulla','P.O. Box 266, 7947 Sagittis St.','2019-12-21 06:40:54','2022-06-27 04:00:21','False','False',21,1),
  (16,91,'sem eget','tristique','faucibus leo, in lobortis tellus justo sit amet nulla.','886-7674 Donec Road','2020-02-18 09:43:39','2022-06-01 03:50:47','False','True',14,1),
  (17,72,'amet luctus vulputate, nisi','porttitor','non, dapibus rutrum, justo. Praesent luctus. Curabitur egestas nunc sed','P.O. Box 316, 9954 Et Avenue','2020-02-04 22:51:14','2022-02-22 16:38:32','False','True',56,8),
  (18,66,'sit amet, faucibus ut,','felis','Curabitur ut odio vel est tempor','P.O. Box 420, 4026 Diam St.','2020-09-24 09:19:54','2022-07-07 16:57:18','True','True',39,5),
  (19,46,'dui, semper et,','faucibus','vitae velit egestas lacinia. Sed congue, elit sed consequat','P.O. Box 826, 1661 Donec Rd.','2020-06-13 08:17:51','2022-10-28 07:51:47','False','True',71,5),
  (20,92,'ipsum leo','sed','dis parturient montes, nascetur ridiculus mus. Proin vel nisl. Quisque','Ap #339-4257 Quam, Street','2020-08-06 04:38:41','2022-04-02 00:52:51','False','False',90,6),
  (21,54,'et, rutrum','dolor,','fringilla, porttitor vulputate, posuere vulputate, lacus. Cras interdum. Nunc','449 Lacus, Rd.','2020-04-21 10:22:40','2022-11-12 15:51:17','True','False',1,7),
  (22,51,'eu tellus','at','condimentum. Donec at arcu. Vestibulum ante','Ap #961-9029 Nec Avenue','2020-10-12 01:26:07','2022-10-01 19:18:00','True','False',27,8),
  (23,60,'faucibus id,','metus','consequat, lectus sit amet luctus vulputate, nisi sem','P.O. Box 229, 7691 Aliquet Street','2020-04-08 04:31:12','2022-10-27 17:48:12','True','False',45,3),
  (24,5,'velit dui, semper','aliquet','auctor. Mauris vel turpis. Aliquam adipiscing lobortis risus.','184-4111 Dolor Avenue','2020-01-07 02:07:09','2022-07-30 00:57:12','False','False',88,9),
  (25,29,'Duis a mi','pretium','eu tempor erat neque non quam.','Ap #583-5475 Erat Ave','2020-11-16 20:23:02','2022-04-14 17:22:09','True','True',48,5),
  (26,110,'Maecenas ornare egestas ligula.','erat','Duis dignissim tempor arcu. Vestibulum ut eros','P.O. Box 376, 728 Ipsum Avenue','2020-06-18 20:44:04','2022-03-04 04:37:44','True','False',23,4),
  (27,146,'Curabitur dictum. Phasellus in','ultrices','facilisis lorem tristique aliquet. Phasellus fermentum','Ap #325-9739 Dui Road','2020-01-24 09:28:10','2022-05-01 10:41:38','False','False',50,9),
  (28,22,'semper auctor. Mauris','posuere','Suspendisse tristique neque venenatis lacus.','777-1131 Ipsum St.','2020-11-11 00:50:02','2022-09-19 13:01:31','False','False',25,3),
  (29,94,'id enim.','magna,','tincidunt aliquam arcu. Aliquam ultrices','Ap #220-7467 Fringilla, Avenue','2019-12-02 02:10:57','2022-10-09 18:05:12','True','True',54,6),
  (30,35,'magnis dis parturient montes,','cubilia','Mauris quis turpis vitae purus gravida','Ap #541-1337 Nulla. Road','2020-09-13 05:36:14','2022-05-23 02:04:23','True','True',95,9),
  (31,128,'faucibus ut, nulla.','leo.','congue, elit sed consequat auctor, nunc nulla vulputate dui, nec','Ap #766-1719 Rhoncus Road','2020-09-02 18:11:56','2022-11-09 19:26:45','True','True',89,9),
  (32,20,'sed leo.','vel,','Aliquam erat volutpat. Nulla dignissim. Maecenas ornare egestas ligula.','452-1734 Sed, Rd.','2020-08-15 06:32:03','2022-04-15 10:21:27','True','False',30,9),
  (33,101,'mauris. Integer','in,','cursus a, enim. Suspendisse aliquet, sem ut','Ap #399-6332 Proin Rd.','2019-12-29 14:18:11','2022-01-24 01:06:42','True','False',90,7),
  (34,85,'risus. Nunc','blandit','Mauris nulla. Integer urna. Vivamus molestie dapibus ligula. Aliquam erat','4752 Suscipit Rd.','2020-05-21 00:47:59','2022-08-05 13:46:36','True','True',21,1),
  (35,83,'adipiscing lacus.','malesuada','tellus eu augue porttitor interdum. Sed auctor','150-5991 Tellus. St.','2020-04-01 22:07:39','2022-09-23 00:01:11','True','False',57,1),
  (36,17,'aliquet. Phasellus fermentum','quam','purus. Nullam scelerisque neque sed sem egestas blandit.','381-5577 Suspendisse Rd.','2020-09-01 11:58:38','2022-04-02 09:18:08','False','True',81,3),
  (37,114,'adipiscing lacus.','fermentum','natoque penatibus et magnis dis parturient montes,','914-1053 Luctus St.','2020-09-11 06:55:56','2022-09-18 18:31:26','False','False',34,3),
  (38,100,'tempor bibendum. Donec','lectus','ac mi eleifend egestas. Sed pharetra,','Ap #952-3072 Nunc Ave','2020-08-23 06:18:54','2022-10-25 13:23:03','False','False',94,6),
  (39,10,'inceptos hymenaeos. Mauris','Nullam','arcu. Sed et libero. Proin','9060 Non Avenue','2020-03-14 23:15:04','2022-02-13 15:24:26','False','False',90,0),
  (40,0,'Etiam vestibulum massa rutrum','Nunc','non sapien molestie orci tincidunt','Ap #115-8616 Fringilla Avenue','2020-06-18 01:32:25','2022-03-15 07:12:03','False','True',66,9),
  (41,145,'tristique pharetra. Quisque','nisi','tincidunt, neque vitae semper egestas, urna justo','Ap #573-3017 A St.','2020-07-14 00:13:27','2022-07-18 04:21:01','True','False',57,8),
  (42,30,'tellus non','ipsum.','neque. Morbi quis urna. Nunc quis arcu vel quam','Ap #591-7166 Euismod Avenue','2020-03-14 01:14:19','2022-04-15 13:13:10','True','True',70,3),
  (43,37,'et magnis','nec','quis diam luctus lobortis. Class aptent taciti sociosqu ad litora','434-4819 Blandit St.','2020-09-06 17:39:48','2022-04-29 00:25:20','True','True',31,9),
  (44,121,'In lorem. Donec','Suspendisse','conubia nostra, per inceptos hymenaeos. Mauris','Ap #841-1182 Quis St.','2020-07-08 09:19:15','2022-01-26 11:33:36','False','False',94,9),
  (45,106,'eget magna.','feugiat.','vitae sodales nisi magna sed dui. Fusce','Ap #248-8521 Donec Rd.','2020-11-24 22:01:27','2022-09-19 04:36:18','False','False',14,2),
  (46,125,'faucibus orci luctus','sapien.','tempor diam dictum sapien. Aenean','Ap #566-6337 Erat Rd.','2020-03-20 02:16:01','2022-04-06 11:46:59','False','True',47,2),
  (47,12,'Pellentesque ut ipsum','egestas','arcu vel quam dignissim pharetra. Nam','619-9412 Nisl Rd.','2020-11-28 05:52:44','2022-07-03 00:18:27','True','True',17,6),
  (48,119,'Quisque nonummy ipsum non','Vivamus','eu, odio. Phasellus at augue id ante dictum','7045 Aliquam Ave','2020-04-18 23:59:09','2022-04-21 06:34:06','False','True',18,4),
  (49,105,'eget magna.','in','lectus quis massa. Mauris vestibulum, neque','Ap #799-8720 Morbi Av.','2020-08-03 18:59:37','2022-04-03 05:03:22','False','True',86,2),
  (50,75,'cursus vestibulum.','senectus','eget laoreet posuere, enim nisl elementum purus, accumsan','475-7969 Cursus St.','2020-04-09 00:05:21','2022-03-03 08:55:20','True','False',37,2),
  (51,109,'imperdiet dictum magna. Ut','eget','et malesuada fames ac turpis','161-3456 Ornare St.','2020-08-03 02:22:51','2022-06-11 01:44:53','True','True',79,3),
  (52,107,'Nunc lectus','ipsum.','tincidunt orci quis lectus. Nullam suscipit, est ac facilisis','1318 Augue. St.','2020-08-18 16:02:21','2022-05-25 10:29:30','False','True',43,4),
  (53,94,'ac, fermentum vel,','placerat.','aliquam eros turpis non enim. Mauris','Ap #730-9611 Integer Ave','2020-04-10 17:24:28','2022-02-12 14:25:02','True','False',5,8),
  (54,22,'nec tellus.','fames','quis, pede. Suspendisse dui. Fusce diam nunc,','Ap #521-9196 Aliquam Road','2020-01-20 06:52:22','2022-04-15 12:14:18','False','False',60,7),
  (55,38,'tempus eu, ligula.','neque','leo, in lobortis tellus justo sit amet','P.O. Box 694, 8499 Eros Avenue','2020-09-10 00:31:34','2022-09-30 06:33:16','False','False',10,8),
  (56,32,'eleifend vitae, erat.','posuere','mi, ac mattis velit justo nec ante. Maecenas mi felis,','P.O. Box 221, 271 Luctus Rd.','2020-09-10 03:00:02','2022-08-01 23:21:46','False','False',30,6),
  (57,10,'ultrices sit','at','mi felis, adipiscing fringilla, porttitor vulputate, posuere vulputate, lacus.','130-9144 In Avenue','2020-06-08 04:21:55','2022-06-23 08:21:05','False','False',27,1),
  (58,101,'molestie pharetra','fringilla','tellus. Nunc lectus pede, ultrices a, auctor','P.O. Box 239, 6919 Nisl. Ave','2020-11-06 21:03:17','2022-07-09 07:37:15','True','True',95,7),
  (59,34,'eget varius ultrices, mauris','ut','arcu. Vestibulum ut eros non enim commodo hendrerit.','Ap #567-3376 Vestibulum. Rd.','2020-09-15 03:29:46','2022-08-14 05:59:32','True','True',35,9),
  (60,23,'at lacus. Quisque purus','a,','nec mauris blandit mattis. Cras eget','6455 Tristique Ave','2020-01-09 15:47:04','2022-11-07 10:42:15','False','True',54,5),
  (61,57,'Donec tempor, est','Sed','amet, dapibus id, blandit at, nisi.','285-1526 Mauris Ave','2020-03-30 12:58:53','2022-07-21 11:16:07','True','True',3,0),
  (62,41,'magna. Praesent','natoque','aptent taciti sociosqu ad litora torquent per','372-7365 Dapibus Av.','2020-11-28 04:37:22','2022-07-28 19:51:15','False','True',12,5),
  (63,72,'odio, auctor vitae,','euismod','non dui nec urna suscipit nonummy. Fusce fermentum fermentum','Ap #895-815 Eu Avenue','2020-07-11 01:30:35','2022-10-14 01:50:44','False','False',74,2),
  (64,69,'pellentesque eget, dictum','fermentum','a nunc. In at pede. Cras vulputate velit eu','Ap #770-5029 Auctor Rd.','2020-06-07 18:33:42','2022-04-04 08:22:17','False','False',92,3),
  (65,4,'dolor, nonummy','Mauris','arcu. Sed eu nibh vulputate','P.O. Box 715, 6388 Ligula St.','2020-01-08 14:04:14','2022-10-23 03:48:03','True','False',65,1),
  (66,28,'commodo hendrerit.','eu','Phasellus elit pede, malesuada vel, venenatis vel, faucibus','128-977 Quam Rd.','2020-11-15 09:50:53','2022-10-28 06:02:49','False','True',54,2),
  (67,74,'laoreet, libero et','Aliquam','vitae mauris sit amet lorem semper auctor. Mauris','Ap #466-5027 Aliquet, Av.','2020-11-03 12:49:50','2022-04-15 12:06:36','False','False',5,6),
  (68,16,'ante dictum cursus. Nunc','mi','elit pede, malesuada vel, venenatis vel,','3968 Mi. St.','2019-12-04 17:01:29','2022-01-02 13:53:09','False','False',93,2),
  (69,136,'iaculis enim, sit','litora','quis diam. Pellentesque habitant morbi tristique senectus','561-6396 Tempus St.','2020-09-14 15:56:36','2022-03-12 11:37:29','False','True',31,6),
  (70,87,'elementum, lorem','Sed','eget tincidunt dui augue eu tellus. Phasellus','Ap #777-4579 Nec Road','2020-05-28 12:06:08','2022-03-02 12:23:31','True','False',5,9),
  (71,131,'consectetuer rhoncus. Nullam','luctus','pharetra ut, pharetra sed, hendrerit','621-9094 Velit. Rd.','2020-08-11 07:09:11','2022-08-06 12:40:18','True','False',68,4),
  (72,69,'adipiscing fringilla, porttitor','Nulla','Nullam enim. Sed nulla ante, iaculis nec, eleifend non,','172-7982 Sed Av.','2020-01-03 05:12:41','2021-12-03 19:13:20','True','False',54,2),
  (73,113,'in consectetuer ipsum','pharetra.','Duis ac arcu. Nunc mauris. Morbi non sapien molestie','Ap #329-6462 Proin St.','2020-04-29 02:58:52','2022-04-18 20:37:31','False','True',91,10),
  (74,96,'tempor diam dictum','nulla','lectus rutrum urna, nec luctus felis purus ac','Ap #233-8434 Aliquam Rd.','2020-10-23 11:34:29','2022-11-16 15:19:26','True','True',12,4),
  (75,98,'Praesent eu nulla at','imperdiet','mauris a nunc. In at pede. Cras vulputate velit','Ap #250-2500 Tincidunt Av.','2020-04-03 06:13:12','2022-05-20 11:13:26','False','False',4,6),
  (76,122,'urna. Nunc','quam','vel nisl. Quisque fringilla euismod enim. Etiam','240-6677 In, Ave','2020-07-17 07:59:28','2022-08-08 16:55:42','True','False',64,5),
  (77,147,'Etiam laoreet, libero et','vel,','pretium neque. Morbi quis urna. Nunc quis arcu','105-8154 Lorem Ave','2020-07-26 08:29:25','2021-12-31 14:11:48','False','False',74,3),
  (78,113,'ipsum. Suspendisse non leo.','eu','molestie sodales. Mauris blandit enim consequat purus. Maecenas libero','580-6364 Diam St.','2020-11-09 10:58:57','2022-09-26 09:53:49','False','False',23,0),
  (79,67,'adipiscing ligula. Aenean','id,','vestibulum, neque sed dictum eleifend, nunc risus varius','Ap #827-3065 Ipsum St.','2020-11-15 08:58:28','2022-07-23 05:40:40','True','True',13,10),
  (80,141,'Vestibulum ante','mi','ut quam vel sapien imperdiet ornare. In faucibus. Morbi','340-3107 Accumsan Av.','2019-12-11 05:28:43','2022-09-15 14:43:01','True','False',3,2),
  (81,3,'semper cursus. Integer mollis.','ornare,','dictum cursus. Nunc mauris elit, dictum eu, eleifend nec, malesuada','Ap #727-883 Tincidunt Rd.','2019-12-10 10:11:42','2022-07-27 02:57:13','False','False',18,8),
  (82,36,'Nulla interdum. Curabitur dictum.','risus.','blandit viverra. Donec tempus, lorem fringilla','2537 Ornare. Ave','2020-02-12 00:55:12','2022-01-11 07:58:53','False','True',30,9),
  (83,119,'Fusce fermentum','vitae','dolor dolor, tempus non, lacinia at, iaculis','Ap #295-4743 Mus. Rd.','2020-03-27 03:31:59','2022-01-17 11:52:16','False','False',46,7),
  (84,37,'gravida mauris','vestibulum','ultricies ligula. Nullam enim. Sed nulla ante, iaculis','P.O. Box 727, 3689 Ultrices Rd.','2020-03-17 10:29:54','2022-01-12 11:03:56','False','False',68,1),
  (85,103,'a ultricies adipiscing,','ac','ultricies ornare, elit elit fermentum','2526 Augue St.','2020-05-17 00:16:59','2021-12-09 15:21:03','False','True',42,9),
  (86,35,'Fusce feugiat. Lorem ipsum','tempus','nibh. Aliquam ornare, libero at auctor ullamcorper, nisl arcu','Ap #192-3332 Egestas. Rd.','2020-09-03 03:20:52','2022-01-12 06:19:19','True','False',8,7),
  (87,38,'mollis. Phasellus libero','Donec','tristique senectus et netus et malesuada fames ac turpis','189-3853 Vel St.','2020-07-07 01:11:07','2022-01-09 17:17:24','True','True',80,3),
  (88,116,'nascetur ridiculus','neque','lorem. Donec elementum, lorem ut aliquam iaculis,','390-5385 Nullam Rd.','2020-03-09 08:43:09','2022-06-24 01:46:38','True','False',72,8),
  (89,60,'volutpat ornare, facilisis','cursus','aptent taciti sociosqu ad litora torquent per conubia nostra,','923-6428 Metus. Av.','2020-01-26 05:08:25','2022-08-20 07:30:50','True','False',43,7),
  (90,139,'arcu. Aliquam ultrices','eleifend','aliquet libero. Integer in magna. Phasellus','P.O. Box 546, 2929 Facilisis. Avenue','2020-08-07 06:21:01','2022-05-28 07:01:09','False','False',40,8),
  (91,36,'blandit. Nam nulla','Aliquam','lorem eu metus. In lorem. Donec','Ap #144-5252 Eleifend. Road','2020-04-23 19:56:24','2022-08-02 17:16:34','True','True',43,4),
  (92,112,'sed, est. Nunc laoreet','mauris','Nullam feugiat placerat velit. Quisque varius. Nam porttitor scelerisque','P.O. Box 872, 6527 At Rd.','2020-05-28 23:54:00','2022-07-12 21:10:16','True','False',36,8),
  (93,37,'non massa','quis','quis, pede. Praesent eu dui. Cum','505-8349 Dolor. Road','2020-01-13 00:55:32','2022-06-29 03:28:04','False','True',73,3),
  (94,103,'vehicula risus.','augue','elit, pharetra ut, pharetra sed, hendrerit a,','593-9215 Ipsum. Ave','2020-04-16 22:43:39','2022-10-02 02:20:45','False','False',93,6),
  (95,96,'vel, vulputate eu,','Cras','lacus. Quisque imperdiet, erat nonummy ultricies','840-2830 Mauris, St.','2020-02-12 05:58:21','2022-02-24 19:45:34','True','False',90,2),
  (96,104,'eu erat','nunc','nec, malesuada ut, sem. Nulla interdum. Curabitur','Ap #117-8711 Adipiscing Avenue','2020-11-03 03:50:54','2022-09-30 07:27:31','False','False',49,0),
  (97,29,'Sed id risus quis','convallis','eleifend nec, malesuada ut, sem.','Ap #663-2353 Maecenas Road','2020-03-25 00:57:57','2022-07-01 10:46:13','True','False',78,0),
  (98,13,'sed tortor. Integer','nulla.','lectus rutrum urna, nec luctus','Ap #235-6324 Aliquam Ave','2019-12-19 22:18:07','2022-06-15 16:23:07','True','False',52,0),
  (99,32,'arcu imperdiet ullamcorper.','cursus','et netus et malesuada fames ac turpis egestas. Aliquam','Ap #535-3306 Eu, Street','2020-03-23 09:11:42','2022-09-14 01:07:11','False','False',70,6),
  (100,124,'fringilla euismod enim.','sodales','adipiscing non, luctus sit amet, faucibus ut,','Ap #561-2540 Purus Street','2020-02-12 05:38:11','2022-06-22 04:13:44','True','True',31,0),
  (101,42,'amet, risus. Donec','ac,','lobortis, nisi nibh lacinia orci, consectetuer euismod','346-1035 Risus. St.','2020-05-21 02:03:47','2022-03-27 15:05:50','False','False',62,5),
  (102,7,'convallis in, cursus','Nam','ante ipsum primis in faucibus orci luctus et','3857 Egestas. Rd.','2020-11-16 23:15:25','2022-01-19 18:29:28','False','True',22,6),
  (103,129,'cubilia Curae Phasellus ornare.','quam','libero lacus, varius et, euismod et, commodo at, libero.','P.O. Box 355, 4870 Amet, St.','2020-05-04 09:13:30','2022-07-13 13:44:13','True','False',56,5),
  (104,82,'ullamcorper, velit in','non,','Phasellus fermentum convallis ligula. Donec','213-6857 Rutrum Rd.','2020-04-08 04:22:03','2022-04-07 20:43:05','True','True',85,8),
  (105,98,'ipsum. Suspendisse non','tincidunt','lobortis risus. In mi pede, nonummy','Ap #998-8435 Augue Rd.','2020-05-09 14:42:14','2022-02-19 00:58:26','True','True',68,1),
  (106,22,'massa. Mauris vestibulum,','et','tristique senectus et netus et malesuada','941-7301 Taciti Avenue','2020-08-18 21:47:14','2022-06-06 05:31:49','True','False',50,6),
  (107,33,'euismod urna.','Quisque','arcu. Aliquam ultrices iaculis odio.','924-3865 Imperdiet Rd.','2019-12-12 01:50:32','2022-06-17 04:59:24','True','False',87,0),
  (108,82,'Etiam gravida','nibh.','Donec luctus aliquet odio. Etiam ligula','P.O. Box 997, 6574 Lorem Rd.','2020-10-10 22:58:54','2022-07-23 04:28:55','True','False',59,10),
  (109,84,'Pellentesque ultricies dignissim','tempus','Donec sollicitudin adipiscing ligula. Aenean gravida nunc sed','P.O. Box 386, 3111 Suscipit St.','2020-09-07 05:29:22','2022-04-12 19:28:32','True','True',7,9),
  (110,114,'purus mauris a','urna,','sed dolor. Fusce mi lorem, vehicula et, rutrum','880-9721 Quis St.','2020-10-28 08:44:13','2022-06-18 22:41:40','True','False',97,1),
  (111,33,'ultrices iaculis odio. Nam','sociis','id, ante. Nunc mauris sapien, cursus in, hendrerit consectetuer,','Ap #751-9061 Lorem, Ave','2020-10-04 10:28:14','2022-04-23 02:07:35','True','True',31,9),
  (112,28,'Ut semper pretium','dictum','risus, at fringilla purus mauris a nunc. In at','528-3069 Molestie Street','2020-03-21 22:24:11','2022-09-18 19:47:13','True','False',58,7),
  (113,93,'dolor dapibus gravida.','sed','vitae, erat. Vivamus nisi. Mauris','461-8852 Duis Ave','2020-06-08 02:00:45','2022-11-11 01:17:07','False','False',33,5),
  (114,96,'eu dolor egestas','Cras','Nunc mauris. Morbi non sapien molestie orci','5687 Cursus St.','2020-08-10 16:19:48','2022-10-24 10:28:12','True','True',68,9),
  (115,131,'Lorem ipsum','elit.','lorem ipsum sodales purus, in','842-2117 Velit Av.','2020-03-01 02:22:17','2022-10-16 16:32:24','True','True',98,9),
  (116,38,'Sed id risus','In','varius et, euismod et, commodo at, libero.','Ap #176-3073 Mi Av.','2020-07-03 19:38:27','2022-05-16 19:32:52','False','False',50,7),
  (117,117,'Cras pellentesque. Sed dictum.','vel','Praesent eu dui. Cum sociis natoque penatibus et','Ap #303-5061 Eu St.','2020-07-31 11:41:03','2022-07-12 01:16:21','False','True',25,7),
  (118,78,'Ut nec urna','ante,','turpis. Nulla aliquet. Proin velit. Sed','376-3737 Mauris. Rd.','2020-03-25 08:03:02','2022-02-26 22:37:49','False','True',29,9),
  (119,147,'libero nec ligula','torquent','nec tellus. Nunc lectus pede, ultrices a, auctor','9032 In St.','2020-10-20 17:41:57','2022-07-04 11:31:45','True','False',79,2),
  (120,89,'turpis. In','Duis','aliquam eros turpis non enim. Mauris quis','Ap #375-3375 Mauris St.','2020-01-25 18:28:39','2022-07-21 07:22:40','False','False',42,7),
  (121,38,'mattis velit','malesuada','rutrum magna. Cras convallis convallis dolor.','256-5648 Nibh. St.','2020-05-04 21:49:13','2022-02-07 19:38:24','False','False',38,3),
  (122,41,'luctus ut,','semper.','sed, sapien. Nunc pulvinar arcu et','9264 Pede, St.','2020-10-08 01:45:58','2022-07-15 05:49:23','False','True',60,8),
  (123,84,'posuere cubilia','nibh.','Curae Phasellus ornare. Fusce mollis. Duis sit amet','Ap #343-6134 Lobortis, St.','2020-11-20 10:16:13','2021-12-09 20:05:04','False','True',64,5),
  (124,3,'tellus eu augue porttitor','convallis','ut aliquam iaculis, lacus pede sagittis','Ap #441-9735 Enim Rd.','2020-01-17 02:51:57','2022-06-04 15:51:35','False','False',76,4),
  (125,121,'lorem eu metus.','ornare','non, feugiat nec, diam. Duis mi','P.O. Box 270, 1190 Nec, Av.','2020-11-15 02:31:41','2022-10-15 17:54:54','True','False',86,9),
  (126,117,'Sed neque. Sed','Mauris','ultrices sit amet, risus. Donec nibh enim,','P.O. Box 385, 9427 Nunc St.','2020-03-10 18:40:20','2022-04-07 21:45:57','True','True',13,6),
  (127,118,'dictum placerat, augue.','non,','In lorem. Donec elementum, lorem ut aliquam iaculis,','Ap #549-1996 Hendrerit Street','2020-08-16 18:06:54','2021-12-02 07:10:34','True','True',62,7),
  (128,118,'fringilla est. Mauris eu','erat','a odio semper cursus. Integer mollis. Integer tincidunt aliquam','Ap #170-9007 Convallis, Ave','2020-09-03 15:54:59','2022-02-28 15:20:59','True','False',88,9),
  (129,113,'et magnis dis','lectus','nibh. Aliquam ornare, libero at auctor ullamcorper, nisl','379-5566 Ipsum Av.','2020-10-20 02:46:22','2022-01-18 22:56:34','False','True',71,9),
  (130,6,'augue malesuada malesuada. Integer','Donec','tempor, est ac mattis semper, dui lectus rutrum urna,','Ap #488-9089 Tempus Rd.','2020-09-28 07:42:03','2021-12-15 16:14:06','False','False',22,6),
  (131,3,'lacus. Etiam bibendum fermentum','Donec','In scelerisque scelerisque dui. Suspendisse ac','4485 Mauris St.','2020-08-04 16:19:43','2022-09-30 02:56:25','False','False',43,4),
  (132,63,'Proin mi. Aliquam','aliquet,','dictum magna. Ut tincidunt orci quis','2629 Ante, Av.','2020-04-20 04:33:44','2022-11-15 00:46:35','True','True',24,3),
  (133,11,'ligula. Aenean','Etiam','adipiscing elit. Aliquam auctor, velit eget laoreet posuere, enim nisl','137-4399 Semper, Street','2020-08-29 09:46:38','2022-08-04 10:40:55','True','False',36,1),
  (134,56,'non, sollicitudin a,','rhoncus.','consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing','Ap #689-2838 At Avenue','2020-05-11 22:11:29','2021-12-31 09:32:32','False','True',40,10),
  (135,32,'Mauris molestie pharetra','Integer','nisl. Nulla eu neque pellentesque massa lobortis','Ap #755-7033 Arcu. Rd.','2020-03-03 13:24:02','2022-10-30 06:21:11','False','True',75,4),
  (136,52,'iaculis aliquet','Quisque','sollicitudin a, malesuada id, erat. Etiam vestibulum massa','P.O. Box 543, 1593 Dictum Av.','2020-05-28 23:01:10','2022-07-31 05:59:40','False','True',58,7),
  (137,40,'Donec felis orci,','vehicula.','mauris sapien, cursus in, hendrerit consectetuer, cursus et, magna.','Ap #919-6380 Non Road','2020-09-09 23:17:42','2022-05-26 18:31:10','True','False',99,4),
  (138,55,'euismod ac, fermentum','vitae','Nunc mauris sapien, cursus in,','Ap #877-6798 Tristique Rd.','2020-10-05 13:11:10','2022-07-18 18:29:40','True','True',79,8),
  (139,81,'ipsum primis in faucibus','faucibus','blandit mattis. Cras eget nisi dictum augue malesuada malesuada.','P.O. Box 977, 9081 Mollis. Ave','2020-04-14 19:05:14','2022-08-01 18:55:31','False','True',19,0),
  (140,148,'at risus. Nunc ac','molestie','dolor dapibus gravida. Aliquam tincidunt, nunc ac mattis ornare,','Ap #323-6197 Nisi St.','2020-10-19 13:27:42','2021-12-10 00:59:06','True','False',39,5),
  (141,89,'Etiam imperdiet','ut','ornare. Fusce mollis. Duis sit amet diam eu','897-3519 Erat Road','2020-10-18 09:59:12','2022-03-24 10:55:16','False','True',8,6),
  (142,66,'mollis nec,','mattis','nisi magna sed dui. Fusce aliquam, enim nec tempus','518-7145 Etiam Avenue','2020-03-28 03:21:09','2022-05-04 03:10:15','False','True',43,5),
  (143,10,'Suspendisse dui. Fusce','varius','semper cursus. Integer mollis. Integer tincidunt aliquam arcu. Aliquam','592-1212 Pellentesque, St.','2020-07-29 19:54:12','2022-04-11 01:17:38','True','False',44,8),
  (144,12,'scelerisque, lorem ipsum','magnis','eget varius ultrices, mauris ipsum porta','616-2124 Metus St.','2020-01-08 10:49:13','2022-10-28 06:20:28','True','False',92,9),
  (145,58,'erat, in consectetuer','cursus','Duis risus odio, auctor vitae, aliquet nec, imperdiet','P.O. Box 370, 343 Diam Street','2020-06-24 17:49:39','2022-02-18 11:39:27','True','False',39,6),
  (146,56,'pulvinar arcu et','Praesent','nulla ante, iaculis nec, eleifend non, dapibus rutrum, justo. Praesent','745-8737 Condimentum Rd.','2020-11-24 01:33:18','2022-11-11 17:18:56','True','False',43,7),
  (147,54,'libero lacus, varius','egestas.','malesuada malesuada. Integer id magna et','P.O. Box 158, 2011 Mi, Rd.','2020-05-10 20:14:48','2022-06-27 12:13:41','True','False',56,1),
  (148,124,'tempus non, lacinia','ac','sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer','765-2936 Nulla Rd.','2020-10-26 01:19:20','2022-05-14 17:08:57','True','True',40,4),
  (149,125,'luctus et ultrices','purus,','lectus rutrum urna, nec luctus felis purus','Ap #920-4292 Imperdiet Rd.','2020-09-20 04:10:18','2022-05-31 01:47:22','True','True',25,9);

SELECT setval('event_id_seq', (SELECT max(id) FROM event));
UPDATE event SET event_image='images/default.png';

-- ========================= attendee =========================

INSERT INTO attendee(user_id,event_id) VALUES
  (76,99),
  (23,76),
  (129,110),
  (79,129),
  (55,125),
  (10,51),
  (28,57),
  (88,97),
  (13,42),
  (59,133),
  (74,34),
  (143,92),
  (101,48),
  (54,87),
  (26,116),
  (41,127),
  (86,22),
  (93,21),
  (53,91),
  (82,127),
  (81,15),
  (83,93),
  (129,55),
  (78,27),
  (55,130),
  (6,15),
  (121,51),
  (46,122),
  (108,146),
  (114,116),
  (78,55),
  (119,114),
  (96,20),
  (72,129),
  (107,101),
  (125,91),
  (46,130),
  (52,94),
  (142,100),
  (71,141),
  (125,51),
  (93,80),
  (102,35),
  (73,112),
  (37,65),
  (35,122),
  (13,113),
  (99,128),
  (34,112),
  (45,16),
  (124,103),
  (40,139),
  (94,92),
  (59,112),
  (18,92),
  (117,5),
  (117,33),
  (29,102),
  (76,127),
  (141,139),
  (92,105),
  (148,125),
  (81,58),
  (140,3),
  (82,29),
  (110,92),
  (17,35),
  (13,8),
  (27,82),
  (1,122),
  (59,73),
  (98,61),
  (148,5),
  (103,12),
  (144,123),
  (126,61),
  (53,74),
  (44,33),
  (51,76),
  (99,134),
  (115,84),
  (59,62),
  (107,130),
  (16,13),
  (39,60),
  (99,31),
  (106,102),
  (44,92),
  (8,66),
  (109,58),
  (48,38),
  (122,142),
  (7,60),
  (139,105),
  (38,107),
  (108,67),
  (95,12),
  (134,31),
  (107,72),
  (100,147),
  (62,50),
  (106,72),
  (88,90),
  (118,52),
  (137,72),
  (87,33),
  (111,70),
  (72,55),
  (87,147),
  (137,54),
  (100,41),
  (5,143),
  (141,141),
  (45,79),
  (110,146),
  (36,137),
  (90,73),
  (103,20),
  (83,123),
  (22,12),
  (123,129),
  (49,84),
  (144,66),
  (21,32),
  (58,103),
  (32,69),
  (14,18),
  (124,77),
  (116,98),
  (89,43),
  (120,5),
  (112,126),
  (2,126),
  (3,126),
  (131,16),
  (112,116),
  (110,135),
  (90,41),
  (53,55),
  (78,6),
  (40,7),
  (33,5),
  (31,12),
  (18,5),
  (35,1),
  (139,10),
  (56,14),
  (43,7),
  (139,5),
  (134,3),
  (104,0),
  (46,0),
  (123,14),
  (146,2),
  (116,5),
  (12,13),
  (42,10),
  (102,12),
  (109,4),
  (134,9),
  (132,2),
  (139,1),
  (113,0),
  (41,12),
  (74,23),
  (37,36),
  (23,30),
  (39,42),
  (50,63),
  (28,54),
  (46,6),
  (5,9),
  (71,13),
  (33,85),
  (19,11),
  (77,1),
  (40,10),
  (114,4),
  (69,13),
  (41,129),
  (5,125),
  (65,76),
  (7,55),
  (134,2);

-- ========================= request =========================

INSERT INTO request(id,event_id,date,accepted,user_id) VALUES
  (0,1, '2020-01-03 15:24:45','False',97),
  (1,8, '2020-04-04 15:36:08','False',58),
  (2,12, '2021-06-23 20:24:06','False',40),
  (3,9, '2020-02-27 13:56:31','False',119),
  (4,5, '2021-09-01 04:51:03','True',128);

select setval('request_id_seq', (select max(id) from request));

-- ========================= invite =========================

INSERT INTO invite(id,event_id,date,accepted,inviter_id,invitee_id) VALUES
  (0,12, '2020-02-19 13:12:50','True',90,84),
  (1,7, '2019-12-04 23:00:07','True',48,2),
  (2,6, '2021-05-21 14:34:51','True',67,129),
  (3,3, '2020-09-04 16:04:02','False',12,10),
  (4,13, '2021-03-07 21:27:24','False',81,49);

select setval('invite_id_seq', (select max(id) from invite));

-- ========================= tag =========================

INSERT INTO tag(id,name) VALUES
  (0, 'Family'),
  (1, 'Sport'),
  (2, 'Music'),
  (3, 'Technology'),
  (4, 'Cinema'),
  (5, 'Theater'),
  (6, 'LBAW'),
  (7, 'Gaming'),
  (8, 'Charity'),
  (9, 'Driving'),
  (10, 'Literature'),
  (11, 'Super Heros'),
  (12, 'Fashion'),
  (13, 'Learning'),
  (14, 'CTF');

-- ========================= post =========================

/*
INSERT INTO post(id,title,description,creation_date,event_id) VALUES
  (0,'elit.','gravida sagittis. Duis gravida. Praesent eu nulla at sem','2021-10-20 20:06:02',126),
  (1,'eu','lorem, eget mollis lectus pede et risus. Quisque','2020-12-19 10:41:51',92),
  (2,'tellus.','ipsum cursus vestibulum. Mauris magna. Duis','2021-02-09 04:16:31',10),
  (3,'orci,','leo. Cras vehicula aliquet libero.','2021-03-16 09:01:53',0),
  (4,'nec,','ultrices, mauris ipsum porta elit,','2021-10-19 06:34:01',8),
  (5,'in','dignissim. Maecenas ornare egestas ligula.','2020-03-24 17:44:53',11),
  (6,'Phasellus','non sapien molestie orci tincidunt adipiscing. Mauris molestie pharetra','2021-09-16 19:46:26',14),
  (7,'magna','Cras lorem lorem, luctus ut, pellentesque eget, dictum placerat, augue.','2021-02-10 16:54:57',3),
  (8,'eu','arcu eu odio tristique pharetra. Quisque ac libero nec','2020-01-03 00:44:07',5),
  (9,'porttitor','Aenean eget metus. In nec','2020-03-16 17:55:06',9),
  (10,'hendrerit','lorem, luctus ut, pellentesque eget, dictum','2020-03-10 18:39:08',101),
  (11,'Vestibulum','tempus mauris erat eget ipsum. Suspendisse sagittis. Nullam','2020-05-31 05:16:06',10),
  (12,'lorem.','vel arcu. Curabitur ut odio vel est tempor','2021-09-03 21:03:33',3),
  (13,'Sed','Quisque imperdiet, erat nonummy ultricies ornare, elit elit','2020-02-20 12:43:29',5),
  (14,'Class','tincidunt congue turpis. In condimentum.','2019-12-19 09:18:41',6),
  (15,'quis,','aliquet, sem ut cursus luctus, ipsum leo elementum sem,','2019-12-23 18:12:51',8),
  (16,'interdum','rutrum magna. Cras convallis convallis dolor.','2020-03-22 13:41:37',8),
  (17,'velit','ipsum cursus vestibulum. Mauris magna. Duis','2021-10-21 03:00:07',6),
  (18,'vulputate','molestie orci tincidunt adipiscing. Mauris','2020-11-24 19:53:05',11),
  (19,'mus.','Cras dictum ultricies ligula. Nullam enim. Sed','2021-07-26 17:13:41',8),
  (20,'dolor','dolor sit amet, consectetuer adipiscing elit.','2021-05-06 10:00:23',7),
  (21,'malesuada','lacinia. Sed congue, elit sed consequat','2019-11-25 09:12:41',11),
  (22,'Mauris','et, magna. Praesent interdum ligula eu enim. Etiam','2020-07-20 15:42:16',12),
  (23,'laoreet,','arcu. Vestibulum ante ipsum primis in','2020-01-18 18:57:44',5),
  (24,'lorem','in, dolor. Fusce feugiat. Lorem','2020-01-18 05:04:22',4),
  (25,'placerat','semper tellus id nunc interdum feugiat.','2021-07-09 08:57:49',9),
  (26,'Aliquam','a tortor. Nunc commodo auctor velit. Aliquam','2021-08-08 06:55:21',12),
  (27,'odio,','Nunc laoreet lectus quis massa. Mauris vestibulum, neque sed','2021-10-14 11:46:34',9),
  (28,'scelerisque','orci quis lectus. Nullam suscipit, est ac','2020-03-27 06:42:38',3),
  (29,'taciti','primis in faucibus orci luctus et ultrices posuere cubilia','2021-01-31 19:22:26',13),
  (30,'eget','Aliquam auctor, velit eget laoreet','2020-06-20 05:25:24',6),
  (31,'Nulla','pharetra. Nam ac nulla. In tincidunt congue turpis. In','2020-07-17 18:06:53',4),
  (32,'convallis','mus. Proin vel arcu eu odio','2020-06-11 15:20:18',6),
  (33,'sagittis','vitae diam. Proin dolor. Nulla','2021-10-28 04:39:13',5),
  (34,'tincidunt','nec mauris blandit mattis. Cras eget nisi dictum augue','2021-04-02 15:48:17',6),
  (35,'mi','ullamcorper viverra. Maecenas iaculis aliquet diam. Sed diam lorem,','2019-12-28 22:34:24',13),
  (36,'dignissim','euismod in, dolor. Fusce feugiat. Lorem ipsum dolor sit amet,','2021-07-17 20:04:17',4),
  (37,'Phasellus','risus. Nulla eget metus eu erat semper rutrum.','2020-04-17 16:37:18',9),
  (38,'nec','tristique ac, eleifend vitae, erat.','2021-05-08 18:26:13',7),
  (39,'mauris','eleifend nec, malesuada ut, sem. Nulla interdum.','2020-06-06 09:20:45',4),
  (40,'risus.','porta elit, a feugiat tellus','2020-11-08 16:42:06',2),
  (41,'Curabitur','consectetuer mauris id sapien. Cras dolor','2020-03-24 09:40:55',6),
  (42,'in','tempus non, lacinia at, iaculis quis, pede.','2020-04-15 12:31:59',4),
  (43,'Vivamus','id ante dictum cursus. Nunc mauris elit,','2020-01-06 12:18:25',10),
  (44,'in','libero mauris, aliquam eu, accumsan sed, facilisis vitae, orci. Phasellus','2020-06-10 18:02:48',7),
  (45,'ut','et malesuada fames ac turpis egestas. Fusce aliquet','2020-11-27 06:32:28',1),
  (46,'augue','montes, nascetur ridiculus mus. Proin vel nisl. Quisque fringilla','2021-07-22 08:40:55',2),
  (47,'interdum.','metus. Aenean sed pede nec ante blandit viverra. Donec','2020-04-11 12:20:58',4),
  (48,'metus.','rutrum lorem ac risus. Morbi metus. Vivamus euismod','2020-07-07 17:48:07',4),
  (49,'ridiculus','arcu et pede. Nunc sed orci','2021-08-28 10:10:54',7),
  (50,'tempus','Integer urna. Vivamus molestie dapibus ligula. Aliquam','2020-01-21 03:31:49',10),
  (51,'consectetuer','sociis natoque penatibus et magnis dis parturient','2020-07-13 21:13:49',4),
  (52,'sit','elit, pharetra ut, pharetra sed, hendrerit a,','2020-05-28 22:48:53',9),
  (53,'erat.','non quam. Pellentesque habitant morbi tristique senectus et netus','2021-07-13 05:15:05',2),
  (54,'dictum','ad litora torquent per conubia nostra,','2021-07-25 09:58:28',6),
  (55,'Nunc','pede nec ante blandit viverra. Donec tempus, lorem','2021-06-29 08:58:41',1),
  (56,'semper','orci. Ut sagittis lobortis mauris.','2020-07-13 06:39:29',2),
  (57,'neque','purus ac tellus. Suspendisse sed','2021-07-24 15:51:17',2),
  (58,'Nulla','Pellentesque habitant morbi tristique senectus et','2020-01-02 11:51:25',8),
  (59,'felis,','Donec egestas. Duis ac arcu. Nunc mauris. Morbi','2021-05-18 05:25:00',4),
  (60,'pede.','fringilla, porttitor vulputate, posuere vulputate, lacus.','2021-01-05 13:08:47',3),
  (61,'viverra.','amet lorem semper auctor. Mauris vel turpis. Aliquam adipiscing','2020-02-28 03:30:47',5),
  (62,'Donec','mi, ac mattis velit justo nec','2021-02-21 15:03:41',10),
  (63,'tincidunt','lacinia at, iaculis quis, pede. Praesent','2021-07-18 13:40:52',0),
  (64,'a,','ipsum non arcu. Vivamus sit amet risus. Donec','2021-10-14 23:24:39',6),
  (65,'ultrices','Curabitur vel lectus. Cum sociis natoque penatibus et magnis','2021-09-18 00:49:04',1),
  (66,'Mauris','tellus lorem eu metus. In lorem. Donec elementum, lorem ut','2020-08-06 19:36:02',3),
  (67,'at','lectus convallis est, vitae sodales nisi magna sed dui. Fusce','2021-02-04 05:18:56',8),
  (68,'dui','gravida sagittis. Duis gravida. Praesent eu','2019-12-24 14:03:48',0),
  (69,'ad','volutpat. Nulla dignissim. Maecenas ornare egestas ligula. Nullam','2021-08-07 16:28:19',11),
  (70,'sapien,','sem, consequat nec, mollis vitae, posuere at, velit. Cras lorem','2021-04-29 03:43:28',1),
  (71,'sem','ac urna. Ut tincidunt vehicula risus. Nulla','2021-05-04 18:21:24',4),
  (72,'enim,','vitae dolor. Donec fringilla. Donec feugiat metus','2020-08-27 20:03:31',8),
  (73,'bibendum','ut quam vel sapien imperdiet ornare. In faucibus.','2020-04-20 16:20:11',9),
  (74,'Cum','vulputate ullamcorper magna. Sed eu eros. Nam consequat dolor vitae','2020-01-15 00:43:21',13),
  (75,'Nunc','Ut nec urna et arcu imperdiet ullamcorper. Duis at','2021-10-29 13:43:15',2),
  (76,'a,','ac nulla. In tincidunt congue turpis. In condimentum.','2021-07-20 09:41:24',13),
  (77,'Nunc','dui, semper et, lacinia vitae, sodales','2021-10-05 05:36:42',13),
  (78,'enim,','a, dui. Cras pellentesque. Sed','2020-11-04 03:07:03',7),
  (79,'sociis','semper cursus. Integer mollis. Integer tincidunt aliquam arcu.','2020-08-12 04:25:17',1),
  (80,'Sed','elementum sem, vitae aliquam eros turpis non','2020-02-27 09:57:57',11),
  (81,'augue','ac urna. Ut tincidunt vehicula risus. Nulla eget metus','2020-04-01 08:54:17',2),
  (82,'primis','et ultrices posuere cubilia Curae Donec','2020-10-28 22:39:50',1),
  (83,'felis.','commodo ipsum. Suspendisse non leo.','2021-06-25 12:41:05',5),
  (84,'egestas','mus. Proin vel arcu eu','2021-02-11 03:32:06',5),
  (85,'egestas','elit elit fermentum risus, at fringilla purus mauris','2020-09-27 10:55:29',0),
  (86,'egestas','Mauris blandit enim consequat purus. Maecenas libero','2020-05-20 18:27:19',6),
  (87,'In','mauris, rhoncus id, mollis nec, cursus a, enim. Suspendisse','2021-01-16 23:18:42',2),
  (88,'lectus','aliquam eu, accumsan sed, facilisis vitae, orci.','2020-01-18 15:55:15',4),
  (89,'pede.','aliquam iaculis, lacus pede sagittis','2021-04-24 20:27:14',10),
  (90,'a','felis. Donec tempor, est ac mattis','2019-12-24 00:30:34',8),
  (91,'orci.','ante dictum cursus. Nunc mauris elit, dictum eu,','2020-09-03 06:13:43',4),
  (92,'primis','non, egestas a, dui. Cras pellentesque. Sed','2021-08-05 21:50:42',5),
  (93,'non','Cras vehicula aliquet libero. Integer in magna. Phasellus dolor','2021-02-01 19:53:11',14),
  (94,'Nulla','id sapien. Cras dolor dolor, tempus non,','2021-08-26 15:38:08',5),
  (95,'sit','Suspendisse aliquet molestie tellus. Aenean egestas hendrerit','2020-02-16 08:19:41',6),
  (96,'elit','ac arcu. Nunc mauris. Morbi','2020-07-28 19:58:51',1),
  (97,'porttitor','non, cursus non, egestas a, dui. Cras pellentesque. Sed','2020-08-25 12:17:33',0),
  (98,'Vestibulum','dictum mi, ac mattis velit justo','2021-03-15 00:28:04',9),
  (99,'hendrerit','risus. Nulla eget metus eu erat semper','2020-04-18 01:56:01',12),
  (100,'tempor,','eu metus. In lorem. Donec elementum, lorem ut aliquam','2020-09-15 15:06:41',10),
  (101,'cursus','sit amet, faucibus ut, nulla. Cras eu tellus eu','2021-10-13 16:44:15',5),
  (102,'faucibus','tristique pharetra. Quisque ac libero nec ligula','2021-06-02 03:01:41',8),
  (103,'feugiat','sed leo. Cras vehicula aliquet libero.','2020-02-14 05:54:49',10),
  (104,'turpis.','et ultrices posuere cubilia Curae Donec','2020-02-17 15:51:39',5),
  (105,'volutpat','dui, nec tempus mauris erat eget ipsum.','2020-08-08 06:23:51',7),
  (106,'ullamcorper','a felis ullamcorper viverra. Maecenas iaculis aliquet','2021-08-15 06:08:43',6),
  (107,'magna','quis urna. Nunc quis arcu vel','2021-08-19 14:35:46',12),
  (108,'ac','non, hendrerit id, ante. Nunc mauris sapien,','2021-01-31 15:07:17',1),
  (109,'mi.','ullamcorper viverra. Maecenas iaculis aliquet diam. Sed diam lorem,','2020-05-16 15:18:06',10),
  (110,'mus.','nec, mollis vitae, posuere at, velit. Cras','2021-04-17 15:03:43',5),
  (111,'rhoncus','mauris, rhoncus id, mollis nec, cursus a,','2020-05-12 08:53:20',11),
  (112,'metus','neque vitae semper egestas, urna justo','2020-08-26 14:11:27',1),
  (113,'nibh.','egestas. Duis ac arcu. Nunc mauris. Morbi non','2021-01-16 15:02:21',7),
  (114,'convallis,','penatibus et magnis dis parturient montes, nascetur ridiculus mus.','2020-06-17 07:35:08',9),
  (115,'ridiculus','ut nisi a odio semper cursus.','2021-09-28 09:30:02',8),
  (116,'parturient','at, iaculis quis, pede. Praesent eu dui. Cum','2020-09-01 03:04:16',11),
  (117,'Integer','Maecenas mi felis, adipiscing fringilla, porttitor vulputate, posuere vulputate,','2020-08-23 01:16:27',2),
  (118,'Mauris','lacinia. Sed congue, elit sed consequat auctor, nunc nulla','2020-08-16 23:55:47',2),
  (119,'ultricies','Aenean sed pede nec ante blandit viverra. Donec tempus,','2020-09-12 18:57:45',3),
  (120,'vitae','nisl. Maecenas malesuada fringilla est.','2020-09-17 23:57:47',14),
  (121,'Nunc','nec, leo. Morbi neque tellus, imperdiet non, vestibulum nec, euismod','2020-11-05 05:55:50',4),
  (122,'placerat','eu nibh vulputate mauris sagittis placerat. Cras dictum ultricies ligula.','2021-07-10 20:08:05',2),
  (123,'Cras','congue, elit sed consequat auctor, nunc nulla','2021-01-19 09:08:19',11),
  (124,'risus.','ridiculus mus. Aenean eget magna. Suspendisse tristique neque venenatis','2020-11-21 10:03:52',3),
  (125,'metus.','tortor. Nunc commodo auctor velit. Aliquam','2021-09-27 23:24:59',4),
  (126,'diam','mollis dui, in sodales elit erat vitae risus.','2020-05-17 08:27:23',6),
  (127,'sapien','nisl sem, consequat nec, mollis vitae, posuere','2021-01-28 07:54:53',2),
  (128,'Morbi','penatibus et magnis dis parturient montes,','2021-06-18 16:20:46',8),
  (129,'condimentum.','egestas. Fusce aliquet magna a neque. Nullam','2021-03-13 09:54:31',1),
  (130,'ut,','molestie tellus. Aenean egestas hendrerit neque. In ornare','2019-11-30 13:29:10',4),
  (131,'dis','nonummy. Fusce fermentum fermentum arcu. Vestibulum','2020-12-27 05:48:33',7),
  (132,'elit,','odio sagittis semper. Nam tempor','2021-05-28 08:38:49',6),
  (133,'erat','sagittis. Duis gravida. Praesent eu nulla at sem molestie sodales.','2020-03-15 05:27:57',3),
  (134,'aliquam','metus. Aenean sed pede nec ante blandit viverra. Donec','2019-11-25 22:45:51',12),
  (135,'Aenean','gravida mauris ut mi. Duis','2020-06-21 12:42:47',11),
  (136,'ante.','Nam consequat dolor vitae dolor.','2021-02-19 05:01:41',12),
  (137,'Nunc','tortor at risus. Nunc ac sem ut dolor','2021-02-05 17:19:03',3),
  (138,'lacus.','ipsum. Phasellus vitae mauris sit amet lorem semper auctor.','2020-03-12 23:01:16',14),
  (139,'eu','at pretium aliquet, metus urna convallis','2020-09-12 02:29:39',8),
  (140,'enim.','Aenean euismod mauris eu elit.','2020-07-17 00:44:43',11),
  (141,'cursus','ornare, libero at auctor ullamcorper, nisl arcu iaculis enim,','2020-01-08 06:05:26',12),
  (142,'Cras','In condimentum. Donec at arcu. Vestibulum ante','2021-06-07 06:44:05',4),
  (143,'urna.','Fusce dolor quam, elementum at, egestas','2021-07-04 03:30:15',12),
  (144,'faucibus.','ipsum. Phasellus vitae mauris sit amet','2020-06-08 06:17:37',1),
  (145,'lobortis,','ultrices iaculis odio. Nam interdum enim non nisi.','2020-04-04 05:15:10',2),
  (146,'dapibus','sociis natoque penatibus et magnis dis parturient montes,','2020-12-07 03:37:20',11),
  (147,'vulputate','non leo. Vivamus nibh dolor, nonummy','2020-11-26 05:00:06',14),
  (148,'urna.','fringilla euismod enim. Etiam gravida molestie arcu. Sed','2020-01-21 00:44:37',14),
  (149,'sociosqu','Cras sed leo. Cras vehicula aliquet libero. Integer','2020-05-02 16:00:08',9);
*/

-- ========================= poll =========================
/*
INSERT INTO poll(post_id) VALUES
  (0),
  (1),
  (10),
  (128),
  (54);*/

-- ========================= option =========================
/*
INSERT INTO option(id,poll_id,description) VALUES
  (0,0,'Mauris non dui nec urna suscipit'),
  (1,0,'dolor vitae dolor. Donec fringilla. Donec feugiat'),
  (2,0,'non quam. Pellentesque habitant morbi tristique senectus et netus'),
  (3,0,'ac mattis velit justo nec'),
  (4,1,'condimentum. Donec at arcu. Vestibulum ante'),
  (5,1,'aliquet, metus urna convallis erat, eget tincidunt'),
  (6,1,'lacinia. Sed congue, elit sed consequat auctor, nunc'),
  (7,1,'enim diam vel arcu. Curabitur ut odio'),
  (8,10,'In at pede. Cras vulputate velit eu'),
  (9,10,'ante. Vivamus non lorem vitae odio sagittis semper.'),
  (10,10,'mus. Proin vel arcu eu'),
  (11,10,'dictum eu, eleifend nec, malesuada ut, sem.'),
  (12,128,'porttitor scelerisque neque. Nullam nisl. Maecenas malesuada fringilla est.'),
  (13,128,'nec tempus mauris erat eget'),
  (14,128,'lobortis quis, pede. Suspendisse dui. Fusce diam nunc,'),
  (15,128,'lectus ante dictum mi, ac mattis velit justo'),
  (16,54,'magnis dis parturient montes, nascetur ridiculus mus. Aenean'),
  (17,54,'ultrices sit amet, risus. Donec nibh enim, gravida'),
  (18,54,'eget, venenatis a, magna. Lorem ipsum'),
  (19,54,'eu dolor egestas rhoncus. Proin nisl');
*/
-- ========================= comment =========================

INSERT INTO comment(id,author_id,event_id,content,creation_date) VALUES
  (0,52,94,'luctus ut, pellentesque eget, dictum placerat, augue. Sed molestie. Sed','2020-02-13 23:19:32'),
  (1,41,127,'non magna. Nam ligula elit,','2020-02-04 00:16:08'),
  (2,74,23,'feugiat metus sit amet ante. Vivamus non lorem vitae','2021-03-14 04:25:47'),
  (3,37,36,'semper erat, in consectetuer ipsum nunc id','2021-09-23 04:55:00'),
  (4,23,30,'Quisque libero lacus, varius et,','2020-06-10 03:03:04'),
  (5,39,42,'in lobortis tellus justo sit amet nulla. Donec','2021-10-15 20:16:27'),
  (6,50,63,'dui. Cras pellentesque. Sed dictum. Proin eget odio. Aliquam vulputate','2020-08-03 06:22:27'),
  (7,28,54,'sociis natoque penatibus et magnis dis parturient','2020-09-21 09:52:21'),
  (8,46,6,'ac risus. Morbi metus. Vivamus euismod','2021-02-02 05:09:45'),
  (9,1,122,'scelerisque mollis. Phasellus libero mauris, aliquam eu, accumsan','2020-01-02 17:50:40'),
  (10,5,9,'ac arcu. Nunc mauris. Morbi non sapien','2020-06-15 09:03:42'),
  (11,71,13,'urna, nec luctus felis purus ac tellus. Suspendisse','2021-10-02 08:04:34'),
  (12,33,85,'nisi. Mauris nulla. Integer urna. Vivamus molestie','2021-09-21 16:16:12'),
  (13,19,11,'eu elit. Nulla facilisi. Sed neque. Sed','2021-08-16 19:46:30'),
  (14,114,4,'tincidunt, nunc ac mattis ornare, lectus ante dictum mi,','2019-11-23 19:41:32'),
  (15,77,1,'diam. Sed diam lorem, auctor quis, tristique ac, eleifend vitae,','2020-03-20 04:41:36'),
  (16,82,29,'non, lobortis quis, pede. Suspendisse lbaw','2021-01-30 23:38:32'),
  (17,40,10,'in aliquet lobortis, nisi nibh','2021-04-26 00:42:59'),
  (18,40,10,'felis orci, adipiscing non, luctus sit amet, faucibus ut,','2021-10-08 06:27:12'),
  (19,114,4,'augue ut lacus. Nulla tincidunt, neque vitae semper egestas,','2020-08-22 05:53:16'),
  (20,69,13,'mauris sagittis placerat. Cras dictum ultricies','2019-11-24 11:25:02'),
  (21,1,122,'sem ut cursus luctus, ipsum leo elementum sem, vitae aliquam','2020-11-22 09:05:34'),
  (22,46,130,'Suspendisse sagittis. Nullam vitae diam. Proin dolor. Nulla semper tellus','2021-08-20 01:09:59'),
  (23,90,41,'pede. Cras vulputate velit eu sem. Pellentesque ut','2020-08-06 09:20:43'),
  (24,41,129,'mauris a nunc. In at pede. Cras vulputate velit','2021-09-28 02:12:30'),
  (25,88,97,'auctor odio a purus. Duis elementum,','2021-09-07 16:21:15'),
  (26,5,125,'gravida nunc sed pede. Cum sociis natoque penatibus et magnis','2020-02-15 09:13:49'),
  (27,65,76,'erat vitae risus. Duis a mi fringilla mi','2020-04-11 22:09:24'),
  (28,121,51,'metus. Vivamus euismod urna. Nullam lobortis quam','2020-10-08 04:23:15'),
  (29,7,55,'natoque penatibus et magnis dis parturient','2019-12-20 09:19:23');

select setval('comment_id_seq', (select max(id) from comment));

-- ========================= rating =========================

INSERT INTO rating(id,comment_id,user_id,vote) VALUES
  (1,10,49,'Upvote'),
  (2,1,41,'Downvote'),
  (3,1,82,'Upvote'),
  (4,1,76,'Upvote'),
  (5,26,5, 'Upvote'),
  (6,26,148, 'Downvote'),
  (7,26,55, 'Downvote');

select setval('rating_id_seq', (select max(id) from rating));

-- ========================= file =========================

INSERT INTO file(comment_id, path, original_name) VALUES
  (28,'./images/idk.png', 'idk.png'),
  (4,'./images/oof.png', 'oof.png'),
  (19,'./images/idkv2.png', 'idkv2.png'),
  (26,'./images/main.jpeg', 'main.jpeg'),
  (21,'./images/test.png', 'test.png'),
  (29,'./images/not_main.jpeg', 'not_main.jpeg'),
  (10,'./images/oooof.png', 'oooof.png'),
  (8,'./test/idk.gif', 'idk.gif'),
  (25,'./test/test.png', 'test.png'),
  (9,'./debug.jpeg', 'debug.jpeg');

-- ========================= report =========================

INSERT INTO report(user_id,report_date,motive,dismissal_date) VALUES
  (70,'2021-09-18 23:22:49','quam dignissim pharetra. Nam ac nulla. In tincidunt','2021-10-28 16:19:00'),
  (23,'2020-03-31 17:19:59','blandit congue. In scelerisque scelerisque','2021-10-26 12:45:16'),
  (19,'2020-03-01 21:48:49','Nunc commodo auctor velit. Aliquam nisl. Nulla eu',NULL),
  (20,'2021-09-13 18:47:10','Donec consectetuer mauris id sapien. Cras dolor dolor, tempus non,','2021-10-30 03:45:15'),
  (55,'2020-11-22 14:38:54','eu nibh vulputate mauris sagittis placerat. Cras dictum ultricies','2021-10-21 08:35:15'),
  (126,'2020-07-15 21:31:10','et, commodo at, libero. Morbi accumsan laoreet ipsum.',NULL);

-- ========================= user_report =========================

INSERT INTO user_report(report_id,target) VALUES
  (1,120),
  (2,144);

-- ========================= comment_report =========================

INSERT INTO comment_report(report_id,target) VALUES
  (3,7),
  (4,14);

-- ========================= event_report =========================

INSERT INTO event_report(report_id,target) VALUES
  (5,86),
  (6,76);

-- ========================= transaction =========================

INSERT INTO transaction(id,user_id,amount,date) VALUES
  (0,141,'4.14','2021-01-27 03:58:12'),
  (1,72,'13.16','2020-12-19 22:34:16'),
  (2,105,'13.80','2021-11-01 15:35:48'),
  (3,21,'5.57','2019-11-20 11:52:14'),
  (4,16,'8.16','2021-04-26 20:27:21'),
  (5,97,'14.19','2021-02-05 17:01:32'),
  (6,26,'3.74','2021-07-13 10:07:29'),
  (7,67,'2.44','2020-08-27 05:47:32'),
  (8,23,'1.78','2021-01-26 23:12:20'),
  (9,45,'12.82','2021-01-10 21:44:55'),
  (10,47,'19.89','2021-02-19 18:01:44'),
  (11,103,'12.08','2021-02-20 21:31:36'),
  (12,57,'10.51','2020-02-24 23:56:02'),
  (13,110,'16.05','2020-11-25 16:29:25'),
  (14,94,'9.94','2021-10-20 10:29:03'),
  (15,88,'2.55','2020-01-07 15:22:13'),
  (16,51,'14.52','2019-11-06 04:37:54'),
  (17,129,'6.65','2020-06-27 12:37:04'),
  (18,15,'17.84','2021-05-03 13:56:21'),
  (19,120,'14.93','2021-09-19 19:29:33');

-- ========================= event_cancelled_notification =========================

INSERT INTO event_cancelled_notification(title,notification_date) VALUES
  ('idk event was canceled','2021-01-03 03:58:12'),
  ('mdis event was canceled','2021-01-03 03:58:12'),
  ('test event was canceled','2021-01-03 03:58:12'),
  ('mnum event was canceled','2020-06-22 14:20:42'),
  ('lcom event was canceled','2020-08-29 23:50:36');

-- ========================= event_cancelled_notification_user =========================

INSERT INTO event_cancelled_notification_user(notification_id,user_id) VALUES
  (4, 116), 
  (1, 74), 
  (2, 94), 
  (1, 37), 
  (1, 100), 
  (3, 147), 
  (2, 66), 
  (2, 5), 
  (2, 133), 
  (1, 23), 
  (4, 106), 
  (2, 145), 
  (4, 48), 
  (2, 29), 
  (2, 20), 
  (1, 91), 
  (2, 90), 
  (4, 8), 
  (2, 47), 
  (2, 53), 
  (1, 48),
  (2, 120),
  (3, 68),
  (3, 71),
  (1, 11),
  (1, 8),
  (3, 39),
  (4, 111),
  (1, 87),
  (4, 126),
  (3, 124),
  (4, 71),
  (4, 10),
  (1, 102),
  (2, 49),
  (3, 72),
  (4, 77),
  (1, 56),
  (4, 28),
  (4, 147),
  (1, 146), 
  (3, 35), 
  (2, 12), 
  (3, 24), 
  (2, 134), 
  (2, 146), 
  (2, 27), 
  (3, 50);
  
-- ========================= vote =========================
/*
INSERT INTO vote(user_id,option_id) VALUES
  (112, 0),
  (143, 7),
  (107, 9),
  (2,0),
  (3,2);
*/

-- ========================= event_tag =========================

INSERT INTO event_tag(tag_id, event_id) VALUES
  (9,17),
  (9,133),
  (4,29),
  (6,32),
  (11,40),
  (3,59),
  (8,22),
  (11,128),
  (11,100),
  (1,12),
  (9,114),
  (0,34),
  (6,25),
  (6,110),
  (7,120),
  (9,75),
  (11,111),
  (9,138),
  (5,14),
  (4,129),
  (3,21),
  (8,42),
  (7,122),
  (12,102),
  (2,41),
  (10,29),
  (6,132),
  (3,64),
  (6,51),
  (10,40),
  (12,85),
  (2,35),
  (9,84),
  (0,50),
  (10,16),
  (1,85),
  (4,125),
  (2,135),
  (1,9),
  (11,34),
  (2,36),
  (3,144),
  (3,140),
  (5,50),
  (13,77),
  (11,1),
  (3,91),
  (5,87),
  (3,126),
  (8,90),
  (9,27),
  (6,64),
  (1,72),
  (8,88),
  (2,137),
  (0,56),
  (2,73),
  (2,126),
  (7,0),
  (1,125),
  (11,68),
  (1,138),
  (5,26),
  (12,31),
  (2,81),
  (7,55),
  (8,30),
  (9,103),
  (1,141),
  (11,138),
  (8,53),
  (0,117),
  (1,18),
  (8,26),
  (7,116),
  (3,145),
  (11,134),
  (4,72),
  (11,52),
  (2,77),
  (13,57),
  (7,56),
  (8,146),
  (13,127),
  (10,107),
  (10,37),
  (2,56),
  (13,111),
  (9,115),
  (8,48),
  (0,78),
  (12,14),
  (11,125),
  (12,17),
  (7,24),
  (1,95),
  (7,54),
  (10,80),
  (4,104),
  (10,44),
  (3,70),
  (11,13),
  (13,47),
  (10,71),
  (6,79),
  (0,86),
  (4,14),
  (2,22),
  (10,137),
  (0,12),
  (5,9),
  (4,94),
  (5,115),
  (13,46),
  (9,6),
  (3,2),
  (12,77),
  (11,149),
  (2,58),
  (1,62),
  (11,127),
  (5,20),
  (9,81),
  (10,68),
  (7,119),
  (11,3),
  (1,109),
  (3,54),
  (5,43),
  (6,2),
  (1,34),
  (4,55),
  (3,120),
  (9,48),
  (6,21), 
  (2,17),
  (10,95),
  (12,2),
  (0,63),
  (11,97),
  (4,49),
  (9,117),
  (4,106),
  (6,122),
  (9,7);

---- Functions ----
DROP FUNCTION IF EXISTS delete_user;
CREATE FUNCTION delete_user(_deleted_user_id integer) RETURNS void AS
$$
DECLARE 
    tableId INTEGER;
    T RECORD;
BEGIN
    -- Remove unblock_appeals
    DELETE FROM unblock_appeal WHERE user_id=_deleted_user_id;

    -- Remove pending event_cancelled_notifications
    DELETE FROM event_cancelled_notification_user WHERE user_id=_deleted_user_id;

    -- Remove pending requests
    DELETE FROM request WHERE user_id=_deleted_user_id;

    -- Remove pending invites (where the user is the invitee)
    DELETE FROM invite WHERE invitee_id=_deleted_user_id;

    -- Update user to anonymous in invites where the user is the inviter
    UPDATE invite SET inviter_id=0 WHERE inviter_id=_deleted_user_id;

    -- Update user to anonymous in transactions so that the data is kept in the database
    UPDATE transaction SET user_id=0 WHERE user_id=_deleted_user_id;

    -- Update user to anonymous in votes
    UPDATE vote SET user_id=0 WHERE user_id=_deleted_user_id;

    -- Update user to anonymous in comments
    UPDATE comment SET author_id=0 WHERE author_id=_deleted_user_id;

    -- Update user to anonymous in ratings
    UPDATE rating SET user_id=0 WHERE user_id=_deleted_user_id;

    -- Removing all the reports authored by the user, as well as the reports where the user is the target 
    DELETE FROM user_report WHERE report_id IN (SELECT id FROM report WHERE user_id=_deleted_user_id) OR target=_deleted_user_id;
    DELETE FROM comment_report WHERE report_id IN (SELECT id FROM report WHERE user_id=_deleted_user_id);
    DELETE FROM event_report WHERE report_id IN (SELECT id FROM report WHERE user_id=_deleted_user_id);
    DELETE FROM report WHERE user_id=_deleted_user_id;
    DELETE FROM report WHERE id NOT IN (SELECT report_id FROM user_report UNION SELECT report_id FROM comment_report UNION SELECT report_id FROM event_report);

    FOR T IN (SELECT id, title FROM event WHERE host_id=_deleted_user_id) LOOP
        INSERT INTO event_cancelled_notification(title) VALUES (T.title) RETURNING id INTO tableId;

        INSERT INTO event_cancelled_notification_user(notification_id, user_id)
            SELECT tableId, user_id FROM attendee WHERE event_id=T.id;
        
        DELETE FROM attendee WHERE event_id=T.id;
        
        DELETE FROM event WHERE id=T.id;
    END LOOP;
    

    -- Removing all the attendee status of the user
    DELETE FROM attendee WHERE user_id=_deleted_user_id;

    -- Remove the user
    DELETE FROM users WHERE id=_deleted_user_id;
END;
$$
LANGUAGE plpgsql;