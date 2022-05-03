extends Control

func _ready():
	$GifRecorder.connect('encoding_progress', self, '_on_progress')
	$Button.connect('pressed', self, '_on_pressed')
	$GifRecorder.start()

	if $GifRecorder.record_type == $GifRecorder.RecordType.RECORD_PAST:
		$Button.disabled = true
		yield($GifRecorder, 'record_past_buffer_filled')
		$Button.disabled = false

func _on_pressed():
	$GifRecorder.render_to_file('res://test.gif')
	$Button.disabled = true
	yield($GifRecorder, 'done_encoding')
	$Button.disabled = false

func _process(delta):
	if $ProgressBar.visible:
		var color = Color.red
		color.h = abs(sin($ExampleAnimatedObject.time)) 
		var fg_style = $ProgressBar.get('custom_styles/fg')
		fg_style.bg_color = color


func _on_progress(percentage):
	if percentage == 0:
		$ProgressBar.show()

	$ProgressBar.value = percentage

	if percentage == 1:
		yield(get_tree().create_timer(1.0), 'timeout')
		$ProgressBar.hide()
