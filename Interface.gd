extends Control

var jpg_file = "res://sogay.jpg"		#TODO: change this later

onready var grid = get_node("HBoxContainer/VBoxContainer/grid")

func _ready():
	open_file()

func process_bytes(byte_array):
	var hex = byte_array.hex_encode()
	
	var restart_interval = false
	var curr_hex = ""
	#while not iterated to restart interval, which starts at the end of the quantization table
	
	var quantization_tables = []
	
	var i = 0
	var check_for_tables = false
	while restart_interval == false && i + 1 < hex.length():
		curr_hex = hex[i] + hex[i + 1]
		
		if curr_hex == "ff":
			i += 2	#go to next hex
			curr_hex = hex[i] + hex[i + 1]
			if curr_hex == "db":
				
				i += 6	#skip length markers plus quantization marker
				
				var new_quant = []
				
				var quant_hex = hex[i] + hex[i + 1]
				
				var destination = quant_hex
				
				i += 2 #skip destination marker
				
				var end = i + 128
				
				while i < end && i + 1 < hex.length():
					quant_hex = hex[i] + hex[i + 1]
					print(quant_hex)
					new_quant.append(quant_hex)
					i += 2
				quantization_tables.append(new_quant)
		i += 2
	grid.set_tables(quantization_tables)
#		curr_hex = hex[i] + hex[i + 1]
#
#		if check_for_tables == true:
#
#			check_for_tables = false
#
#			var table_hex = ""
#
#
#			if curr_hex == "C4" || curr_hex == "c4":	#Huffman Table
#				var new_huff = [i + 1]	#add index of huffman table to first element
#				var j = i + 1
#
#				print("huff!")
#
#				while table_hex != "FF" && j + 1 < hex.length():
#
#					table_hex = hex[j] + hex[j + 1]
#					print(table_hex)
#					new_huff.append(table_hex)
#					j += 2
#					i = j
#
#				huffman_tables.append(new_huff)
#			elif curr_hex == "DB" || curr_hex == "db":	#Quantization Table
#				var new_quant = [i + 1]	 #add index of huffman table to first element
#				var j = i + 1
#
#				print(i + 1)
#
#				print("quant!")
#
#				while table_hex != "FF" && j + 1 < hex.length():
#
#					table_hex = hex[j] + hex[j + 1]
#					print(table_hex)
#					new_quant.append(table_hex)
#
#					quantization_tables.append(new_quant)
#					j += 2
#					i = j
#
#			elif curr_hex == "DD" || curr_hex == "dd":
#				restart_interval = true
#
#		if curr_hex == "FF" || curr_hex == "ff":
#			check_for_tables = true

		

func open_file():
	var f = File.new()
	
	f.open(jpg_file, File.READ_WRITE)
	
	var content = f.get_buffer(f.get_len())
	
	process_bytes(content)
	
	f.close()
	
