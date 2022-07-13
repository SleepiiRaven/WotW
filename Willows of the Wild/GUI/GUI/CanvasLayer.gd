extends CanvasLayer

var glue = 0

func _physics_process(delta):
	$Currency/Label.text = "x" + str(glue)
