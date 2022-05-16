<p align="center">
<img style="height: 120px; object-fit: cover" src="https://user-images.githubusercontent.com/3514405/168532404-5716cf4b-2463-4279-ae17-a28ec50f61d9.svg" /> 
<p align="center" style="font-style: italic"> A Godot node that records gameplay & turns it into an animated GIF!</p>
<p align="center" style="font-style: italic"> <a href="README.md#Getting-Started">Getting Started</a> | <a href="README.md#Documentation">Documentation</a> | <a href="README.md#Tutorial">Tutorial</a> | <a href="https://twitter.com/bram_dingelstad">Twitter</a> | <a href="https://mastodon.gamedev.place/@bram_dingelstad">Mastodon</a> | <a href="https://ko-fi.com/bram_dingelstad">Ko-Fi</a> |</p>
</p> 

---

GifMaker is maintained by [Bram Dingelstad](https://bram.dingelstad.works), if you need a programmer or designer for your next (Godot) project, you can [hire him!](https://hire.bram.dingelstad.works)

## Getting Started

I'll write this later, stay tuned!


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

## Getting Help

There are several places to get help with GifMaker, and stay up to date with what's happening.

* [Follow me on Mastodon](https://mastodon.gamedev.place/@bram_dingelstad) or [@ me on Twitter](https://twitter.com/intent/tweet?text=Hey%20@bram_dingelstad,%20I%20need%20help%20using%20%23GifMaker%21)!
* Open an issue on [Github](https://github.com/bram-dingelstad/GifMaker/issues)!
* Email bram+gifmaker [at] dingelstad.works for more indepth questions or inqueries for consultancy. You can also email me to [hire me](https://hire.bram.dingelstad.works) for all your Godot needs!

## License

GifMaker is available under the [MIT License](LICENSE.md). This means that you can use it in any commercial or noncommercial project. The only requirement is that you need to include attribution in your game's docs. A credit would be very, very nice, too, but isn't required. If you'd like to know more about what this license lets you do, tldrlegal.com have a [very nice write up about the MIT license](https://tldrlegal.com/license/mit-license) that you might find useful.

## Made by Bram Dingelstad, Igor Santarek ([jegor377](https://github.com/jegor377)) & Martin Nov‡k ([novhack](https://github.com/novhack))

GifMaker is based on [godot-gdgifexporter](https://github.com/jegor377/godot-gdgifexporter) project by Igor Santarek, ported from the implementation by Martin Nov‡k over at the [godot-gifexpoter](https://github.com/novhack/godot-gifexporter) project.


## Help Me Make GifMaker!

GifMaker needs your help to be as awesome as it can be! You don't have to be a coder to help out - I'd love to have your help in improving this documentation!

* [Support me on Ko-Fi](https://ko-fi.com/bram_dingelstad)
* The [issues page](https://github.com/bram-dingelstad/GifMaker/issues) (sometimes) contains a list of things we'd love your help in improving.
* Follow Bram Dingelstad [on Twitter](https://twitter.com/bram_dingelstad) & [Mastodon](https://mastodon.gamedev.place/@bram_dingelstad).

# Tutorial

I'm writing tutorial later, stay tuned!

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
| [RenderType]()                                                                                 | render_type       | `RENDER_3D`   |
| [RecordType]()                                                                                 | record_type       | `RECORD_PAST` |
| [int](https://docs.godotengine.org/en/stable/classes/class_bool.html)                          | seconds           | `6.28`        |
| [Framerate]()                                                                                  | framerate         | `FPS_25`      |
| [Quantization]()                                                                               | quantization      | `UNIFORM`     |
| [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html)                         | autostart         | `false`       |
| [NodePath](https://docs.godotengine.org/en/stable/classes/class_nodepath.html)                 | capture_node_path | `null`        |
| [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html)                         | preview           | `false`       |
| [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html)                         | preview_render    | `false`       |
| [NodePath](https://docs.godotengine.org/en/stable/classes/class_nodepath.html)                 | preview_path      | `null`        |

### Methods
| Return value         | Method name                                                                                                                                                                                                 |
|----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| void                 | start ( )                                                                                                                                                                                                   |
| void                 | stop ( )                                                                                                                                                                                                    |
| void                 | clear ( )                                                                                                                                                                                                   |
| void                 | render ( [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) metadata )                                                                                                      |
| void                 | render_to_file ( [String](https://docs.godotengine.org/en/stable/classes/class_string.html) file_path, [Dictionary](https://docs.godotengine.org/en/stable/classes/class_dictionary.html) metadata = null ) |

### Signals

* record_past_buffer_filled ( ) 

  Emitted when the buffer for the `RECORD_PAST` implementation is filled.

* encoding_progress ( [float](https://docs.godotengine.org/en/stable/classes/class_float.html) percentage, [int](https://docs.godotengine.org/en/stable/classes/class_int.html) frames_done ) 

  Emitted when finishing a frame during encoding.

* done_encoding ( ) 

  Emitted when a dialogue node is started. Has the node name as a parameter so you can see which node was started.
