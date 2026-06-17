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
