extends GridContainer

var quantization_tables = []

func display_table(table):
	for i in range(table.size()):
		get_node("LineEdit" + str(i + 1)).text = str(table[i])

func set_tables(quant):
	quantization_tables = quant
	display_table(quantization_tables[0])

func _ready():
	pass # Replace with function body.
