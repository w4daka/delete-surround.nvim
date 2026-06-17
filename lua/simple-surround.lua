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
-- lua/simple-surround.nvim (Task 4 追記部分)

-- 特定した左右のインデックスを元に、バッファから括弧を削除する関数
M.delete_surround = function(buf_id, line_num, left_idx, right_idx)
	print("\n===== [削除デバッグ開始] =====")
	print(string.format("初期座標 -> 左括弧の位置: %d, 右括弧の位置: %d", left_idx, right_idx))

	-- NeovimのAPI用に、行番号を0-basedに変換 (1行目なら 0)
	local api_line = line_num - 1

	------------------------------------------------------------
	-- 1. 先に「右側（閉じ括弧）」を削除する
	------------------------------------------------------------
	-- right_idx文字目を消すため、startは right_idx - 1、endは right_idx
	local r_start = right_idx - 1
	local r_end = right_idx

	print(string.format("[ステップ1] 右側を削除: API引数(col %d から %d まで)", r_start, r_end))
	vim.api.nvim_buf_set_text(buf_id, api_line, r_start, api_line, r_end, { "" })

	-- 【完全可視化ログ：ここがステップ2の答えだ！】
	print("[確認] 右側を消した。この時、左側の括弧の位置は...")
	print(
		string.format("  -> 依然として %d のまま！ズレていない！だから安全に消せる。", left_idx)
	)

	------------------------------------------------------------
	-- 2. 次に「左側（開き括弧）」を削除する
	------------------------------------------------------------
	-- left_idx文字目を消すため、startは left_idx - 1、endは left_idx
	local l_start = left_idx - 1
	local l_end = left_idx

	print(string.format("[ステップ2] 左側を削除: API引数(col %d から %d まで)", l_start, l_end))
	vim.api.nvim_buf_set_text(buf_id, api_line, l_start, api_line, l_end, { "" })

	print("===== [削除デバッグ終了] 全ての括弧の削除が成功！ =====\n")
end

return M
