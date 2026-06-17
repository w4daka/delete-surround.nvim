-- tests/delete_spec.lua
-- 1. プラグインのモジュールを読み込む
local ss = require("simple-surround")

describe("simple-surround 削除位置の特定ロジック", function()
	it(
		"左右にスペースがあっても、独立した2つのループで括弧の位置を正しく特定できること",
		function()
			-- 【テスト用データ】 左右に3つずつスペースがあるケース
			local input_text = "   (hello)   "

			-- 【実行】 これから実装する関数を呼び出す
			local left_idx, right_idx = ss.find_positions(input_text, "(", ")")

			-- 【検証】
			-- 期待値：左の開き括弧 "(" は 4文字目
			assert.are.equal(4, left_idx)

			-- 期待値：右の閉じ括弧 ")" は 10文字目
			assert.are.equal(10, right_idx)
		end
	)
end)

describe("simple-surround 実際の削除ロジック", function()
	it("指定したインデックスの括弧をバッファから実際に削除できること", function()
		-- 1. テスト用の匿名バッファ（画面に表示されない裏のバッファ）を作成
		local buf_id = vim.api.nvim_create_buf(false, true)

		-- 2. テスト用テキストを1行目にセット (行番号は0始まりなので 0, -1)
		local input_line = "   (hello)   "
		vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, { input_line })

		-- 3. 前回の Task 2 で作った関数を使って、括弧の位置（インデックス）を取得
		--    "   (" の "(" は 4文字目、")" は 10文字目
		local left_idx, right_idx = ss.find_positions(input_line, "(", ")")

		-- 4. 【これから実装する関数】を呼び出す
		--    引数: 対象バッファID, 行番号(1行目=1), 左のインデックス, 右のインデックス
		ss.delete_surround(buf_id, 1, left_idx, right_idx)

		-- 5. 【検証】削除実行後のバッファの1行目を習得
		local result_lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
		local actual_line = result_lines[1]

		-- 期待値：括弧だけが消えて、スペースと中身の文字列は維持されていること
		local expected_line = "   hello   "
		assert.are.equal(expected_line, actual_line)
	end)
end)
