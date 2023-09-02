extends GridContainer

onready var interface = get_node("../../../")
onready var texture = interface.get_node("HBoxContainer/TextureRect")

var quantization_tables = []
var iterator = 0

func display_table(table):
	for i in range(table.size()):
		get_node("LineEdit" + str(i + 1)).text = str(table[i])

func edit_table(element, txt):
	quantization_tables[iterator][element - 1] = txt

func set_tables(quant):
	quantization_tables = quant
	print(quantization_tables.size())
	display_table(quantization_tables[iterator])

func _ready():
	pass # Replace with function body.


func _on_back_pressed():
	if iterator > 0:
		iterator -= 1
		display_table(quantization_tables[iterator])


func _on_next_pressed():
	if iterator < quantization_tables.size() - 1:
		iterator += 1
		display_table(quantization_tables[iterator])


func _on_save_pressed():
	interface.write_file(quantization_tables)

