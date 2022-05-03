extends Viewport
class_name GifRecorder, 'res://addons/GifMaker/gif.svg'

signal record_past_buffer_filled
signal encoding_progress(percentage)
signal done_encoding

const GIFExporter = preload('res://addons/GifMaker/godot-gdgifexporter/gdgifexporter/exporter.gd')
const MedianCutQuantization = preload('res://addons/GifMaker/godot-gdgifexporter/gdgifexporter/quantization/median_cut.gd')

enum { 
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

# TODO: Implement debug preview
# TODO: Add FrameTimer without owner to hide in scene
# TODO: Implement 2D Rectangle (also in editor gizmo)
# TODO: Implement different quantization
# TODO: Implement RENDER_3D
# TODO: Implement adding & reading arbitrary data
# TODO: Re-write get_properties_list to fancify input
# TODO: Custom node?
# TODO: Perhaps find a way to render the viewport in editor
# TODO: Write documentation README.md
# TODO: Record a lil' video with an example Godot project
# TODO: Write known limitations / future improvements

export(int, 'Render 3D', 'Render 2D') var render_type = RENDER_3D
export(RecordType) var record_type = RecordType.RECORD_PAST
export var seconds = 60 setget set_seconds
export(Framerate) var framerate = 4 setget set_framerate
export var debug_preview = false
export var autostart = false

var frame_amount = 0
var frame_passed = 0
var frames = []
var exporter

func _ready():
	exporter = GIFExporter.new(size.x, size.y)
	self.framerate = framerate
	self.seconds = seconds

	$FrameTimer.connect('timeout', self, 'capture')

	if autostart:
		start()

func start():
	$FrameTimer.start()

func stop():
	$FrameTimer.stop()

func clear():
	frames = []

func render():
	stop()

	if OS.can_use_threads():
		var thread = Thread.new()
		thread.start(self, 'encode', true)
		while thread.is_alive():
			yield(get_tree(), 'idle_frame')

		return thread.wait_to_finish()
	else:
		return encode()


func encode(in_thread = false):
	var frames_done = .0
	for frame in frames:
		emit_signal('encoding_progress', frames_done / frames.size())
		frame.convert(Image.FORMAT_RGBA8)
		exporter.add_frame(frame, framerate, MedianCutQuantization)
		frames_done += 1

	exporter.add_comment_ext('Made with GifMaker by Bram Dingelstad')

	emit_signal('encoding_progress', 1)
	emit_signal('done_encoding')
	return exporter.export_file_data()

func render_to_file(file_path):
	var buffer = render()
	if buffer is GDScriptFunctionState:
		buffer = yield(buffer, 'completed')

	var file = File.new()
	file.open(file_path, File.WRITE)
	file.store_buffer(buffer)
	file.close()

func capture():
	match render_type:
		RENDER_2D:
			var screenshot = get_tree().root.get_texture().get_data()
			screenshot.flip_y()
			var frame = Image.new()
			frame.create(size.x, size.y, false, screenshot.get_format())
			frame.blit_rect(
				screenshot,
				Rect2(Vector2(512, 300) - size / 2, size),
				Vector2.ZERO
			)
			frames.append(frame)
	
	match record_type:
		RecordType.RECORD_PAST:
			while frames.size() > frame_amount:
				frames.pop_front()
				emit_signal('record_past_buffer_filled')

func update_frame_amount():
	frame_amount = 100 / framerate * seconds

func set_framerate(_framerate):
	framerate = _framerate
	if is_inside_tree():
		$FrameTimer.wait_time = 1.0 / (100.0 / framerate)
	update_frame_amount()

func set_seconds(_seconds):
	seconds = _seconds
	update_frame_amount()
