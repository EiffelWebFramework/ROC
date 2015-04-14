BEGIN;

CREATE TABLE "nodes"(
  "nid" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL CHECK("nid">=0),
  "revision" INTEGER,
  "type" TEXT NOT NULL,
  "title" VARCHAR(255) NOT NULL,
  "summary" TEXT NOT NULL,
  "content" MEDIUMTEXT NOT NULL,
  "author" INTEGER,
  "publish" DATETIME,
  "created" DATETIME NOT NULL,
  "changed" DATETIME NOT NULL
);

CREATE TABLE page_nodes(
  "nid" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL CHECK("nid">=0),
  "revision" INTEGER,
  "parent" INTEGER
);

COMMIT;
