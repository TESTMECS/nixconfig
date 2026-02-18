local describe = require("busted").describe
local it = require("busted").it
local assert = require("busted").assert
local tyto = require("tyto")

describe("tyto", function()
	it("should test the print functions", function()
		tyto:puts("hello" .. "\n")
		tyto:putsln("hello")
		tyto:putsf("hello %s", "world" .. "\n")
		tyto:putsfln("hello %s", "world")
		tyto:putstbl({ "hello", "world" })
		tyto:newline()
		assert.truthy(true)
	end)
end)

describe("tyto.types", function()
	it("should check table", function()
		assert.truthy(tyto:is_tbl({}))
	end)
	it("should check int", function()
		assert.truthy(tyto:is_int(1))
		assert.falsy(tyto:is_int(1.1))
	end)
	it("should check number", function()
		assert.truthy(tyto:is_num(1))
	end)
	it("should check string", function()
		assert.truthy(tyto:is_str("hello"))
	end)
	it("should check function", function()
		local succ = function(x)
			return x + 1
		end
		assert.truthy(tyto:is_fn(succ))
	end)
end)

describe("tyto.cmp", function()
	it("compares numbers correctly", function()
		local t = { 5, 10 }

		assert.is_true(TYTO.cmp["<"](t, 1, 6)) -- 5 < 6
		assert.is_false(TYTO.cmp["<"](t, 2, 9)) -- 10 < 9

		assert.is_true(TYTO.cmp[">"](t, 2, 9)) -- 10 > 9
		assert.is_false(TYTO.cmp[">"](t, 1, 6)) -- 5 > 6

		assert.is_true(TYTO.cmp["<="](t, 1, 5)) -- 5 <= 5
		assert.is_false(TYTO.cmp["<="](t, 2, 9))

		assert.is_true(TYTO.cmp[">="](t, 2, 10)) -- 10 >= 10
		assert.is_false(TYTO.cmp[">="](t, 1, 6))
	end)
end)

describe("tyto.tbl", function()
	it("should test table.unpack", function()
		local t = { 1, 2, 3 }
		local a, b, c = tyto:unpack(t, 1, 3)
		assert.equal(a, 1)
		assert.equal(b, 2)
		assert.equal(c, 3)
		local t1 = { 1, 2, 3 }
		a, b = tyto:unpack(t1, 2)
		assert.equal(a, 2)
		assert.equal(b, 3)
		local t2 = { 1, 2, 3, 4 }
		--- Comparison with the default table.unpack
		a, b, c = table.unpack(t2, 1, 3)
		assert.equal(a, 1)
		assert.equal(b, 2)
		assert.equal(c, 3)
		local d = 0
		a, b, c, d = tyto:unpack(t2, 1)
		assert.equal(a, 1)
		assert.equal(b, 2)
		assert.equal(c, 3)
		assert.equal(d, 4)
	end)
	it("should flip table", function()
		local t = { ["a"] = 1, ["b"] = 2, ["c"] = 3 }
		local t1 = tyto:flipt(t)
		assert.equal(t1[1], "a")
		assert.equal(t1[2], "b")
		assert.equal(t1[3], "c")
		local t2 = { [1] = "a", [2] = "b", [3] = "c" }
		local t3 = tyto:flipt(t2)
		assert.equal(t3["a"], 1)
		assert.equal(t3["b"], 2)
		assert.equal(t3["c"], 3)
	end)
	it("should append to the list", function()
		---@alias list table<number, any>
		---@type list
		local t = {}
		tyto:append(t, 1, 2, 3)
		assert.equal(t[1], 1)
		assert.equal(t[2], 2)
		assert.equal(t[3], 3)
	end)
	it("should combine the tables", function()
		local t1 = { 1, 2, 3 }
		local t2 = { 4, 5, 6 }
		local t3 = tyto:update(t1, t2)
		print(tyto:putstbl(t3))
	end)
	it("should indexof", function()
		local t = { 1, 2, 3 }
		local i = tyto:indexof(2, t, function(a, b)
			return a == b
		end)
		assert.equal(i, 2)
	end)
end)
