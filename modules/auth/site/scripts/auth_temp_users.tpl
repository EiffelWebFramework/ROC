
DROP TABLE IF EXISTS "auth_temp_users";
CREATE TABLE `auth_temp_users` (
  `uid` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `salt` VARCHAR(100) NOT NULL,
  `email` VARCHAR(250) NOT NULL,
  `application` TEXT NOT NULL, 
  CONSTRAINT `name`
    UNIQUE(`name`)
);

