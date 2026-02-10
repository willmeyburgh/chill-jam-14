class_name TokenSelectorStrategy extends Resource

func init(selector: TokenSelector):
	reset_draw(selector)

func hover(selector: TokenSelector,row: int, col: int):
	pass
	
func select(selector: TokenSelector, row: int, col: int):
	pass
	
func unhover(selector: TokenSelector):
	reset_draw(selector)
	
func draw_rect(
	selector: TokenSelector,
	from_row: int,
	from_col: int,
	to_row: int,
	to_col: int,
	color: Color
):
	selector.store.get_or_add('draw', []).append({
		'type': 'rect',
		'from': {
			'row': from_row,
			'col': from_col,
		},
		'to': {
			'row': to_row,
			'col': to_col,
		},
		'color': color
	})
	
func reset_draw(
	selector: TokenSelector
):
	selector.store['draw'] = []
	selector.queue_redraw()
	
func _draw_rect(selector: TokenSelector, draw: Dictionary):
	var from = selector.grid.cell_global_position(draw['from']['row'], draw['from']['col'])-24*Vector2.ONE
	var to = selector.grid.cell_global_position(draw['to']['row'], draw['to']['col'])+24*Vector2.ONE
	var rect = Rect2(
		selector.to_local(from),
		to-from
	)
	selector.draw_rect(
		rect,
		draw['color']
	)
	

func draw(selector: TokenSelector):
	for draw: Dictionary in selector.store['draw']:
		if draw['type'] == 'rect':
			_draw_rect(selector, draw)
