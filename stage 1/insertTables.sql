
INSERT INTO Stadiums (name, city, capacity) VALUES
('Wembley Stadium', 'London', 90000),
('Camp Nou', 'Barcelona', 99354),
('Maracanã', 'Rio de Janeiro', 78838);

INSERT INTO TournamentStages (name, matches_count, start_date, finish_date) VALUES
('Group Stage', 48, '2025-06-14', '2025-06-29'),
('Round of 16', 8, '2025-06-30', '2025-07-03'),
('Quarter Finals', 4, '2025-07-04', '2025-07-06');

INSERT INTO Teams (team_name, coach, team_group, fifa_ranking) VALUES
('Team 1', 'Coach 1', 'A', 45),
('Team 2', 'Coach 2', 'B', 60),
('Team 3', 'Coach 3', 'C', 75);

INSERT INTO Players (team_id, name, position, birth_date, goals, assists) VALUES
(1, 'Player 1', 'Forward', '1990-01-01', 15, 5),
(2, 'Player 2', 'Midfielder', '1992-05-15', 10, 8),
(3, 'Player 3', 'Defender', '1988-11-20', 5, 2);

INSERT INTO Matches (team1_id, team2_id, match_date, stadium_id, score_team1, score_team2, stage_id) VALUES
(1, 2, '2025-06-14', 1, 2, 1, 1),
(2, 3, '2025-06-15', 2, 1, 1, 1),
(1, 3, '2025-06-16', 3, 3, 2, 1);

INSERT INTO MatchEvents (match_id, player_id, event_type, minute) VALUES
(1, 1, 'Goal', 23),
(2, 2, 'Yellow Card', 45),
(3, 3, 'Red Card', 60);

INSERT INTO PlayersInMatches (is_substitute, player_id, match_id) VALUES
(FALSE, 1, 1),
(TRUE, 2, 1),
(FALSE, 3, 2);
