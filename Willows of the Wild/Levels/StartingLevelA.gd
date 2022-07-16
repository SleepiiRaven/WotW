extends Node2D

onready var canvas = $CanvasLayer

func _ready():
	canvas.glue = PlayerStats.glue
