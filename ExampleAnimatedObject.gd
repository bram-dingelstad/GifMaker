tool
extends Node2D

export var amount = 8
var time = .0

func _draw():
	for i in range(0, amount):
		var color = Color.red
		color.h = sin(-time + .1 * i) * .5 + .5

		var pos = Vector2(
			sin(time + TAU / amount * i) * 40,
			cos(time + TAU / amount * i) * 40
		)

		draw_circle(
			pos,
			sin(time + PI / amount * i) * 10,
			color
		)

func _process(delta):
	time = fmod(time + delta, TAU)
	update()
