extends Node


const SAVE_PATH = "res://savegame.bin" #if we are releasing the game, use users:// instead of res://. This is used to save game
	
func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE) # opnes the save path file locaiton and write the save in it 
	var data: Dictionary = {  # declaration of dictionary
		"playerHp": Game.playerHP, 
		"player_gold": Game.player_gold
	}
	var jstr = JSON.stringify(data) #convert the data dictionary in to a json via stringify()
	file.store_line(jstr)
	
	
func load_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ) # opnes the save path file locaiton and read the save in it 
	if FileAccess.file_exists(SAVE_PATH) == true: # checks if there is a file named savegame.bin
		if not file.eof_reached(): #checks if the file readig is not at the end
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				Game.playerHP = current_line["playerHp"]
				Game.player_gold = current_line["player_gold"]
	
	file.close
