CREATE OR REPLACE FUNCTION fill_random_data_for_team()
    RETURNS VOID AS
$$
DECLARE
    team_name TEXT;
    location_id BIGINT;
    league_id BIGINT;
    stadium_id BIGINT;
BEGIN
    FOR i IN 1..1000 LOOP
            team_name := (select Name from TeamNames order by  random() limit 1);
            location_id := (SELECT id FROM Location ORDER BY random() LIMIT 1);
            league_id := (SELECT id FROM League ORDER BY random() LIMIT 1);
            stadium_id := (SELECT id FROM Stadium ORDER BY random() LIMIT 1);

            INSERT INTO Team (Name, location_id, league_id, StadiumId)
            VALUES (team_name, location_id, league_id, stadium_id);
        END LOOP;
END;
$$
    LANGUAGE plpgsql;


--------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION fill_random_data_for_judge()
    RETURNS VOID AS
$$
DECLARE
    person_id BIGINT;
BEGIN
    FOR i IN 1..1000
        LOOP
            person_id := (Select id from person order by random() limit 10);
            INSERT INTO Judge (person_id)
            values (person_id);
        END LOOP;
END;
$$
    LANGUAGE plpgsql;

select fill_random_data_for_judge()

-------------------------------------------------------------
CREATE OR REPLACE FUNCTION fill_random_data_for_judge()
    RETURNS VOID AS
$$
DECLARE
    person_id BIGINT;
BEGIN
    FOR i IN 1..1000
        LOOP
            person_id := (Select id from person order by random() limit 10);
            INSERT INTO coach(person_id, title)
            values (person_id,'judge');
        end loop;
END;
$$
    LANGUAGE plpgsql;

---




CREATE OR REPLACE FUNCTION fill_random_data_for_team()
    RETURNS VOID AS
$$
DECLARE
    team_name TEXT;
    location_id BIGINT;
    league_id BIGINT;
    stadium_id BIGINT;
BEGIN
    FOR i IN 1..1000 LOOP
            team_name := (select Name from TeamNames order by  random() limit 1);
            location_id := (SELECT id FROM Location ORDER BY random() LIMIT 1);
            league_id := (SELECT id FROM League ORDER BY random() LIMIT 1);
            stadium_id := (SELECT id FROM Stadium ORDER BY random() LIMIT 1);

            INSERT INTO Team (Name, location_id, league_id, StadiumId)
            VALUES (team_name, location_id, league_id, stadium_id);
        END LOOP;
END;
$$
    LANGUAGE plpgsql;

select fill_random_data_for_team();
select * from team;
truncate table team;


CREATE OR REPLACE FUNCTION fill_random_data_for_judge()
    RETURNS VOID AS
$$
DECLARE
    person_id BIGINT;
BEGIN
    FOR i IN 1..1000
        LOOP
            person_id := (Select id from person order by random() limit 1);
            INSERT INTO Judge (person_id)
            values (person_id);
        END LOOP;
END;
$$
    LANGUAGE plpgsql;

select fill_random_data_for_judge();
select * from judge;

select * from person;

CREATE OR REPLACE FUNCTION fill_person_data(num_rows integer)
    RETURNS void AS $$
DECLARE
    first_name_chars text[] := ARRAY['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
    last_name_chars text[] := ARRAY['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
BEGIN
    FOR i IN 1..num_rows LOOP
            INSERT INTO Person (first_name, last_name, date_of_birth, email, location_id, gender_id)
            VALUES (
                       (SELECT array_to_string(ARRAY(SELECT first_name_chars[1 + (random() * 26)] FROM generate_series(1, 5)), '')),
                       (SELECT array_to_string(ARRAY(SELECT last_name_chars[1 + (random() * 26)] FROM generate_series(1, 5)), '')),
                       (SELECT to_date(to_char((date_trunc('year', now()) + (random() * (now()::date - date_trunc('year', now())))), 'YYYY-MM-DD'), 'YYYY-MM-DD')),
                       (SELECT array_to_string(ARRAY(SELECT substring(md5(random()::text) from 1 for 5) FROM generate_series(1, 2)), '') || '@example.com'),
                       (SELECT id FROM Location ORDER BY random() LIMIT 1),
                       (SELECT id FROM Gender ORDER BY random() LIMIT 1)
                   );
        END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT fill_person_data(1000);
select * from person;





CREATE OR REPLACE FUNCTION fill_coach_data(num_rows integer)
    RETURNS void AS $$
BEGIN
    FOR i IN 1..num_rows LOOP
            INSERT INTO Coach (person_id, Title)
            VALUES (
                       (SELECT id FROM Person ORDER BY random() LIMIT 1),
                       CASE floor(random() * 2)
                           WHEN 0 THEN 'HEAD COACH'
                           WHEN 1 THEN 'ASSISTANT COACH'
                           END
                   );
        END LOOP;
END;
$$ LANGUAGE plpgsql;

select fill_coach_data(1000)
select * from coach;








CREATE OR REPLACE FUNCTION fill_coach_team_data(num_rows integer)
    RETURNS void AS $$
BEGIN
    FOR i IN 1..num_rows LOOP
            INSERT INTO Coach_Team (CoachId, TeamId, "From", "To")
            VALUES (
                       (SELECT id FROM Coach ORDER BY random() LIMIT 1),
                       (SELECT id FROM Team ORDER BY random() LIMIT 1),
                       (SELECT to_date(to_char((date_trunc('year', now() - interval '10 years') + (random() * (now()::date - date_trunc('year', now() - interval '10 years')))), 'YYYY-MM-DD'), 'YYYY-MM-DD')),
                       (SELECT to_date(to_char((date_trunc('year', now()) + (random() * (now()::date - date_trunc('year', now())))), 'YYYY-MM-DD'), 'YYYY-MM-DD'))
                   );
        END LOOP;
END;
$$ LANGUAGE plpgsql;


select fill_coach_team_data(100);
select * from coach_team;






CREATE OR REPLACE FUNCTION fill_matches_data(num_rows integer)
    RETURNS void AS $$
DECLARE
    HomeTeam BIGINT;
    AWAYTEAM BIGINT;
BEGIN
    FOR i IN 1..num_rows LOOP
            INSERT INTO Matches (Result, JudgeId, StadiumId, SeasonId, HomeTeam, AwayTeam, "Date")
            SELECT
                CASE floor(random() * 3)
                    WHEN 0 THEN 'Home Team Wins'
                    WHEN 1 THEN 'Away Team Wins'
                    WHEN 2 THEN 'Draw'
                    END,
                (SELECT id FROM Judge ORDER BY random() LIMIT 1),
                (SELECT id FROM Stadium ORDER BY random() LIMIT 1),
                (SELECT id FROM Season ORDER BY random() LIMIT 1),
                (SELECT id FROM Team ORDER BY random() LIMIT 1),
                (SELECT id FROM Team ORDER BY random() LIMIT 1),
                (SELECT to_date(to_char((date_trunc('year', now() - interval '10 years') + (random() * (now()::date - date_trunc('year', now() - interval '10 years')))), 'YYYY-MM-DD'), 'YYYY-MM-DD'))
            FROM generate_series(1, 1);
        END LOOP;
END;
$$ LANGUAGE plpgsql;


select fill_matches_data(100);
select * from matches;




CREATE OR REPLACE FUNCTION fill_player_data(num_rows integer)
    RETURNS void AS $$
BEGIN
    FOR i IN 1..num_rows LOOP
            INSERT INTO Player (person_id, TeamId, PositionId, LocationId)
            VALUES (
                       (SELECT id FROM Person ORDER BY random() LIMIT 1),
                       (SELECT id FROM Team ORDER BY random() LIMIT 1),
                       CASE floor(random() * 4)
                           WHEN 0 THEN 'GK'
                           WHEN 1 THEN 'D'
                           WHEN 2 THEN 'M'
                           WHEN 3 THEN 'S'
                           END,
                       (SELECT id FROM Location ORDER BY random() LIMIT 1)
                   );
        END LOOP;
END;
$$ LANGUAGE plpgsql;

select fill_player_data(100);
select * from player;






CREATE OR REPLACE FUNCTION fill_player_team_data(num_rows integer)
    RETURNS void AS $$
BEGIN
    FOR i IN 1..num_rows LOOP
            INSERT INTO Player_Team (PlayerId, TeamId, "From", "To")
            VALUES (
                       (SELECT id FROM Player ORDER BY random() LIMIT 1),
                       (SELECT id FROM Team ORDER BY random() LIMIT 1),
                       (SELECT date_trunc('day', now()) - CAST(floor(random() * 365 * 10) || ' days' as interval)),
                       (SELECT nullif(date_trunc('day', now()) + CAST(floor(random() * 365 * 3) || ' days' as interval), date_trunc('day', now())))
                   );
        END LOOP;
END;
$$ LANGUAGE plpgsql;

select fill_player_team_data(100)
select * from player_team;






CREATE OR REPLACE FUNCTION fill_debit_card_data(num_rows integer)
    RETURNS void AS $$
BEGIN
    FOR i IN 1..num_rows LOOP
            INSERT INTO DebitCard (Issue, DateOfExpire, "Column")
            VALUES (
                       floor(random() * 10000000000000000)::bigint,
                       (now() + (interval '1 year' * (floor(random() * 5) + 1)))::date,
                       floor(random() * 10000000000000000)::bigint
                   );
        END LOOP;
END;
$$ LANGUAGE plpgsql;


select fill_debit_card_data(100);
select * from debitcard



CREATE OR REPLACE FUNCTION fill_betting_card_data(num_rows integer)
    RETURNS void AS $$
BEGIN
    FOR i IN 1..num_rows LOOP
            INSERT INTO BettingCard (TotalMoney, DebitCardId)
            VALUES (
                       (SELECT floor(random()*10000)::bigint),
                       (SELECT id FROM DebitCard ORDER BY random() LIMIT 1)
                   );
        END LOOP;
END;
$$ LANGUAGE plpgsql;

select fill_betting_card_data(100)
select * from bettingcard;

insert into role values (1,'user');









CREATE OR REPLACE FUNCTION fill_user_data(num_users INTEGER)
    RETURNS VOID AS $$
DECLARE
    p_id    INTEGER;
    l_id    INTEGER;
    r_id    INTEGER;
    b_id    INTEGER;
    u_name  TEXT;
    p_word  TEXT;
BEGIN
    FOR i IN 1..num_users LOOP
            SELECT id FROM Person ORDER BY RANDOM() LIMIT 1 INTO p_id;
            SELECT id FROM Location ORDER BY RANDOM() LIMIT 1 INTO l_id;
            SELECT id FROM Role ORDER BY RANDOM() LIMIT 1 INTO r_id;
            SELECT id FROM BettingCard ORDER BY RANDOM() LIMIT 1 INTO b_id;
            u_name := (SELECT string_agg(chr((97 + round(random() * 25))::integer), '') FROM generate_series(1, 10));
            p_word := MD5(random()::TEXT);
            INSERT INTO "User" (username, password, person_id, LocationId, RoleId, "Betting CardId")
            VALUES (u_name, p_word, p_id, l_id, r_id, b_id);
        END LOOP;
END;
$$ LANGUAGE plpgsql;
select fill_user_data(100);
select * from "User";


select * from season;



















CREATE OR REPLACE FUNCTION fill_betting_coefficients_data(num_rows integer)
    RETURNS void AS $$
BEGIN
    FOR i IN 1..num_rows LOOP
            INSERT INTO BettingCoefficients (Coefficient, State, MatchesId, BettingCombinationsId)
            VALUES (
                       TRUNC(RANDOM() * 10 + 1, 2)::text,
                       (CASE TRUNC(RANDOM() * 2 + 1, 0) WHEN 1 THEN 'Active' ELSE 'Inactive' END),
                       (SELECT id FROM Matches ORDER BY RANDOM() LIMIT 1),
                       (SELECT id FROM BettingCombinations ORDER BY RANDOM() LIMIT 1)
                   );
        END LOOP;
END;
$$ LANGUAGE plpgsql;


select fill_betting_coefficients_data(100);
select * from bettingcoefficients




CREATE OR REPLACE FUNCTION fill_data_season()
    RETURNS VOID AS
$$
DECLARE
    l_id bigint;
    i    int;
BEGIN
    FOR l_id IN (select id from league)
        LOOP
            for i in 1980..2022
                loop
                    insert into season("Year started", leagueid)
                    values (i::text, l_id);
                end loop;
        end loop;
end;
$$ LANGUAGE plpgsql;

select fill_data_season();
select * from season;


CREATE OR REPLACE FUNCTION fill_data_team_season()
    RETURNS VOID AS
$$
DECLARE
    team   RECORD;
    season record;
    i      int;
BEGIN
    FOR team IN (select * from team)
        LOOP
            for season in (select * from season where LeagueId = team.league_id)
                loop
                    insert into team_season(teamid, seasonid)
                    values (team.id, season.id);
                end loop;
        end loop;
end;
$$ LANGUAGE plpgsql;

select fill_data_team_season();
select * from team_season;


select * from team;
select * from season;
select * from league;


insert into bettingcombinations(name)
values ('1'),
       ('x'),
       ('2'),
       ('1-1'),
       ('2-2'),
       ('x-x'),
       ('x-1'),
       ('x-x'),
       ('1-x'),
       ('1-2'),
       ('2-1'),
       ('2-2'),
       ('2-x');



CREATE OR REPLACE FUNCTION fill_betting_coefficients_data(num_rows integer)
    RETURNS void AS $$
BEGIN
    FOR i IN 1..num_rows LOOP
            INSERT INTO BettingCoefficients (Coefficient, State, MatchesId, BettingCombinationsId)
            VALUES (
                       round(RANDOM() * 10 + 1, 2)::text,
                       'NOT YET PLAYED',
                       (SELECT id FROM Matches ORDER BY RANDOM() LIMIT 1),
                       (SELECT id FROM BettingCombinations ORDER BY RANDOM() LIMIT 1)
                   );
        END LOOP;
END;
$$ LANGUAGE plpgsql;


select fill_betting_coefficients_data(100);
select * from bettingcoefficients;
