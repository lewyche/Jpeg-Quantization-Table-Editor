extends TextEdit

export(int) var LIMIT = 2
var current_text = ''
var cursor_line = 0
var cursor_column = 0



func check_text():
	var new_text : String = text
	if new_text.length() > LIMIT:
		text = current_text
		
		#Return to start
		#TODO: Change to start at next 
		cursor_set_line(cursor_line)
		cursor_set_column(cursor_column)
	
	

func _on_TextEdit1_text_changed():
	pass # Replace with function body.
