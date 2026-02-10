class_name VerticalDeleteTokenSelectorStrategy extends TokenSelectorStrategy

func hover(selector: TokenSelector,row: int, col: int):
	reset_draw(selector)
	draw_rect(
		selector,
		0,
		col,
		4,
		col,
		selector.DELETE_COLOR
	)

func select(selector: TokenSelector,row: int, col: int):
	for _row in range(5):
		selector.grid.delete_symbol(_row, col)
	selector.grid.fall()
