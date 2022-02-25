BEGIN TRANSACTION;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

INSERT INTO attendee (id_user, id_event) VALUES ($id_user, $id_event)

IF EXISTS (SELECT * FROM event WHERE (id=$id_event) AND price <> 0)
THEN
    INSERT INTO transaction (id_user, amount) VALUES ($id_user, (SELECT price FROM event WHERE (id=$id_event)))
END IF;

END TRANSACTION;