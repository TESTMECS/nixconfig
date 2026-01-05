--[[
-- Copyright (c) TESTMEE 2025
-- My My lua and tyto
--]]
---@class tyto
---@field arrow table
---@field fn table
---@field cmp table
TYTO = {}
TYTO.__index = TYTO
---=== === === === === Types === === === ===  ===
function TYTO:is_num(x)
	return type(x) == "number"
end
function TYTO:is_int(x)
	return type(x) == "number" and math.floor(x) == x
end
function TYTO:is_str(x)
	return type(x) == "string"
end
function TYTO:is_tbl(x)
	return type(x) == "table"
end
function TYTO:is_fn(f)
	return type(f) == "function"
end
---=== === === === === puts === === === ===  ===
---@vararg any
function TYTO:puts(...)
	io.write((...))
end
---@vararg any
function TYTO:putsln(...)
	io.write((...) .. "\n")
end
---@vararg any
function TYTO:putsf(fmt, ...)
	io.write(string.format(fmt, ...))
end
---@vararg any
function TYTO:putsfln(fmt, ...)
	io.write(string.format(fmt, ...) .. "\n")
end
---@description: prints a table with each element on a new line
---@param t table
function TYTO:putstbl(t)
	io.write(string.format("\n{i}|{j}\n{--|--}\n"))
	for i, v in ipairs(t) do
		io.write(string.format("{%s}|{%s}\n", i, v))
	end
end
function TYTO:newline()
	io.write("\n")
end
---=== === === === === map === === === ===  ===
---@description: map f over t or extract a column from a list of records.
---@param t table
---@param f string|fun(k: any, v: any, ...: any): any
---@vararg any
---@return table
function TYTO:map(t, f, ...)
	local dt = {}
	if type(f) == "function" then
		for k, v in pairs(t) do
			dt[k] = f(k, v, ...)
		end
	else
		for k, v in pairs(t) do
			local sel = v[f]
			if type(sel) == "function" then --method to apply
				dt[k] = sel(v, ...)
			else --field to pluck
				dt[k] = sel
			end
		end
	end
	return dt
end
---@description: map f over t or extract a column from a list of records.
---@param t table
---@param f string|fun(k: any, v: any, ...: any): any
---@vararg any
---@return table
function TYTO:imap(t, f, ...)
	local dt = { n = t.n }
	local n = t.n or #t
	if type(f) == "function" then
		for i = 1, n do
			dt[i] = f(t[i], ...)
		end
	else
		for i = 1, n do
			local v = t[i]
			local sel = v[f]
			if type(sel) == "function" then --method to apply
				dt[i] = sel(v, ...)
			else --field to pluck
				dt[i] = sel
			end
		end
	end
	return dt
end
--- === === === === === Misc === === === === ===
---@description: generate a uuid
---@return string
function TYTO:uuid()
	return ("%08x-%04x-%04x-%04x-%08x%04x"):format(
		math.random(0xffffffff),
		math.random(0xffff),
		0x4000 + math.random(0x0fff), --4xxx
		0x8000 + math.random(0x3fff), --10bb-bbbb-bbbb-bbbb
		math.random(0xffffffff),
		math.random(0xffff)
	)
end
function TYTO:sign(x)
	return x > 0 and 1 or x == 0 and 0 or -1
end
------@description: readonly table
---@return table
function TYTO:readonlyTbl(t)
	return setmetatable(t, {
		__newindex = function()
			error("trying to set a field in tyto.Tbl")
		end, --read-only
		__metatable = false,
	})
end
---@description: table.unpack but with default j of n or #t
---@param t table
---@param i? number
---@param j? number
function TYTO:unpack(t, i, j)
	return table.unpack(t, i or 1, j or t.n or #t)
end
---@description: flip a table
---@param t table
---@return table: with the keys as values and the values as keys
function TYTO:flipt(t)
	local dt = {}
	for k, v in pairs(t) do
		dt[v] = k
	end
	return dt
end
---@description: append non-nil arguments to a list.
---@param dt table
---@vararg any
function TYTO:append(dt, ...)
	local j = #dt
	for i = 1, select("#", ...) do
		dt[j + i] = select(i, ...)
	end
	return dt
end
---@description: update a table with the contents of other table(s).
---@param dt table
---@vararg table
function TYTO:update(dt, ...)
	for i = 1, select("#", ...) do
		local t = select(i, ...)
		if t then
			for k, v in pairs(t) do
				dt[k] = v
			end
		end
	end
	return dt
end
---@description: scan list for value.
---@param v any: value to search for
---@param t table: list to search
---@param eq fun(a: any, b: any): boolean
---@param i? number: start index
---@param j? number: end index
function TYTO:indexof(v, t, eq, i, j)
	i = i or 1
	j = j or #t
	if eq then
		for i = i, j do
			if eq(t[i], v) then
				return i
			end
		end
	else
		for i = i, j do
			if t[i] == v then
				return i
			end
		end
	end
end
-- === === === === === FN === === === ===  ===
---@class Fn
local Fn = {}
---@meta __index Fn
Fn.__index = Fn
---=== FN ===
---@description: The wrapper of a function from A to B.
---===Fn:
---fn(f) * fn(g) % x
---===Fn:
---f(g(x))
---@generic A, B
---@class Fn<A, B> : { raw: fun(x: A): B }
---@method Fn.compose
---@method Fn.apply
---@generic A, B
---@alias fnops.Fn Fn<A,B>
---@description: Compose two functions.
---```
---fn(f):compose(fn(g)) -- luarrow (method call)
---===
---fn(f) .. fn(g) -- luarrow (operator call)
---===
---fn(function(x) return f(g(x)) end) -- Pure Lua
---```
---@generic A, B, C
---@param self Fn<A, B>
---@param g Fn<B, C>
---@return Fn<A, B>
function Fn:compose(g)
	local self_raw = self.raw
	local g_raw = g.raw
	return Fn.new(function(x)
		return self_raw(g_raw(x))
	end)
end
Fn.__mul = Fn.compose
---@description: Apply a function to value. __%
---```
---===Fn:
---fn(f):apply(x)
---===Fn:
---fn(f) % x
---===Lua:
---f(x)
---```
---@generic A, B
---@param self Fn<A, B>
---@param x A
---@return B
function Fn:apply(x)
	return self.raw(x)
end
---@meta __mod "Fn.apply"
Fn.__mod = Fn.apply
---@description: Create a new Fn.
---@generic A, B
---@param func fun(x: A): B
---@return Fn<A, B>
function Fn.new(func)
	---@generic A,B
	---@type Fn<A, B>
	local self = setmetatable({}, Fn)
	self.raw = func
	return self
end
TYTO.fn = Fn.new

-- === === === === === Arrow === === === ===  ===
---@class Arrow
local Arrow = {}
---@description:
--- Similar to `Fun<A, B>`, but the direction of composition is different.
---===Arrow:
---```lua
---local result =
---  x
---  % arrow(f)
---  ^ arrow(g)
---  ^ arrow(h)
---===Pure Lua:
---local result = h(g(f(x)))
---```
---@generic A, B
---@class Arrow<A, B> : { raw: fun(x: A): B }
---@meta __index Arrow
Arrow.__index = Arrow
---@description: Expose Alias
---@alias Tyto.Arrow Arrow
---```lua
---===Arrow:
---arrow(f):compose_to(arrow(g))
---===Arrow:
---arrow(f) ^ arrow(g)
---===PureLua:
---arrow(function(x) return g(f(x)) end)
---```
---@generic A, B, C
---@param self Arrow<A, B>
---@param g Arrow<B, C>
---@return Arrow<A, C>
function Arrow:compose_to(g)
	-- To optimize performance, assign to variables outside
	local self_raw = self.raw
	local g_raw = g.raw
	return Arrow.new(function(x)
		return g_raw(self_raw(x))
	end)
end
---@meta __pow "Arrow.compose_to"
Arrow.__pow = Arrow.compose_to
---Same as `Fun.apply()`
---@see Arrow.__mod
---```lua
---===Arrow:
---arrow(f):apply(x)
---===Arrow:
---x % arrow(f)
---===Pure Lua:
---f(x)
---```
---@generic A, B
---@param self Arrow<A, B>
---@param x A
---@return B
function Arrow:apply(x)
	return self.raw(x)
end
---```lua
---local result = x % arrow(raw_f)
---```
---@generic A, B
---@param x A
---@param f Arrow<A, B>
---@return B
Arrow.__mod = function(x, f)
	return f:apply(x)
end
---@generic A, B
---@param func fun(x: A): B
---@return Arrow<A, B>
function Arrow.new(func)
	---@generic A,B
	---@type Arrow<A,B>
	local self = setmetatable({}, Arrow)
	self.raw = func
	return self
end
TYTO.arrow = Arrow.new
local cmps = {}
cmps["<"] = function(t, i, v)
	return t[i] < v
end
cmps[">"] = function(t, i, v)
	return t[i] > v
end
cmps["<="] = function(t, i, v)
	return t[i] <= v
end
cmps[">="] = function(t, i, v)
	return t[i] >= v
end
TYTO.cmp = cmps
-- === Option<T> type ===
---@class Option
---@field is_some boolean
---@field is_none boolean
---@field value any
local Option = {}
Option.__index = Option

local NONE_SENTINEL = setmetatable({}, {
	__tostring = function()
		return "None"
	end,
})
-- Some metatable
local function create_option_mt(_)
	local mt = {
		__index = Option,
		__tostring = function(self)
			if self.is_some then
				return "Some(" .. tostring(self.value) .. ")"
			else
				return "None"
			end
		end,
	}
	return mt
end
-- Private constructor for the 'Some' state
local function Some(value)
	-- guard against wrapping the nil value with itself
	if value == nil or value == NONE_SENTINEL then
		return Option.None
	end
	return setmetatable({
		is_some = true,
		is_none = false,
		value = value,
	}, create_option_mt("Some"))
end
-- Public None object.
Option.None = setmetatable({
	is_some = false,
	is_none = true,
}, create_option_mt("None"))
-- Public factory function to create an Option
-- Converts a raw value (which might be nil) into an Option.
function Option.of(value)
	if value == nil then
		return Option.None
	else
		return Some(value)
	end
end
-- Option.map implementation
function Option:map(f)
	if self.is_some then
		-- If it's Some, apply the function and wrap the result in a new Option
		return Option.of(f(self.value))
	else
		-- If it's None, just return None
		return Option.None
	end
end
-- Option.bind/flatMap implementation
function Option:bind(f)
	if self.is_some then
		-- If it's Some, apply the function. The function f MUST return an Option.
		-- We return f's result directly (no re-wrapping).
		return f(self.value)
	else
		-- If it's None, just return None
		return Option.None
	end
end
-- Option.unwrap_or implementation
function Option:unwrap_or(default_value)
	if self.is_some then
		return self.value
	else
		-- If it's None, return the provided default
		return default_value
	end
end
TYTO.option = Option
---@class Result
---@field is_ok boolean
---@field is_err boolean
---@field value any
---@field error any
local Result = {}
Result.__index = Result

local function create_result_mt(_)
	local mt = {
		__index = Result,
		__tostring = function(self)
			if self.is_ok then
				return "Ok(" .. tostring(self.value) .. ")"
			else
				return "Err(" .. tostring(self.error) .. ")"
			end
		end,
	}
	return mt
end

local function Ok(value)
	if value == nil then
		error("Cannot construct an 'Ok' Result with nil value.", 2)
	end
	return setmetatable({
		is_ok = true,
		is_err = false,
		value = value,
	}, create_result_mt("Ok"))
end

local function Err(error_value)
	if error_value == nil then
		error_value = "Unknown Error"
	end
	return setmetatable({
		is_ok = false,
		is_err = true,
		error = error_value,
	}, create_result_mt("Err"))
end
function Result:map(f)
	if self.is_ok then
		-- If Ok, apply the function and wrap the result in a new Ok
		return Result.Ok(f(self.value))
	else
		-- If Err, return the existing Err object
		return self
	end
end
function Result:bind(f)
	if self.is_ok then
		-- If Ok, apply the function f. f MUST return a Result (Ok or Err).
		-- We return f's result directly (no re-wrapping).
		return f(self.value)
	else
		-- If Err, return the existing Err object
		return self
	end
end
function Result:map_err(f)
	if self.is_err then
		-- If Err, apply the function to the error payload and create a new Err
		return Result.Err(f(self.error))
	else
		-- If Ok, return the existing Ok object
		return self
	end
end
function Result:unwrap_or(default_value)
	if self.is_ok then
		return self.value
	else
		-- If Err, return the provided default
		return default_value
	end
end
function Result:expect(message)
	if self.is_ok then
		return self.value
	else
		-- Panic/Error with the custom message and the error payload
		error(message .. ": " .. tostring(self.error), 2)
	end
end
function Result:unwrap_err()
	if self.is_err then
		return self.error
	else
		error("Called unwrap_err() on an Ok result: " .. tostring(self.value), 2)
	end
end
Result.Ok = Ok
Result.Err = Err
TYTO.result = Result
---@instance
TYTO = setmetatable({}, TYTO)
return TYTO
