extends Viewport
class_name GifRecorder, 'res://addons/GifMaker/gif.svg'

signal record_past_buffer_filled
signal encoding_progress(percentage, frames_done)
signal done_encoding

const GIFExporter = preload('res://addons/GifMaker/godot-gdgifexporter/gdgifexporter/exporter.gd')
const MedianCut = preload('res://addons/GifMaker/godot-gdgifexporter/gdgifexporter/quantization/median_cut.gd')
const Uniform = preload('res://addons/GifMaker/godot-gdgifexporter/gdgifexporter/quantization/uniform.gd')

enum RenderType { 
	RENDER_3D, 
	RENDER_2D
}

enum RecordType {
	RECORD_PAST,
	RECORD
}

enum Framerate {
	FPS_100 = 1,
	FPS_50 = 2,
	FPS_33 = 3,
	FPS_25 = 4,
	FPS_20 = 5,
	FPS_10 = 10,
	FPS_8 = 12,
	FPS_4 = 24,
	FPS_2 = 48,
	FPS_1 = 100
}

enum Quantization {
	MEDIAN_CUT,
	UNIFORM
}

# TODO: Re-write get_properties_list to fancify input
# TODO: Perhaps find a way to render the viewport in editor
# TODO: Record a lil' video with an example Godot project

export(int, 'Render 3D', 'Render 2D') var render_type = RenderType.RENDER_3D setget set_render_type
export(RecordType) var record_type = RecordType.RECORD_PAST
export var seconds = 6.28 setget set_seconds
export(Framerate) var framerate = Framerate.FPS_25 setget set_framerate
export(Quantization) var quantization = Quantization.UNIFORM
export var autostart = false

export(NodePath) var capture_node_path
onready var capture_node = get_node(capture_node_path)

export var preview = false
export var preview_render = false
export(NodePath) var preview_path
onready var preview_node = get_node(preview_path)

var frame_amount = 0
var frame_passed = 0
var frames = []
var exporter
var frame_timer
var thread

func _ready():
	frame_timer = Timer.new()
	add_child(frame_timer)

	assert(capture_node, 'No capture node detected, please add a Camera3D or GifRectangle to get started')

	self.framerate = framerate
	self.seconds = seconds
	self.render_type = render_type

	frame_timer.connect('timeout', self, 'capture')

	if autostart:
		start()

func start():
	frame_timer.start()

func stop():
	frame_timer.stop()

func clear():
	frames = []

func render(metadata = null): 
	stop()

	exporter = GIFExporter.new(size.x, size.y)

	if OS.can_use_threads():
		thread = Thread.new()
		thread.start(self, 'encode', metadata)
		while thread.is_alive():
			yield(get_tree(), 'idle_frame')

		return thread.wait_to_finish()
	else:
		return encode(metadata)

func encode(metadata = null):
	var frames_done = 0
	var quantization_method = \
			Uniform if quantization == Quantization.UNIFORM else MedianCut

	for frame in frames:
		emit_signal('encoding_progress', float(frames_done) / frames.size(), frames_done)
		frame.convert(Image.FORMAT_RGBA8)
		exporter.add_frame(frame, framerate, quantization_method)
		frames_done += 1

		if preview and preview_render:
			var texture = ImageTexture.new()
			texture.create_from_image(frame)
			preview_node.texture = texture

	if metadata:
		exporter.add_comment_ext('GIF_MAKER::' + var2str(metadata))

	exporter.add_comment_ext('🙋 Made with GifMaker by Bram Dingelstad')

	emit_signal('encoding_progress', 1.0, frames_done)
	emit_signal('done_encoding')
	return exporter.export_file_data()

func render_to_file(file_path, metadata = null):
	var buffer = render(metadata)
	if buffer is GDScriptFunctionState:
		buffer = yield(buffer, 'completed')

	var file = File.new()
	file.open(file_path, File.WRITE)
	file.store_buffer(buffer)
	file.close()

func capture():
	var frame = Image.new()
	var screenshot
	match render_type:
		RenderType.RENDER_2D:
			screenshot = get_tree().root.get_texture().get_data()
			screenshot.flip_y()
		RenderType.RENDER_3D:
			screenshot = get_texture().get_data()
			if not render_target_v_flip:
				screenshot.flip_y()

	frame.create(size.x, size.y, false, screenshot.get_format())
	frame.blit_rect(
		screenshot,
		Rect2(capture_node.rect_position if render_type == RenderType.RENDER_2D else Vector2.ZERO, size),
		Vector2.ZERO
	)
	frames.append(frame)
	
	match record_type:
		RecordType.RECORD_PAST:
			while frames.size() > frame_amount:
				frames.pop_front()
				emit_signal('record_past_buffer_filled')

	if preview:
		var texture = ImageTexture.new()
		texture.create_from_image(frame)
		preview_node.texture = texture

func _process(delta):
	render_target_update_mode = UPDATE_DISABLED if render_type == RenderType.RENDER_2D else UPDATE_ALWAYS

	match render_type:
		RenderType.RENDER_2D:
			size = capture_node.rect_size

		RenderType.RENDER_3D:
			$Camera.transform = capture_node.transform
			$Camera.fov = $Camera.fov

			# TODO: Sync more properties like culling mask, projection, etc

func update_frame_amount():
	frame_amount = 100 / framerate * seconds

func set_framerate(_framerate):
	framerate = _framerate
	if is_inside_tree():
		frame_timer.wait_time = 1.0 / (100.0 / framerate)
	update_frame_amount()

func set_seconds(_seconds):
	seconds = _seconds
	update_frame_amount()

func set_render_type(_render_type):
	render_type = _render_type

	match render_type:
		RenderType.RENDER_3D:
			var shadow_capture_node = capture_node.duplicate()
			shadow_capture_node.name = 'Camera'
			shadow_capture_node.script = null
			add_child(shadow_capture_node)
