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

-- Removing the events hosted by the user, comments, ratings, posts, polls, options and votes will be removed as well (ON DELETE CASCADE) and notifying attendees
    --DO $$   
    --DECLARE tableId INTEGER;
    --DECLARE T RECORD;
    --BEGIN
    --    FOR T IN (SELECT id, title FROM event WHERE host_id=_deleted_user_id) LOOP
    --        INSERT INTO event_cancelled_notification(title) VALUES (T.title) RETURNING id INTO tableId;
--
    --        INSERT INTO event_cancelled_notification_user(notification_id, user_id)
    --            SELECT tableId, user_id FROM attendee WHERE event_id=T.id;
--
    --        DELETE FROM attendee WHERE event_id=T.id;
--
    --        DELETE FROM event WHERE id=T.id;
    --    END LOOP;
    --END $$;