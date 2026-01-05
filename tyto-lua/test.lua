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

local fn = tyto.fn
describe("tyto.Fn", function()
	it("should apply the function", function()
		local t = fn(function(x)
			return x + 1
		end) % 1
		assert.equal(t, 2)
	end)
	it("should compose", function()
		local t = fn(function(x)
			return x + 1
		end) * fn(function(x)
			return x + 1
		end) % 1
		assert.equal(t, 3)
	end)
	it("should map the succ", function()
		local t = tyto:map({ 1, 2, 3 }, function(_, v)
			return v + 1
		end)
		assert.equal(t[1], 2)
		assert.equal(t[2], 3)
		assert.equal(t[3], 4)
	end)
	it("should imap the succ", function()
		local people = {
			{ name = "a", age = 10 },
			{ name = "b", age = 20 },
		}

		local names = TYTO:imap(people, "name")
		assert.equal(names[1], "a")
		assert.equal(names[2], "b")
		local t = { 1, 2, 3 }

		local out = TYTO:imap(t, function(x)
			return x * 10
		end)
		assert.equal(out[1], 10)
		assert.equal(out[2], 20)
		assert.equal(out[3], 30)
	end)
end)

local arrow = tyto.arrow
describe("tyto.arrow", function()
	it("should apply succ", function()
		local succ = function(x)
			return x + 1
		end
		local t = 1 % arrow(succ)
		assert.equal(t, 2)
	end)
	it("should compose.", function()
		local succ = function(x)
			return x + 1
		end
		local t = 1 % arrow(succ) ^ arrow(succ)
		assert.equal(t, 3)
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

describe("tyto.misc", function()
	it("should generate uuid", function()
		fn(print):apply(tyto:uuid())
		assert.truthy(tyto:uuid())
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

describe("option.lua", function()
	it("should show an example of using option", function()
		-- 1. Finds user in a table (might fail)
		local function find_user(id)
			local users = { [1] = "Alice", [2] = "Bob" }
			return users[id] -- Returns nil if not found
		end

		-- 2. Transforms a name to uppercase (pure)
		local function upper(name)
			return name:upper()
		end

		-- 3. Finds a user's role (might fail)
		---@return Option
		local function get_role(upper_name)
			local roles = { ["ALICE"] = "Admin", ["BOB"] = "Guest" }
			return tyto.option.of(roles[upper_name])
		end
		local user_id = 1 -- 1:Admin, 2:Guest
		-- USAGE
		local role = tyto.option.of(find_user(user_id)):map(upper):bind(get_role):unwrap_or("Unknown")
		assert.equal(role, "Admin")
	end)
end)

describe("result.lua", function()
	it("should show an example of using option", function()
		---@return Result
		local function parse_number(s)
			local num = tonumber(s)
			if num == nil then
				return tyto.result.Err("Parse Error: Input '" .. s .. "' is not a valid number.")
			else
				return tyto.result.Ok(num)
			end
		end
		---@return Result
		local function safe_divide(numerator, denominator)
			if denominator == 0 then
				return tyto.result.Err("Division Error: Cannot divide by zero.")
			else
				return tyto.result.Ok(numerator / denominator)
			end
		end
		local function divide_by_100(x)
			return safe_divide(100, x)
		end
		-- Success Case
		local result_ok = parse_number("50") -- Result.Ok(50)
			:bind(divide_by_100) -- Result.Ok(2)
			:map(function(x)
				return x + 1
			end) -- Result.Ok(3)
			:unwrap_or(0)
		print("Result OK:", result_ok) -- Output: Result OK: 3
		-- Failure Case (Parse Error)
		local result_err_parse = parse_number("hello") -- Result.Err("Parse Error...")
			:bind(divide_by_100) -- Skips, returns Result.Err("Parse Error...")
			:unwrap_or(-1)
		print("Result Err Parse:", result_err_parse) -- Output: Result Err Parse: -1
		-- Failure Case (Division Error)
		local result_err_div = parse_number("0") -- Result.Ok(0)
			:bind(divide_by_100) -- Result.Err("Division Error...")
			:map_err(function(e)
				return "CRITICAL: " .. e
			end) -- Result.Err("CRITICAL: Division Error...")
			:unwrap_or(-2)
		print("Result Err Div:", result_err_div) -- Output: Result Err Div: -2
	end)
end)
