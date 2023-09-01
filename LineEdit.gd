extends LineEdit

onready var grid = get_node("../")

var name_num = ""

func set_name_num():
	for i in (name.length()):
		if i > 7:
			name_num += name[i]

func _ready():
	set_name_num()


func _on_LineEdit_text_changed(new_text):
	print(name_num)
	grid.edit_table(int(name_num), new_text)
