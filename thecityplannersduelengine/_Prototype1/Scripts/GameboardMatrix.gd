#class_name GameboardMatrix
#
#var contents: Array[Array] #Array of Array of GameboardCells
#
#static func create_empty(rows: int, cols: int) -> GameboardMatrix:
	#var new_gameboard_matrix: GameboardMatrix = GameboardMatrix.new()
	#new_gameboard_matrix.contents = _create_empty_matrix(rows, cols)
	#return new_gameboard_matrix
	#
#static func _create_empty_matrix(rows: int, cols: int) -> Array[Array]:
	#var empty_matrix: Array[Array] = []
	#for r in rows: 
		#var new_row: Array = []
		#for c in cols: 
			#new_row.append(GameboardCell.create_empty(r, c))
		#empty_matrix.append(new_row)
	#return empty_matrix
	#
#func print_contents():
	#for r in contents.size():
		#print(contents[r])
#
		#
#
### need to store road textuer, walkway teture, building textures, junction signal, road barriers, lane designations
### each thing could have a speed, directions, junctions signal
#
### to store all the gameboard information
