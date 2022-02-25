BEGIN TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIAlIZABLE;

DO $$
DECLARE tableId integer;
BEGIN
  INSERT INTO event_cancelled_notification(title)
    SELECT title FROM event WHERE id=$id RETURNING id INTO tableId;

  INSERT INTO event_cancelled_notification_user(id_notification, id_user)
    SELECT tableId, id_user FROM attendee WHERE id_event=$id;

  DELETE FROM attendee WHERE id_event=$id;

  DELETE FROM event WHERE id=$id;
END $$;

END TRANSACTION;