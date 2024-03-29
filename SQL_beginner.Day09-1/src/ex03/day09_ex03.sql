DROP TRIGGER trg_person_insert_audit ON person;
DROP TRIGGER trg_person_update_audit ON person;
DROP TRIGGER trg_person_delete_audit ON person;

DROP FUNCTION fnc_trg_person_insert_audit();
DROP FUNCTION fnc_trg_person_update_audit();
DROP FUNCTION fnc_trg_person_delete_audit();

TRUNCATE TABLE person_audit;

CREATE FUNCTION fnc_trg_person_audit()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
$$
BEGIN
	CASE
	WHEN TG_OP = 'INSERT' THEN INSERT INTO person_audit
							   VALUES(CURRENT_TIMESTAMP, 'I', NEW.id, NEW.name, NEW.age, NEW.gender, NEW.address);
							   RETURN NEW;
	WHEN TG_OP = 'UPDATE' THEN INSERT INTO person_audit
							   VALUES(CURRENT_TIMESTAMP, 'U', NEW.id, NEW.name, NEW.age, NEW.gender, NEW.address);
							   RETURN NEW;
	WHEN TG_OP = 'DELETE' THEN INSERT INTO person_audit
							   VALUES(CURRENT_TIMESTAMP, 'D', OLD.id, OLD.name, OLd.age, OLD.gender, OLD.address);
							   RETURN OLD;
	END CASE;
END;
$$;

CREATE TRIGGER trg_person_audit
	AFTER INSERT OR UPDATE OR DELETE ON person FOR EACH ROW
	EXECUTE PROCEDURE fnc_trg_person_audit();

INSERT INTO person(id, name, age, gender, address) VALUES (10,'Damir', 22, 'male', 'Irkutsk');
UPDATE person SET name = 'Bulat' WHERE id = 10;
UPDATE person SET name = 'Damir' WHERE id = 10;
DELETE FROM person WHERE id = 10;

SELECT * FROM person_audit;