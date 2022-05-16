<p align="center">
<img style="height: 120px; object-fit: cover" src="https://user-images.githubusercontent.com/3514405/168532404-5716cf4b-2463-4279-ae17-a28ec50f61d9.svg" /> 
<p align="center" style="font-style: italic"> A Godot node that records gameplay & turns it into an animated GIF!</p>
<p align="center" style="font-style: italic"> <a href="README.md#Getting-Started">Getting Started</a> | <a href="README.md#Documentation">Documentation</a> | <a href="README.md#Tutorial">Tutorial</a> | <a href="https://twitter.com/bram_dingelstad">Twitter</a> | <a href="https://mastodon.gamedev.place/@bram_dingelstad">Mastodon</a> | <a href="https://ko-fi.com/bram_dingelstad">Ko-Fi</a> </p>
</p> 

---

GifMaker is maintained by [Bram Dingelstad](https://bram.dingelstad.works), if you need a programmer or designer for your next (Godot) project, you can [hire him!](https://hire.bram.dingelstad.works)

## Getting Started

It's easy to get started, download the addon whichever way you like and open the `Example2D.tscn` or `Example3D.tscn` scene to get a working example!
Change some settings and checkout the effects, study the implementation in `ExampleScene.gd` to learn how to implement it in your own game.

For a more deeper dive, I recommend reading the [Tutorial](#Tutorial).

### Download from AssetLib
This is in the works! This section will be updated once this method is available

### Clone this repository / [download the zip](https://github.com/bram-dingelstad/GifMaker/archive/refs/heads/main.zip)

1. Extract the repository in a folder of your choice.
2. Import the project in Godot.
3. Run the scene to get a taste of GifMaker!
4. Move the addons folder to your Godot project.
5. Enable the plugin in your Project Settings.
6. Setup the GifMaker node using the [documentation](README.md#Documentation) or [tutorial](README.md#Tutorial)!

## Roadmap / Known issues

There are few things that need to be ironed out

- [ ] Noticable artifacts when trying to record too many colors at once
- [ ] Crashes when trying to record too many colors & preview at the same time [without enabling enabling multi-threading](https://docs.godotengine.org/en/stable/tutorials/performance/threads/thread_safe_apis.html#rendering)
- [ ] Documentation
    - [ ] GifDecoder
    - [ ] Enums
    - [ ] Tutorial

## Getting Help

There are several places to get help with GifMaker, and stay up to date with what's happening.

* [Follow me on Mastodon](https://mastodon.gamedev.place/@bram_dingelstad) or [@ me on Twitter](https://twitter.com/intent/tweet?text=Hey%20@bram_dingelstad,%20I%20need%20help%20using%20%23GifMaker%21)!
* Open an issue on [Github](https://github.com/bram-dingelstad/GifMaker/issues)!
* Email bram+gifmaker [at] dingelstad.works for more indepth questions or inqueries for consultancy. You can also email me to [hire me](https://hire.bram.dingelstad.works) for all your Godot needs!

## License

GifMaker is available under the [MIT License](LICENSE.md). This means that you can use it in any commercial or noncommercial project. The only requirement is that you need to include attribution in your game's docs. A credit would be very, very nice, too, but isn't required. If you'd like to know more about what this license lets you do, tldrlegal.com have a [very nice write up about the MIT license](https://tldrlegal.com/license/mit-license) that you might find useful.

## Made by Bram Dingelstad, Igor Santarek ([jegor377](https://github.com/jegor377)) & Martin Novák ([novhack](https://github.com/novhack))

GifMaker is based on [godot-gdgifexporter](https://github.com/jegor377/godot-gdgifexporter) project by Igor Santarek, ported from the implementation by Martin Novák over at the [godot-gifexpoter](https://github.com/novhack/godot-gifexporter) project.

## Help Me Make GifMaker!

GifMaker needs your help to be as awesome as it can be! You don't have to be a coder to help out - I'd love to have your help in improving this documentation!

* [Support me on Ko-Fi](https://ko-fi.com/bram_dingelstad)
* The [issues page](https://github.com/bram-dingelstad/GifMaker/issues) (sometimes) contains a list of things we'd love your help in improving.
* Follow Bram Dingelstad [on Twitter](https://twitter.com/bram_dingelstad) & [Mastodon](https://mastodon.gamedev.place/@bram_dingelstad).

# Tutorial

For this tutorial we'll use an example Godot project that can be found through the Assetlib or through Github. 

## 2D example

I'll be using [2D Platformer (KinematicBody)](https://godotengine.org/asset-library/asset/120). 
Download the addon outlined in [Getting Started](#getting-started) and put in in the `res://addons` folder in your project.

Add a new node and through pressing the `+` button in your Scene explorer or by hitting `CMD/CTRL + A`. Type in `GifRecorder` and press enter.
Setup the newly added node by setting `render_type` to `Render 2D` & `autostart` enabled. Next up, add another node: this time the `GifRectangle`.
Set the dimensions and location of the `GifRectangle` to the center with a width and height of 256 pixels. 
Set the `GifRecorder` size to the same dimensions to make the viewport warning go away. 
When the game starts it will always automatically set the size to the size of the `GifRectangle`.
Set the `capture_node_path` value in the inspector of `GifRecorder` to the newly added `GifRectangle`.

Next up, we add some code to the `Game.gd` to start encoding the gif when we press `G`.
```
func _input(event):
	if event is InputEventKey \
			and event.scancode == KEY_G \
			and event.pressed:
		
		print('Encoding GIF')

		$GifRecorder.render_to_file('res://test.gif')
		yield($GifRecorder, 'done_encoding')

		print('Done encoding GIF!')

		$GifRecorder.clear()
		$GifRecorder.start()
```

Next up we play the game and do something for a while, then press `G`. The encoding might take a while since the GDScript implementation isn't too fast.
As an exercise to you, you can try connecting the `encoding_progress` signal to print the progress of the encoding.

You should end up with something like this over at `res://test.gif`:  

![A GIF generated from Godot](https://user-images.githubusercontent.com/3514405/168601841-c224df5b-9322-4147-9eb6-4f2d8906eff8.gif)

Check out the rest of the documentation below to add metadata to the file or alter settings or `record_type`.

# Documentation

## `GifRecorder` 
_Inherits from [Viewport](https://docs.godotengine.org/en/stable/classes/class_viewport.html)_

Node for recording gameplay and converting them to GIFs.

### Description
Godot's Nodes as building blocks work really well. That's why this plugin gives you access to a simple node that does all the heavy lifting for you.
It has several properties that you can change either in-editor or using GDScript (or any other compatible language) and signals you can use to listen to events coming from recording your game.

### Properties
| Type                                                                                           | Property          | Default value |
|------------------------------------------------------------------------------------------------|-------------------|---------------|
| [RenderType](#RenderType)                                                                      | render_type       | `RENDER_3D`   |
| [RecordType](#RecordType)                                                                      | record_type       | `RECORD_PAST` |
| [float](https://docs.godotengine.org/en/stable/classes/class_float.html)                       | seconds           | `6.28`        |
| [Framerate](#FrameRate)                                                                        | framerate         | `FPS_25`      |
| [Quantization](#Quantization)                                                                  | quantization      | `UNIFORM`     |
| [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html)                         | autostart         | `false`       |
| [NodePath](https://docs.godotengine.org/en/stable/classes/class_nodepath.html)                 | capture_node_path | `null`        |
| [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html)                         | preview           | `false`       |
| [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html)                         | preview_render    | `false`       |
| [NodePath](https://docs.godotengine.org/en/stable/classes/class_nodepath.html)                 | preview_path      | `null`        |

### Methods
| Return value                                                                             | Method name                                                                                                                                                                                                 |
|------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| void                                                                                     | start ( )                                                                                                                                                                                                   |
| void                                                                                     | stop ( )                                                                                                                                                                                                    |
| void                                                                                     | clear ( )                                                                                                                                                                                                   |
| [PoolByteArray](https://docs.godotengine.org/en/stable/classes/class_poolbytearray.html) | render ( [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) metadata = null )                                                                                               |
| void                                                                                     | render_to_file ( [String](https://docs.godotengine.org/en/stable/classes/class_string.html) file_path, [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) metadata = null ) |

### Signals

* record_past_buffer_filled ( ) 

  Emitted when the buffer for the `RECORD_PAST` implementation is filled.

* encoding_progress ( [float](https://docs.godotengine.org/en/stable/classes/class_float.html) percentage, [int](https://docs.godotengine.org/en/stable/classes/class_int.html) frames_done ) 

  Emitted when finishing a frame during encoding.

* done_encoding ( ) 

  Emitted when a dialogue node is started. Has the node name as a parameter so you can see which node was started.

### Property Descriptions
* [RenderType](#RenderType) render_type
  
  |Default|`RENDER_3D`|
  |-------|-----------|

  The type of rendering you want to do. Either `RENDER_3D` (default) or `RENDER_2D`. Each requires a different setup with the capture node selected through `capture_node_path`.

* [RecordType](#RecordType) record_type
  
  |Default|`RECORD_PAST`|
  |-------|-------------|

  The way you want to record the GIF. You have two options:

  `RECORD_PAST` is always recording in the background using a fixed size buffer, meaning it will store a GIF with it's length controlled by the `seconds` property.
  Any frames that are old when the buffer reaches it's size will be deleted causing the last few moments with a length of `second` are recorded.
  When calling `render()` or `render_to_file()` the buffer gets rendered as a GIF.

  `RECORD` is a manually operated recording mode that doesn't use a buffer of frames but allows the user to manually choose a beginning and end of a GIF.
  This setting ignores any values set in `seconds` since it doesn't have a maximum size.

* [float](https://docs.godotengine.org/en/stable/classes/class_float.html) seconds
  
  |Default|`6.28`|
  |-------|------|

  `seconds` decides the frame buffer size by multiplying the amount by the value set in `framerate`. Only effective when using `RECORD_PAST` as the `record_type`.

* [Framerate](#Framerate) framerate
  
  |Default|`FPS_25`|
  |-------|--------|

  `framerate` is the rate at which frames are recorded and rendered for the final GIF. This value is done using a enum because of the GIF specification describing the framerate as an integer divided by 100.
  In order to prevent confusion we use an enum that give a range of different framerates that are actually supported by the specification.

* [Quantization](#Quantization) quantization
  
  |Default|`UNIFORM`|
  |-------|---------|

  Quantization is the way the colors in a frame of the GIF are being compressed. This is to circumvent the 256 color limitation.
  `UNIFORM` bring a very GIF-esque effect where `MEDIAN_CUT` brings a more high quality GIF. If the frame has less or equal than 256 colors no quantization is used.

* [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html) autostart 
  
  |Default|`false`|
  |-------|-------|

  When this value is set to `true` the node automatically calls `start()` when it's ready.

* [NodePath](https://docs.godotengine.org/en/stable/classes/class_nodepath.html) capture_node_path
  
  |Default|`null`|
  |-------|------|

  The path to the render context specific recording node (`GifRectangle` for `RENDER_2D`, a `Camera` for `RENDER_3D`).

* [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html) preview
  
  |Default|`false`|
  |-------|-------|

  A boolean that decides whether or not the `GifRecorder` shares preview frames with a `TextureRect` selected through `preview_path`.

* [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html) preview_render
  
  |Default|`false`|
  |-------|-------|

  A boolean that decides whether or not the `GifRecorder` shares render frames with a `TextureRect` selected through `preview_path`.
  This will show the current frame being rendered when set to `true`, you will no longer see the normal preview.

* [NodePath](https://docs.godotengine.org/en/stable/classes/class_nodepath.html) capture_node_path
  
  |Default|`null`|
  |-------|------|

  The path to a `TextureRect` to preview the current frame or rendered frame by `GifRecorder`.


### Method Descriptions

* void **start** ( ) 

 Starts the recording.

* void **stop** ( ) 

 Stops the recording.

* void **clear** ( ) 

 Clears the current record buffer. `clear()` isn't automatically called after `render` or `render_to_file`, so you could render the same GIF twice or record for longer.

* [PoolByteArray](https://docs.godotengine.org/en/stable/classes/class_poolbytearray.html) **render** ( [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) metadata = null )

 Stops and renders the current record buffer and returns a [PoolByteArray](https://docs.godotengine.org/en/stable/classes/class_poolbytearray.html) with the GIF data.
 Encodes `metadata` using [`var2str`](https://docs.godotengine.org/en/stable/classes/class_@gdscript.html#class-gdscript-method-var2str) in UTF8 to the comment section of the GIF file as per GIF89a specification.

* void **render_to_file** ( [String](https://docs.godotengine.org/en/stable/classes/class_string.html) file_path, [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) metadata = null )

 Stops and renders the current record buffer and writes it to the file specified by `file_path`.
 Encodes `metadata` using [`var2str`](https://docs.godotengine.org/en/stable/classes/class_@gdscript.html#class-gdscript-method-var2str) in UTF8 to the comment section of the GIF file as per GIF89a specification.

