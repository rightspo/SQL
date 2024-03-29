DROP FUNCTION fnc_persons_female();
DROP FUNCTION fnc_persons_male();

CREATE FUNCTION fnc_persons(IN pgender varchar DEFAULT 'female')
	RETURNS SETOF person
	LANGUAGE SQL
	AS
$$
	SELECT *
	FROM person
	WHERE gender = pgender
$$;

SELECT * FROM fnc_persons(pgender := 'male');
SELECT * FROM fnc_persons();