extends Control

func _ready():
	$GifRecorder.connect('encoding_progress', self, '_on_progress')
	$GifRecorder.connect('done_encoding', self, '_on_done_encoding')
	$Button.connect('pressed', self, '_on_pressed')

	decode_file_if_it_exists()

	$GifRecorder.start()

	if $GifRecorder.record_type == $GifRecorder.RecordType.RECORD_PAST:
		$Button.disabled = true
		yield($GifRecorder, 'record_past_buffer_filled')
		$Button.disabled = false

func decode_file_if_it_exists():
	var file = File.new()

	if file.file_exists('res://test.gif'):
		print('Found GIF! Reading metadata:')
		for data in $GifDecoder.decode_file('res://test.gif'):
			print(data)

func _on_pressed():
	var metadata = {
		hello = 'world',
		super_secret_save_location = Vector2.ONE * randf() * 10000,
		some_node_path = NodePath('..')
	}
	$GifRecorder.render_to_file('res://test.gif', metadata)
	$Button.disabled = true
	yield($GifRecorder, 'done_encoding')
	$Button.disabled = false

	decode_file_if_it_exists()


func _process(delta):
	$FPS.text = '%d fps' % ceil(1 / delta) 
	if $ProgressBar.visible:
		var color = Color.red
		color.h = abs(sin($ExampleAnimatedObject.time)) 
		var fg_style = $ProgressBar.get('custom_styles/fg')
		fg_style.bg_color = color

func _on_progress(percentage, _frames_done):
	if percentage == 0:
		$ProgressBar.show()

	$ProgressBar.value = percentage

func _on_done_encoding():
	yield(get_tree().create_timer(1.0), 'timeout')
	$ProgressBar.hide()
	$GifRecorder.start()
