extends NinePatchRect


onready var TextBox = $RichTextLabel
var Dialogue = ["This is\n a test", "This is also a [matrix]test[matrix]"] setget setD
var numPrompts

func _ready():
	numPrompts = 0
	TextBox.visible_characters = 0
	setText(Dialogue[0])
	$TypeWriterTimer.start()

func setText(text):
	TextBox.bbcode_text = text

func _process(delta):
	if(Input.is_action_just_pressed("ui_accept")):
		if(TextBox.percent_visible < 1.0):
			TextBox.percent_visible = 1.0
			$TypeWriterTimer.stop()
			$Sprite.show()
		else:
			advanceDialougue()
			
func advanceDialougue():
	numPrompts+=1
	if(numPrompts < Dialogue.size()):
		setText(Dialogue[numPrompts])
		TextBox.visible_characters = 0
		TextBox.percent_visible= 0.0
		$TypeWriterTimer.start()
		$Sprite.hide()
	else:
		hide()

func setD(DialogueArray):
	Dialogue = DialogueArray

func reset():
	setText(Dialogue[0])
	$Sprite.hide()
	$TypeWriterTimer.start()
	TextBox.visible_characters = 0
	TextBox.percent_visible = 0.0

func _on_TypeWriterTimer_timeout():
	TextBox.visible_characters += 1
	
	if(TextBox.percent_visible >= 1.0):
		$Sprite.show()
		$TypeWriterTimer.stop()
