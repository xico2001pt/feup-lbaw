BEGIN TRANSACTION;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

INSERT INTO report (id_author, motive)
    VALUES ($id_author, $motive);

INSERT INTO comment_report (id_report, target)
    VALUES (currval('report_id_seq'), $target);

END TRANSACTION;