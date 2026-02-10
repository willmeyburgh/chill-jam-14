class_name SingleDeleteTokenSelectorStrategy extends TokenSelectorStrategy

func hover(selector: TokenSelector,row: int, col: int):
	reset_draw(selector)
	draw_rect(
		selector,
		row,
		col,
		row,
		col,
		selector.DELETE_COLOR
	)

func select(selector: TokenSelector,row: int, col: int):
	selector.grid.delete_symbol(row, col)
	selector.grid.fall()
