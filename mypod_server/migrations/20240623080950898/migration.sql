BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "note" (
    "id" bigserial PRIMARY KEY,
    "text" text NOT NULL
);


--
-- MIGRATION VERSION FOR mypod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('mypod', '20240623080950898', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240623080950898', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
