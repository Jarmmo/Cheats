GM.Name 	= "Cheats!"
GM.Author 	= "Jarmmo"
GM.TeamBased = true

team.SetUp(0,"Waiting",Color(100,100,100),false)
team.SetUp(1,"Red",Color(200,100,100),false)
team.SetUp(2,"Blue",Color(100,100,200),false)
team.SetUp(3,"Deathmatch",Color(100,200,100),false)

team.SetSpawnPoint( 1, { "info_player_terrorist" } )
team.SetSpawnPoint( 2, { "info_player_counterterrorist" } )
team.SetSpawnPoint( 3, { "info_player_counterterrorist" ,  "info_player_terrorist" } )