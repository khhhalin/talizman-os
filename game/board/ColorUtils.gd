class_name ColorUtils
extends Object

## Utility class for color conversions.
## Single source of truth for hex color parsing.

static func hex_to_color(hex: String) -> Color:
	var s := hex.strip_edges()
	if s.begins_with("#"):
		s = s.substr(1)
	
	match s.length():
		6:
			return Color(
				int("0x" + s.substr(0, 2)) / 255.0,
				int("0x" + s.substr(2, 2)) / 255.0,
				int("0x" + s.substr(4, 2)) / 255.0,
				1.0
			)
		8:
			return Color(
				int("0x" + s.substr(0, 2)) / 255.0,
				int("0x" + s.substr(2, 2)) / 255.0,
				int("0x" + s.substr(4, 2)) / 255.0,
				int("0x" + s.substr(6, 2)) / 255.0
			)
		_:
			push_warning("ColorUtils: Invalid hex color format: " + hex)
			return Color.WHITE

static func color_to_hex(color: Color, include_alpha: bool = false) -> String:
	var r := int(color.r * 255)
	var g := int(color.g * 255)
	var b := int(color.b * 255)
	
	if include_alpha:
		var a := int(color.a * 255)
		return "#%02X%02X%02X%02X" % [r, g, b, a]
	else:
		return "#%02X%02X%02X" % [r, g, b]
