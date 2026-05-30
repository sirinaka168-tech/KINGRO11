-- RO-King 5.0 — GM (admin) account
-- Run via make-gm.bat AFTER the server is started at least once.
-- group_id 99 = full GM. Change the password after first login!

INSERT INTO `login` (`userid`, `user_pass`, `sex`, `email`, `group_id`)
VALUES ('kingadmin', 'ChangeMe_123', 'M', 'admin@kingro.local', 99)
ON DUPLICATE KEY UPDATE `group_id` = 99;
