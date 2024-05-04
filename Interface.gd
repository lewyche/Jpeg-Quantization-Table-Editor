extends Control

var jpg_file = "res://trailcam.jpg"

var hex = ""

var quant_positions = []

onready var grid = get_node("HBoxContainer/VBoxContainer/grid")
onready var texture = get_node("HBoxContainer/TextureRect")


func _ready():
	open_file()

func process_bytes(byte_array):
	hex = byte_array.hex_encode()
	
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
				
				var end = i + 126
				
				while i <= end && i + 1 < hex.length():
					quant_hex = hex[i] + hex[i + 1]
					
					if i == end - 126:	#if start of table
						quant_positions.append(i)
						
					new_quant.append(quant_hex)
					i += 2
				i = end	#prevent overshoot of iterator
				quantization_tables.append(new_quant)
		i += 2
	grid.set_tables(quantization_tables)

func write_to_hex(table, index):	#convert and merge hex array into hex string
	
	var i = quant_positions[index]	#position in hex string
	var j = 0	#position in hex array
	var end = i + 126
	while i < end && j < table.size():
		print(table[j].length())
		hex[i] = table[j][0]
		hex[i + 1] = table[j][1]
		i += 2
		j += 1

func convert_to_hex():
	
	var curr_hex = ""
	var i = 0
	var arr = [PoolByteArray()]
	
	while i + 1 < hex.length():
		curr_hex = "0x" + hex[i] + hex[i + 1]
		arr.append(curr_hex.hex_to_int())
		i += 2
	return arr

func write_file(quantization_tables):
	for i in range(quantization_tables.size()):
		write_to_hex(quantization_tables[i], i)
	
	var f = File.new()
	f.open(jpg_file, File.WRITE)
	
	var pool_byte = convert_to_hex()
	f.store_buffer(pool_byte)
	
	f.close()
	
	texture.import_image(jpg_file)

func open_file():
	var f = File.new()
	
	f.open(jpg_file, File.READ)
	
	var content = f.get_buffer(f.get_len())
	
	process_bytes(content)
	
	f.close()
	
