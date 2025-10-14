class_name Utils

static func round_rect2(rect: Rect2) -> Rect2:
	return Rect2(
		Vector2(round(rect.position.x), round(rect.position.y)),
		Vector2(round(rect.size.x), round(rect.size.y))
	)
