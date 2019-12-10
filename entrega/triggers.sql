-- RI-1 TRIGGER
CREATE OR REPLACE FUNCTION overlap_areas_proc()
RETURNS TRIGGER AS $$
DECLARE
    anomaly_area varchar(45);
BEGIN
    SELECT anomaly.area
        INTO anomaly_area
        FROM anomaly
        WHERE NEW.id = anomaly.id;

    IF NEW.area2 = anomaly_area THEN
        RAISE EXCEPTION 'Overlaping areas with anomaly table';
    END IF;

    RETURN NEW;
END
$$ LANGUAGE plpgsql;

DROP TRIGGER overlap_areas_in ON translation_anomaly;
DROP TRIGGER overlap_areas_up ON translation_anomaly;

CREATE TRIGGER overlap_areas_in
    BEFORE INSERT
    ON translation_anomaly
    FOR EACH ROW EXECUTE PROCEDURE overlap_areas_proc();

CREATE TRIGGER overlap_areas_up
    BEFORE UPDATE
    ON translation_anomaly
    FOR EACH ROW EXECUTE PROCEDURE overlap_areas_proc();

-- RI-5 TRIGGER
CREATE OR REPLACE FUNCTION in_regular_user_proc()
RETURNS TRIGGER AS $$
DECLARE
    already_in boolean;
BEGIN
    SELECT EXISTS (
        SELECT user_email 
            FROM regular_user
            WHERE user_email = NEW.user_email)
        INTO already_in;

    IF already_in THEN
        RAISE EXCEPTION 'user_email already in regular_user';
    END IF;

    RETURN NEW;
END
$$ LANGUAGE plpgsql;

DROP TRIGGER in_regular_user_table ON qualified_user;

CREATE TRIGGER in_regular_user_table
    BEFORE INSERT
    ON qualified_user
    FOR EACH ROW EXECUTE PROCEDURE in_regular_user_proc();

-- RI-6 TRIGGER
CREATE OR REPLACE FUNCTION in_qualified_user_proc()
RETURNS TRIGGER AS $$
DECLARE
    already_in boolean;
BEGIN
    SELECT EXISTS (
        SELECT user_email 
            FROM qualified_user
            WHERE user_email = NEW.user_email)
        INTO already_in;

    IF already_in THEN
        RAISE EXCEPTION 'user_email already in qualified_user';
    END IF;

    RETURN NEW;
END
$$ LANGUAGE plpgsql;

DROP TRIGGER in_regular_user_table ON regular_user;

CREATE TRIGGER in_qualified_user_table
    BEFORE INSERT
    ON regular_user
    FOR EACH ROW EXECUTE PROCEDURE in_qualified_user_proc();
