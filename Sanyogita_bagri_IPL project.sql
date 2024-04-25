-- create database 
create database ipl_db;
-- to look how many databases are there
show databases;
-- to use database whose name is ipl
use ipl_db;
-- we have created one table whose name is teams
create table teams(Tname varchar(30));
-- inserting some date in teams table
insert into teams(Tname )values("Pune Warriors"),("Kolkata Kinght Riders"),("Rajasthan Royals"),("Kochi Tuskers Kerala"),("Gujarat Lions"),
("Chennai Super kings"),("Rising Pune Supergiants"),("Delhi Dare Devils"),("Deccan Chargers"),("Delhi Capital"),("Mumbai Indians"),
("Sunrisers Hyderabad"),("Rising Pune Supergiant"),("Royal Challenger Bangalore"),("Kings XI Punjab");
-- describe the structure of teams table
desc teams;
-- show the whole data of teams table  
select * from teams;
-- to show how many tables are there in ipl database
show tables;
-- we have already imported some table into ipl database from data wizard that tables are
-- deliveries,matches,most_run_average_strikerate,teamwise_home_and_away
-- now we will look structure of all the tables
desc deliveries;
-- to display whole deliveries table
select * from deliveries;
desc matches;
desc most_runs_average_strikerate;
select * from most_runs_average_strikerate;
desc teams;
desc teamwise_home_and_away; 

-- find the top 5 bats man how score higest runs
Select* from most_runs_average_strikerate order by total_runs desc limit 0,5;

-- place where maximum no. of match played
Select city,max(city) from matches group by city limit 0,1;

-- What are the top 5 player with the most player of match awards
 show tables;
 use ipl_db;
 select player_of_match,count(*) from matches group by player_of_match order by count(*) desc limit 0,5;
 
 -- how many matches were won by each team in each season
 select Season from matches;
 select Season,winner,count(*) as no_of_match_played from matches group by season, winner ;
 desc deliveries;

 -- what is the avgrage stike rate of batsman in ipl dataset
 select batsman,count(*)as total_balls,sum(batsman_runs) as total_run,sum(batsman_runs*100)/count(*)as avg_strike_rate from deliveries group by batsman;
 
 -- what is the number of matches won by each team batting first vs batting second
 
select * from matches;
select batting_first,count(*)as matches_won from
( select case when win_by_runs>0 then team1 else team2 end as batting_first from matches where result<>"tie")as batting_1st_teams
group by batting_first;

-- which batsman has higest strike rate score more then 200 runs
select batsman,(sum(batsman_runs*100)/count(*)) as strike_rate from deliveries group by batsman 
having sum(batsman_runs)>=200 order by strike_rate desc limit 0,1;

-- how many times has each batsman been dissmissed by the bowler Malinga
select *  from deliveries;
select batsman,count(*) as total_dismissal from deliveries where  bowler="SL Malinga"  and player_dismissed is not null group by batsman ;

-- what is the avg percentage of boundries (four and six combined ) hit by each batsman 
select batsman ,avg(case when batsman_runs= 6 or batsman_runs=4 then 1 else 0 end)*100 as avg_boundries from deliveries group by batsman;

--  what is the avg number  of boundries hit by each team in each season
select  season,batting_team,avg(fours+sixes) as average from
 (select season,match_id,batting_team,
 sum(case when batsman_runs=4 then 1 else 0 end)as fours,
sum( case when batsman_runs=6 then 1 else 0 end) as sixes 
from deliveries, matches 
where deliveries.match_id=matches.id 
group by season,match_id,batting_team
)as team_boundries
group by season,batting_team;
 
 -- what is the higest patnership runs by each team in each season
ALTER TABLE deliveries
CHANGE COLUMN `over` over_no INT(10);

 SELECT season, batting_team, MAX(total_runs) AS highest_partnership
FROM (
    SELECT season, batting_team, partnership, SUM(total_runs) AS total_runs
    FROM (
        SELECT season, match_id, batting_team, over_no ,
               SUM(batsman_runs) AS partnership, 
               SUM(batsman_runs) + SUM(extra_runs) AS total_runs
        FROM deliveries, matches
        WHERE deliveries.match_id = matches.id
        GROUP BY season, match_id, batting_team, over_no
    ) AS team_scores
    GROUP BY season, batting_team, partnership
) AS highest_partnership_summary
GROUP BY season, batting_team;
 
 -- how many extra (wide & noballs )where bowled by each team in each matches
select match_id,bowling_team,sum(extra_runs)as extra_runs from deliveries group by match_id, bowling_team;

-- which bowler has the best bowling figuers(most wicket taken)in a single match
select m.id,d.bowler,count(*) as wicket from matches as m 
join deliveries as d on m.id=d.match_id
 where d.player_dismissed is not null 
 group by m.id,d.bowler 
 order by wicket desc
 limit 1;
 
 -- how many matches resulted in a win for each team in each city
 select city,winner,count(*) no_of_win from matches group by city,winner;

-- How many time did each team win the toss in each season
select season,toss_winner,count(*)as no_Of_time_toss_winner from matches group by season,toss_winner;

-- how many matches did each player win the "player of the match" award
select player_of_match ,count(*) as no_of_matches from matches group by player_of_match;

-- which team has higest total score in a single match
select* from deliveries;
select d.match_id,m.id,d.batting_team,sum(total_runs) as total_runs from deliveries as d join matches as m on d.match_id=m.id 
group by m.id,d.batting_team order by total_runs desc limit 1;

-- which batsman has scored the most runs in a single matches
select d.batsman, m.id,d.match_id,sum(total_runs) from deliveries as d  join matches as m  on d.match_id=m.id group by m.id,d.batsman 
order by sum(total_runs) desc limit 1;
 