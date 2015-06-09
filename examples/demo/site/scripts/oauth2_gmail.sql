BEGIN;


CREATE TABLE "oauth2_gmail"(
   "uid" INTEGER PRIMARY KEY NOT NULL CHECK("uid">=0),
   "access_token" VARCHAR(255)  NOT NULL,
   "created" DATETIME NOT NULL,
   "details" TEXT NOT NULL,
   CONSTRAINT "uid"
    UNIQUE("uid")
   );


COMMIT;