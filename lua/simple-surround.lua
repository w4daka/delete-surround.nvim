-- lua/simple-surround.nvim
local M = {}

-- 左右のスペースを無視して、指定された括弧ペアの位置（インデックス）を返す関数
M.find_positions = function(text, open_char, close_char)
	-- #text の # は、Luaにおいて「文字列の長さ（文字数）」や「テーブルの要素数」を数えて数字として返す魔法の記号（長さ演算子）だ。
	local len = #text -- <-わからん
	local left_idx = nil
	local right_idx = nil

	print("\n===== [デバッグ開始] 入力文字列: '" .. text .. "' (長さ: " .. len .. ") =====")

	------------------------------------------------------------
	-- 1. 左側スキャンループ（1番目から右へ進む固定forループ）
	------------------------------------------------------------
	for i = 1, len do
		local char = string.sub(text, i, i)

		-- 【お前のための完全可視化ログ】
		print(string.format("[左ループ] インデックス: %d, 文字: '%s'", i, char))

		if char ~= " " then
			-- スペース以外の文字に出会った瞬間
			if char == open_char then
				left_idx = i
				print("  -> 【合格】開き括弧 '" .. open_char .. "' を発見！位置: " .. left_idx)
			else
				print(
					"  -> 【不合格】スペース以外だが、期待した開き括弧ではない文字: '" .. char .. "'"
				)
			end

			-- スペース以外の文字に出会ったら、括弧であれ何であれ、この左ループは絶対に終了する
			break
		end
	end

	------------------------------------------------------------
	-- 2. 右側スキャンループ（最後の文字から左へ戻る固定forループ）
	------------------------------------------------------------
	-- ループの第3引数「-1」は、インデックスを1ずつ減らしながら戻るという意味
	for i = len, 1, -1 do
		local char = string.sub(text, i, i)

		-- 【お前のための完全可視化ログ】
		print(string.format("[右ループ] インデックス: %d, 文字: '%s'", i, char))

		if char ~= " " then
			-- スペース以外の文字に出会った瞬間
			if char == close_char then
				right_idx = i
				print("  -> 【合格】閉じ括弧 '" .. close_char .. "' を発見！位置: " .. right_idx)
			else
				print(
					"  -> 【不合格】スペース以外だが、期待した閉じ括弧ではない文字: '" .. char .. "'"
				)
			end

			-- スペース以外の文字に出会ったら、括弧であれ何であれ、この右ループは絶対に終了する
			break
		end
	end

	print(
		"===== [デバッグ終了] 確定したインデックス: 左="
			.. tostring(left_idx)
			.. ", 右="
			.. tostring(right_idx)
			.. " =====\n"
	)

	-- 2つの特定した位置を返す
	return left_idx, right_idx
end

return M
