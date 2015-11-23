CREATE TABLE taxonomy_term (
  `tid`	INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT UNIQUE,
  `text` VARCHAR(255) NOT NULL,
  `weight` INTEGER,
  `description` TEXT,  
  `langcode` VARCHAR(12)
);

CREATE TABLE taxonomy_hierarchy (
  `tid`	INTEGER NOT NULL,
  `parent` INTEGER,
  CONSTRAINT PK_tid_parent PRIMARY KEY (tid,parent)
);
