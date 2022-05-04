extends Node
class_name GifDecoder

func decode_file(path):
	var file = File.new()
	file.open(path, File.READ)
	var bytes = file.get_buffer(file.get_len())
	file.close()

	return decode_data(bytes)

func decode_block(block: PoolByteArray, start, end):
	var string = block.subarray(start, end).get_string_from_utf8()
	if string.begins_with('GIF_MAKER::'):
		return str2var(string.substr('GIF_MAKER::'.length(), string.length()))
	return string

func decode_data(bytes: PoolByteArray):
	var index = 0
	var start = -1
	var end = -1
	var data = []

	for byte in bytes:
		if start != -1 \
				and byte == 0x21:
			end = index - 1

			data.append(decode_block(bytes, start, end))
			start = -1
			end = -1

		if byte == 0x21 \
				and index < bytes.size() \
				and bytes[index + 1] == 0xFE:
			start = index + 2

		index += 1

	if end == -1 and start != -1:
		end = bytes.size() - 1
		data.append(decode_block(bytes, start, end))

	return data
