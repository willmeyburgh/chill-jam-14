class_name HorizontalDeleteTokenSelectorStrategy extends TokenSelectorStrategy

func hover(selector: TokenSelector,row: int, col: int):
	reset_draw(selector)
	draw_rect(
		selector,
		row,
		0,
		row,
		4,
		selector.DELETE_COLOR
	)

func select(selector: TokenSelector,row: int, col: int):
	for _col in range(5):
		selector.grid.delete_symbol(row, _col)
	selector.grid.fall()
