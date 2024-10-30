use football_analysis_eda;
/* 1. Performance Analysis Objective: Analyze individual player and team performance over various matches and seasons. */
-- How does a player's performance vary across different seasons? (DONE IN EXCEL -- USING ROWS AI)

/* SELECT p.name, g.season, SUM(a.goals) AS total_goals, SUM(a.assists) AS total_assists-- , SUM(a.minutes_played) AS total_minutes FROM players p INNER JOIN appearances a ON p.player_id = a.player_id JOIN games g ON a.game_id = g.game_id GROUP BY p.name, g.season ORDER BY p.name, g.season; */

-- On an Average what is the goals and assists for each player? (DONE IN EXCEL -- USING ROWS AI)
/* SELECT p.name AS player_name, AVG(a.goals) AS avg_goals, AVG(a.assists) AS avg_assists FROM players p JOIN appearances a ON p.player_id = a.player_id WHERE a.goals IS NOT NULL AND a.assists IS NOT NULL GROUP BY p.name ORDER BY avg_goals desc ,  avg_assists desc; */

-- Which players contribute the most in terms of goals, assists, and minutes played?
CREATE VIEW PERFORMANCE_PLAYER_CONTRIBUTION AS -- IN PYTHON TO CONNECT AND  VISUALIZE 
SELECT 
	p.player_id,
    p.name, 
    SUM(a.goals) AS total_goals, 
    SUM(a.assists) AS total_assists, 
    SUM(a.minutes_played) AS total_minutes
FROM 
    players p
JOIN 
    appearances a ON p.player_id = a.player_id
GROUP BY 
    p.player_id, p.name
HAVING 
	SUM(a.goals) <> 0  AND SUM(a.assists) <> 0
ORDER BY 
    total_goals + total_assists DESC, total_minutes ASC;

-- What are the patterns of red and yellow cards for different players?
CREATE VIEW PERFORMANCE_CARDS_PLAYER AS
SELECT 
	p.player_id,
    p.name,  
    SUM(a.yellow_cards) AS total_yellow_cards, 
    SUM(a.red_cards) AS total_red_cards
FROM 
    players p
LEFT JOIN appearances a ON p.player_id = a.player_id -- WANT ALL PLAYERS INFO
RIGHT JOIN games g ON a.game_id = g.game_id -- WANT ALL GAMES INFO
GROUP BY 
    p.player_id, p.name
-- HAVING 
-- total_yellow_cards <> 0  AND total_red_cards <> 0
ORDER BY 
    total_yellow_cards DESC, total_red_cards DESC;





/* 2. Player Profile and Market Value Objective: Understand the player profiles, including their market value trends and attributes. */

-- (wrong) How has each player's market value changed over time?
-- What are the key factors influencing a player’s market value (e.g., goals, assists, age)? (TO BE DONE IN PYTHON ONLY VISUALIZATION NEEDED)
-- (IRRELEVANT) How does a player’s current market value compare to their highest market value? (IRRELEVANT)
/* SELECT p.name, p.market_value_in_eur AS current_market_value, p.highest_market_value_in_eur AS highest_market_value, round((p.market_value_in_eur - p.highest_market_value_in_eur) /p.highest_market_value_in_eur*100, 2) AS value_difference_in_perce FROM players p ORDER BY value_difference_in_perce desc;*/

-- Which positions or sub-positions tend to have higher market values?
CREATE VIEW PLAYER_POSITION_MKT_VALUE AS 
SELECT 
    p.position, p.sub_position,
    truncate(AVG(p.market_value_in_eur), 2) AS avg_market_value
FROM 
    players p
GROUP BY 
    p.position, p.sub_position
ORDER BY 
    avg_market_value DESC;

/*SELECT p.sub_position, truncate(AVG(p.market_value_in_eur), 2) AS avg_market_value FROM players p GROUP BY p.sub_position ORDER BY avg_market_value DESC;*/

-- Is there any correlation between a player's height, market value? (TO BE DONE IN PYTHON ONLY VISUALIZATION NEEDED)
CREATE VIEW PLAYER_HEIGHT_MKT_VAL AS
SELECT 
    p.height_in_cm,
    p.market_value_in_eur
FROM 
    players p;
    
/* 3. Team Comparison Objective: Compare teams based on their performance, and managerial choices. */

-- How do teams compare based on goals scored and conceded in home and away games?
CREATE VIEW  TEAM_HOME_PERFORMANCE AS 
SELECT home_club_name,
       AVG(home_club_goals) AS avg_home_goals_scored,
       AVG(away_club_goals) AS avg_away_goals_conceded,
       CASE WHEN AVG(home_club_goals) > AVG(away_club_goals) THEN "HOME"
            WHEN AVG(away_club_goals) > AVG(home_club_goals)  THEN "AWAY"
            ELSE "TIE"
            END AS better_perform
FROM games
GROUP BY home_club_name
HAVING better_perform = 'HOME' 			-- [HOME, AWAY, TIE]
ORDER BY avg_home_goals_scored DESC, avg_away_goals_conceded ASC;
-- LIMIT 3;

CREATE VIEW TEAM_AWAY_PERFORMANCE AS 
SELECT away_club_name, 
       AVG(home_club_goals) AS avg_home_goals_scored,
       AVG(away_club_goals) AS avg_away_goals_conceded,
       CASE WHEN AVG(home_club_goals) > AVG(away_club_goals) THEN "HOME"
            WHEN AVG(away_club_goals) > AVG(home_club_goals)  THEN "AWAY"
            ELSE "TIE"
            END AS better_perform
FROM games
GROUP BY away_club_name
HAVING better_perform = 'AWAY' 			-- [HOME, AWAY, TIE]
ORDER BY avg_away_goals_conceded DESC, avg_home_goals_scored  ASC;
-- LIMIT 3;

-- BEST PERFORMING AT HOME CLUBS -- FK Zarya Lugansk, Futbol Club Barcelona, Athlitiki Enosi Konstantinoupoleos
-- BEST AWAY PERFORMANCE -- fc vitoria setubal, RAEC Mons (- 2015), Boavista Futebol Clube

-- What are the differences in team performance based on manager names or strategies?
CREATE VIEW TEAM_MANAGER_PERFORMANCE AS 
SELECT home_club_manager_name,--  home_club_name, 
       SUM(CASE WHEN home_club_goals > away_club_goals THEN 1 
				ELSE 0 END) AS wins,
       SUM(CASE WHEN home_club_goals < away_club_goals THEN 1 
                ELSE 0 END) AS losses
	   -- home_club_name OVER (PARTITION BY home_club_manager_name) AS homeclubname
FROM games
GROUP BY home_club_manager_name-- , home_club_name
HAVING wins > losses
ORDER BY wins desc, losses asc
;

-- Which teams have the best win/loss ratio in various competitions?
CREATE VIEW TEAM_WIN_RATIO AS
SELECT 
	competition_type,
	home_club_name, 
	SUM(CASE WHEN home_club_goals > away_club_goals THEN 1 ELSE 0 END) AS wins,
	SUM(CASE WHEN away_club_goals > home_club_goals THEN 1 ELSE 0 END) AS loses, 
	SUM(CASE WHEN home_club_goals > away_club_goals THEN 1 ELSE 0 END) / 
	SUM(CASE WHEN away_club_goals > home_club_goals THEN 1 ELSE 0 END) AS win_loss_ratio
FROM games
-- WHERE competition_type = 'domestic_league' -- [domestic_league,  international_cup,  domestic_cup,  other ]top_n_teams_win_loss_ratio
GROUP BY competition_type, home_club_name
HAVING win_loss_ratio IS NOT NULL
ORDER BY win_loss_ratio DESC;

-- Competition_Type --> [domestic_league,  international_cup,  domestic_cup,  other ]


-- How does the position of the home and away clubs affect match outcomes?
CREATE VIEW TEAM_POSITION_OUTCOME AS
SELECT 
	home_club_position,
	SUM(CASE WHEN home_club_goals > away_club_goals THEN 1 ELSE 0 END) AS home_wins,
	SUM(CASE WHEN home_club_goals < away_club_goals THEN 1 ELSE 0 END) AS away_wins,
    SUM(CASE WHEN home_club_goals > away_club_goals THEN 1 ELSE 0 END)/
    SUM(CASE WHEN home_club_goals < away_club_goals THEN 1 ELSE 0 END) AS home_away_win_ratio,
    SUM(CASE WHEN home_club_goals > away_club_goals THEN 1 ELSE 0 END) + 
    SUM(CASE WHEN home_club_goals < away_club_goals THEN 1 ELSE 0 END) AS TOTAL_WINS
FROM games
GROUP BY 
	home_club_position
ORDER BY
	home_away_win_ratio DESC,
    TOTAL_WINS DESC,
	home_club_position
;


-- How do teams’ performances vary across different seasons? 
-- CREATE VIEW TEAM_SEASON_PERFORMANCE AS 
SELECT 
	season,
    -- competition_type,
    home_club_name,
	SUM(CASE WHEN home_club_goals > away_club_goals THEN 1 ELSE 0 END) AS wins,
	SUM(CASE WHEN home_club_goals < away_club_goals THEN 1 ELSE 0 END) AS losses,
	SUM(home_club_goals) AS total_goals
FROM games
-- WHERE season = 2013 	
-- where competition_type = 'domestic_league'
GROUP BY season, home_club_name -- , competition_type
HAVING wins > losses
ORDER BY season;

-- DROP VIEW TEAM_SEASON_PERFORMANCE;
CREATE VIEW TEAM_SEASON_PERFORMANCE AS 
SELECT 
	season,
    competition_type,
    home_club_name,
	SUM(CASE WHEN home_club_goals > away_club_goals THEN 1 ELSE 0 END) AS wins,
	SUM(CASE WHEN home_club_goals < away_club_goals THEN 1 ELSE 0 END) AS losses,
	SUM(home_club_goals) AS total_goals
FROM games
-- WHERE season = 2013 	
-- where competition_type = 'domestic_league'
GROUP BY season, competition_type, home_club_name
-- HAVING wins > losses
ORDER BY season, competition_type, wins DESC;

    
/* 4. Attendance and Stadium Analysis -Objective: Analyze the attendance patterns and stadium influences on match outcomes. */

-- What is the average attendance for matches at different stadiums?
CREATE VIEW ATTENDANCE_STADIUM AS
SELECT
	g.stadium,
    ROUND(avg(attendance), 2) as AVG_ATTENDANCE
FROM games g  
GROUP BY g.stadium
ORDER BY ROUND(avg(attendance), 2) DESC;

   
-- Is there a correlation between attendance and team performance (goals, wins)?
/* Stadium Impact: 1. How do different stadiums influence our team's performance and fan turnout?
		2. Does higher attendance correlate with better home performance for our team? */
CREATE VIEW ATTENDANCE_GOALS_CORR AS 
SELECT
    g.home_club_goals,
    -- SUM(CASE WHEN g.home_club_goals> g.away_club_goals THEN 1 ELSE 0 END) AS WINS,
    g.attendance
FROM games g;

CREATE VIEW ATTENDANCE_WINS_CORR AS 
SELECT
    CASE WHEN g.home_club_goals> g.away_club_goals THEN 1 ELSE 0 END AS OUTCOME,
    g.attendance
FROM games g;

-- How does stadium size or location influence attendance and match outcomes? 
CREATE VIEW STADIUM_ATTEND_OUTCOME_INFLUENCE AS
SELECT 
    g1.game_id,
    g1.stadium,
    g1.OUTCOME,
    g2.attendance
FROM 
    (SELECT g.game_id, g.stadium, CASE WHEN g.home_club_goals > g.away_club_goals THEN 1 ELSE 0 END AS OUTCOME
    FROM games g) as g1
JOIN 
    (SELECT 
        g.game_id,
        g.stadium,
        g.attendance
    FROM games g) as g2
ON g1.game_id = g2.game_id;


-- CREATE VIEW STADIUM_OUTCOME_INFLUENCE AS
SELECT 
	g.game_id,
	g.stadium,
    CASE WHEN g.home_club_goals > g.away_club_goals THEN 1 ELSE 0 END AS OUTCOME
FROM games g;

-- CREATE VIEW STADIUM_ATTENDANCE_INFLUENCE AS
SELECT g.game_id,
	g.stadium,
    g.attendance
FROM games g;

-- What are the highest and lowest attended matches across seasons or competitions?
CREATE VIEW ATTENDANCE_MAX_MIN_ACROSS_SEASONS_COMPETITIONS AS
SELECT 
	g.competition_id,
	g.season,
	g.stadium,
    g.attendance
FROM games g;


-- Which clubs tend to have the highest home attendance?
CREATE VIEW ATTENDANCE_HOME_CLUBWISE AS
SELECT
	g.home_club_name,
    g.attendance
FROM games g;


-- Attendance Patterns: 1. What factors (team performance, weather, day of the week) most influence match attendance?
/* Does day of the week, match number affect the match attendance */
CREATE VIEW ATTENDANCE_DAY_MATCH_ROUND_CORR AS
SELECT 
	g.attendance, 
    dayname(g.date) as day_of_week,
    g.round
 --    CASE WHEN LOCATE('.', g.round) > 0 THEN SUBSTRING(g.round, 1, LOCATE('.', g.round) - 1) 
--     ELSE g.round 
--     END AS MATCH_NUMBER
FROM games g;

/*
(REMOVED) Attendance Patterns: 2. How does the quality of the opponent affect attendance numbers? (REMOVED)
(REMOVED) Ticketing and Revenue: 1. What pricing strategies can optimize stadium attendance and maximize ticket revenue? (REMOVED)
(REMOVED) Ticketing and Revenue: 2. Which stadium features (seating capacity, amenities) most contribute to higher fan engagement? (REMOVED)
*/

-- Fan Engagement: Which matches rivals matches bring in the most fans, and how can we capitalize on this through promotions?
CREATE VIEW ATTENDANCE_FAN_ENGAGEMENT_RIVALS as 
SELECT 
    g.home_club_name, g.away_club_name, g.attendance
FROM games g;

-- Substitution Patterns 
-- i.	How often do teams make substitutions, and at what minute during matches?
-- ii.	Are certain players regularly substituted, and how does it affect their performance?
-- iii.	Which players come off the bench and contribute to goals/assists?


WITH CTE AS 
(
SELECT 
	DISTINCT ge.game_id, COUNT(ge.game_id) as Count_Game_ID, ge.player_id, ge.player_in_id, a.player_name
FROM game_events ge
RIGHT JOIN appearances a ON a.game_id = ge.game_id
WHERE type = 'Goals' or type = 'Substitutions'
group by ge.game_id,  ge.player_id, ge.player_in_id, a.player_name
HAVING COUNT(ge.game_id) > 1
)
SELECT player_name, sum(Count_Game_ID)
FROM CTE
GROUP BY player_name;