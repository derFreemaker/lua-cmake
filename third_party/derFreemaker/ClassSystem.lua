---@diagnostic disable

	local __fileFuncs__ = {}
	local __cache__ = {}
	local function __loadFile__(module)
	    if not __cache__[module] then
	        __cache__[module] = { __fileFuncs__[module]() }
	    end
	    return table.unpack(__cache__[module])
	end
	__fileFuncs__["src.Config"] = function()
	---@class Freemaker.ClassSystem.Configs
	local Configs = {}

	--- All meta methods that should be added as meta method to the class.
	Configs.AllMetaMethods = {
	    --- Before Constructor
	    __preinit = true,
	    --- Constructor
	    __init = true,
	    --- Garbage Collection
	    __gc = true,
	    --- Out of Scope
	    __close = true,

	    --- Special
	    __call = true,
	    __newindex = true,
	    __index = true,
	    __pairs = true,
	    __ipairs = true,
	    __tostring = true,

	    -- Operators
	    __add = true,
	    __sub = true,
	    __mul = true,
	    __div = true,
	    __mod = true,
	    __pow = true,
	    __unm = true,
	    __idiv = true,
	    __band = true,
	    __bor = true,
	    __bxor = true,
	    __bnot = true,
	    __shl = true,
	    __shr = true,
	    __concat = true,
	    __len = true,
	    __eq = true,
	    __lt = true,
	    __le = true
	}

	--- Blocks meta methods on the blueprint of an class.
	Configs.BlockMetaMethodsOnBlueprint = {
	    __pairs = true,
	    __ipairs = true
	}

	--- Blocks meta methods if not set by the class.
	Configs.BlockMetaMethodsOnInstance = {
	    __pairs = true,
	    __ipairs = true
	}

	--- Meta methods that should not be set to the classes metatable, but remain in the type.MetaMethods.
	Configs.IndirectMetaMethods = {
	    __preinit = true,
	    __gc = true,
	    __index = true,
	    __newindex = true
	}

	-- Indicates that the __close method is called from the ClassSystem.Deconstruct method.
	Configs.Deconstructing = {}

	-- Placeholder is used to indicate that this member should be set by super class of the abstract class
	---@type any
	Configs.AbstractPlaceholder = {}

	-- Placeholder is used to indicate that this member should be set by super class of the interface
	---@type any
	Configs.InterfacePlaceholder = {}

	return Configs

end

__fileFuncs__["src.Meta"] = function()
	---@meta

	----------------------------------------------------------------
	-- MetaMethods
	----------------------------------------------------------------

	---@class Freemaker.ClassSystem.ObjectMetaMethods
	---@field protected __preinit (fun(...) : any) | nil self(...) before contructor
	---@field protected __init (fun(self: object, ...)) | nil self(...) constructor
	---@field protected __call (fun(self: object, ...) : ...) | nil self(...) after construction
	---@field protected __close (fun(self: object, errObj: any) : any) | nil invoked when the object gets out of scope
	---@field protected __gc fun(self: object) | nil Freemaker.ClassSystem.Deconstruct(self) or garbageCollection
	---@field protected __add (fun(self: object, other: any) : any) | nil (self) + (value)
	---@field protected __sub (fun(self: object, other: any) : any) | nil (self) - (value)
	---@field protected __mul (fun(self: object, other: any) : any) | nil (self) * (value)
	---@field protected __div (fun(self: object, other: any) : any) | nil (self) / (value)
	---@field protected __mod (fun(self: object, other: any) : any) | nil (self) % (value)
	---@field protected __pow (fun(self: object, other: any) : any) | nil (self) ^ (value)
	---@field protected __idiv (fun(self: object, other: any) : any) | nil (self) // (value)
	---@field protected __band (fun(self: object, other: any) : any) | nil (self) & (value)
	---@field protected __bor (fun(self: object, other: any) : any) | nil (self) | (value)
	---@field protected __bxor (fun(self: object, other: any) : any) | nil (self) ~ (value)
	---@field protected __shl (fun(self: object, other: any) : any) | nil (self) << (value)
	---@field protected __shr (fun(self: object, other: any) : any) | nil (self) >> (value)
	---@field protected __concat (fun(self: object, other: any) : any) | nil (self) .. (value)
	---@field protected __eq (fun(self: object, other: any) : any) | nil (self) == (value)
	---@field protected __lt (fun(t1: any, t2: any) : any) | nil (self) < (value)
	---@field protected __le (fun(t1: any, t2: any) : any) | nil (self) <= (value)
	---@field protected __unm (fun(self: object) : any) | nil -(self)
	---@field protected __bnot (fun(self: object) : any) | nil  ~(self)
	---@field protected __len (fun(self: object) : any) | nil #(self)
	---@field protected __pairs (fun(t: table) : ((fun(t: table, key: any) : key: any, value: any), t: table, startKey: any)) | nil pairs(self)
	---@field protected __ipairs (fun(t: table) : ((fun(t: table, key: number) : key: number, value: any), t: table, startKey: number)) | nil ipairs(self)
	---@field protected __tostring (fun(t):string) | nil tostring(self)
	---@field protected __index (fun(class, key) : any) | nil xxx = self.xxx | self[xxx]
	---@field protected __newindex fun(class, key, value) | nil self.xxx = xxx | self[xxx] = xxx

	---@class object : Freemaker.ClassSystem.ObjectMetaMethods, function

	---@class Freemaker.ClassSystem.MetaMethods
	---@field __gc fun(self: object) | nil Class.Deconstruct(self) or garbageCollection
	---@field __close (fun(self: object, errObj: any) : any) | nil invoked when the object gets out of scope
	---@field __call (fun(self: object, ...) : ...) | nil self(...) after construction
	---@field __index (fun(class: object, key: any) : any) | nil xxx = self.xxx | self[xxx]
	---@field __newindex fun(class: object, key: any, value: any) | nil self.xxx | self[xxx] = xxx
	---@field __tostring (fun(t):string) | nil tostring(self)
	---@field __add (fun(left: any, right: any) : any) | nil (left) + (right)
	---@field __sub (fun(left: any, right: any) : any) | nil (left) - (right)
	---@field __mul (fun(left: any, right: any) : any) | nil (left) * (right)
	---@field __div (fun(left: any, right: any) : any) | nil (left) / (right)
	---@field __mod (fun(left: any, right: any) : any) | nil (left) % (right)
	---@field __pow (fun(left: any, right: any) : any) | nil (left) ^ (right)
	---@field __idiv (fun(left: any, right: any) : any) | nil (left) // (right)
	---@field __band (fun(left: any, right: any) : any) | nil (left) & (right)
	---@field __bor (fun(left: any, right: any) : any) | nil (left) | (right)
	---@field __bxor (fun(left: any, right: any) : any) | nil (left) ~ (right)
	---@field __shl (fun(left: any, right: any) : any) | nil (left) << (right)
	---@field __shr (fun(left: any, right: any) : any) | nil (left) >> (right)
	---@field __concat (fun(left: any, right: any) : any) | nil (left) .. (right)
	---@field __eq (fun(left: any, right: any) : any) | nil (left) == (right)
	---@field __lt (fun(left: any, right: any) : any) | nil (left) < (right)
	---@field __le (fun(left: any, right: any) : any) | nil (left) <= (right)
	---@field __unm (fun(self: object) : any) | nil -(self)
	---@field __bnot (fun(self: object) : any) | nil ~(self)
	---@field __len (fun(self: object) : any) | nil #(self)
	---@field __pairs (fun(self: object) : ((fun(t: table, key: any) : key: any, value: any), t: table, startKey: any)) | nil pairs(self)
	---@field __ipairs (fun(self: object) : ((fun(t: table, key: number) : key: number, value: any), t: table, startKey: number)) | nil ipairs(self)

	---@class Freemaker.ClassSystem.TypeMetaMethods : Freemaker.ClassSystem.MetaMethods
	---@field __preinit (fun(...) : any) | nil self(...) before constructor
	---@field __init (fun(self: object, ...)) | nil self(...) constructor

	----------------------------------------------------------------
	-- Type
	----------------------------------------------------------------

	---@class Freemaker.ClassSystem.Type
	---@field Name string
	---
	---@field Base Freemaker.ClassSystem.Type | nil
	---@field Interfaces table<integer, Freemaker.ClassSystem.Type>
	---
	---@field Static table<string, any>
	---
	---@field MetaMethods Freemaker.ClassSystem.TypeMetaMethods
	---@field Members table<any, any>
	---
	---@field HasPreConstructor boolean
	---@field HasConstructor boolean
	---@field HasDeconstructor boolean
	---@field HasClose boolean
	---@field HasIndex boolean
	---@field HasNewIndex boolean
	---
	---@field Options Freemaker.ClassSystem.Type.Options
	---
	---@field Instances table<object, boolean>
	---
	---@field Blueprint table | nil

	---@class Freemaker.ClassSystem.Type.Options
	---@field IsAbstract boolean | nil
	---@field IsInterface boolean | nil

	----------------------------------------------------------------
	-- Metatable
	----------------------------------------------------------------

	---@class Freemaker.ClassSystem.Metatable : Freemaker.ClassSystem.MetaMethods
	---@field Type Freemaker.ClassSystem.Type
	---@field Instance Freemaker.ClassSystem.Instance

	----------------------------------------------------------------
	-- Blueprint
	----------------------------------------------------------------

	---@class Freemaker.ClassSystem.BlueprintMetatable : Freemaker.ClassSystem.MetaMethods
	---@field Type Freemaker.ClassSystem.Type

	----------------------------------------------------------------
	-- Instance
	----------------------------------------------------------------

	---@class Freemaker.ClassSystem.Instance
	---@field IsConstructed boolean
	---
	---@field CustomIndexing boolean

	----------------------------------------------------------------
	-- Create Options
	----------------------------------------------------------------

	---@class Freemaker.ClassSystem.Create.Options : Freemaker.ClassSystem.Type.Options
	---@field Name string | nil
	---
	---@field Inherit table<object> | object | nil

end

__fileFuncs__["tools.Freemaker.bin.utils"] = function()
	---@diagnostic disable

	local __fileFuncs__ = {}
	local __cache__ = {}
	local function __loadFile__(module)
	    if not __cache__[module] then
	        __cache__[module] = { __fileFuncs__[module]() }
	    end
	    return table.unpack(__cache__[module])
	end
	__fileFuncs__["src.Utils.String"] = function()
		---@class Freemaker.Utils.String
		local String = {}

		---@param str string
		---@param pattern string
		---@param plain boolean | nil
		---@return string | nil, integer
		local function findNext(str, pattern, plain)
		    local found = str:find(pattern, 0, plain or false)
		    if found == nil then
		        return nil, 0
		    end
		    return str:sub(0, found - 1), found - 1
		end

		---@param str string | nil
		---@param sep string | nil
		---@param plain boolean | nil
		---@return string[]
		function String.Split(str, sep, plain)
		    if str == nil then
		        return {}
		    end

		    local strLen = str:len()
		    local sepLen

		    if sep == nil then
		        sep = "%s"
		        sepLen = 2
		    else
		        sepLen = sep:len()
		    end

		    local tbl = {}
		    local i = 0
		    while true do
		        i = i + 1
		        local foundStr, foundPos = findNext(str, sep, plain)

		        if foundStr == nil then
		            tbl[i] = str
		            return tbl
		        end

		        tbl[i] = foundStr
		        str = str:sub(foundPos + sepLen + 1, strLen)
		    end
		end

		---@param str string | nil
		---@return boolean
		function String.IsNilOrEmpty(str)
		    if str == nil then
		        return true
		    end
		    if str == "" then
		        return true
		    end
		    return false
		end

		---@param array string[]
		---@param sep string
		---@return string
		function String.Join(array, sep)
		    local str = ""

		    str = array[1]
		    for _, value in next, array, 1 do
		        str = str .. sep .. value
		    end

		    return str
		end

		return String

	end

	__fileFuncs__["src.Utils.Table"] = function()
		---@class Freemaker.Utils.Table
		local Table = {}

		---@param obj table | nil
		---@param seen table[]
		---@return table | nil
		local function copyTable(obj, copy, seen)
		    if obj == nil then return nil end
		    if seen[obj] then return seen[obj] end

		    seen[obj] = copy
		    setmetatable(copy, copyTable(getmetatable(obj), {}, seen))

		    for key, value in next, obj, nil do
		        key = (type(key) == "table") and copyTable(key, {}, seen) or key
		        value = (type(value) == "table") and copyTable(value, {}, seen) or value
		        rawset(copy, key, value)
		    end

		    return copy
		end

		---@generic TTable
		---@param t TTable
		---@return TTable table
		function Table.Copy(t)
		    return copyTable(t, {}, {})
		end

		---@param from table
		---@param to table
		function Table.CopyTo(from, to)
		    copyTable(from, to, {})
		end

		---@param t table
		---@param ignoreProperties string[] | nil
		function Table.Clear(t, ignoreProperties)
		    if not ignoreProperties then
		        for key, _ in next, t, nil do
		            t[key] = nil
		        end
		    else
		        for key, _ in next, t, nil do
		            if not Table.Contains(ignoreProperties, key) then
		                t[key] = nil
		            end
		        end
		    end

		    setmetatable(t, nil)
		end

		---@param t table
		---@param value any
		---@return boolean
		function Table.Contains(t, value)
		    for _, tValue in pairs(t) do
		        if value == tValue then
		            return true
		        end
		    end
		    return false
		end

		---@param t table
		---@param key any
		---@return boolean
		function Table.ContainsKey(t, key)
		    if t[key] ~= nil then
		        return true
		    end
		    return false
		end

		--- removes all spaces between
		---@param t any[]
		function Table.Clean(t)
		    for key, value in pairs(t) do
		        for i = key - 1, 1, -1 do
		            if key ~= 1 then
		                if t[i] == nil and (t[i - 1] ~= nil or i == 1) then
		                    t[i] = value
		                    t[key] = nil
		                    break
		                end
		            end
		        end
		    end
		end

		---@param t table
		---@return integer count
		function Table.Count(t)
		    local count = 0
		    for _, _ in next, t, nil do
		        count = count + 1
		    end
		    return count
		end

		---@param t table
		---@return table
		function Table.Invert(t)
		    local inverted = {}
		    for key, value in pairs(t) do
		        inverted[value] = key
		    end
		    return inverted
		end

		return Table

	end

	__fileFuncs__["src.Utils.Value"] = function()
		local Table = __loadFile__("src.Utils.Table")

		---@class Freemaker.Utils.Value
		local Value = {}

		---@generic T
		---@param value T
		---@return T
		function Value.Copy(value)
		    local typeStr = type(value)

		    if typeStr == "table" then
		        return Table.Copy(value)
		    end

		    return value
		end

		return Value

	end

	__fileFuncs__["__main__"] = function()
		---@class Freemaker.Utils
		---@field String Freemaker.Utils.String
		---@field Table Freemaker.Utils.Table
		---@field Value Freemaker.Utils.Value
		local Utils = {}

		Utils.String = __loadFile__("src.Utils.String")
		Utils.Table = __loadFile__("src.Utils.Table")
		Utils.Value = __loadFile__("src.Utils.Value")

		return Utils

	end

	---@type Freemaker.Utils
	local main = __fileFuncs__["__main__"]()
	return main

end

__fileFuncs__["src.Class"] = function()
	---@class Freemaker.ClassSystem
	local Class = {}

	---@param obj any
	---@return Freemaker.ClassSystem.Type | nil
	function Class.Typeof(obj)
	    if not type(obj) == "table" then
	        return nil
	    end

	    local metatable = getmetatable(obj)
	    if not metatable then
	        return nil
	    end

	    return metatable.Type
	end

	---@param obj any
	---@return string
	function Class.Nameof(obj)
	    local typeInfo = Class.Typeof(obj)
	    if not typeInfo then
	        return type(obj)
	    end

	    return typeInfo.Name
	end

	---@param obj object
	---@return Freemaker.ClassSystem.Instance | nil
	function Class.GetInstanceData(obj)
	    if not Class.IsClass(obj) then
	        return
	    end

	    ---@type Freemaker.ClassSystem.Metatable
	    local metatable = getmetatable(obj)
	    return metatable.Instance
	end

	---@param obj any
	---@return boolean isClass
	function Class.IsClass(obj)
	    if type(obj) ~= "table" then
	        return false
	    end

	    local metatable = getmetatable(obj)

	    if not metatable then
	        return false
	    end

	    if not metatable.Type then
	        return false
	    end

	    if not metatable.Type.Name then
	        return false
	    end

	    return true
	end

	---@param obj any
	---@param className string
	---@return boolean hasBaseClass
	function Class.HasBase(obj, className)
	    if not Class.IsClass(obj) then
	        return false
	    end

	    local metatable = getmetatable(obj)

	    ---@param typeInfo Freemaker.ClassSystem.Type
	    local function hasBase(typeInfo)
	        local typeName = typeInfo.Name
	        if typeName == className then
	            return true
	        end

	        if not typeInfo.Base then
	            return false
	        end

	        return hasBase(typeInfo.Base)
	    end

	    return hasBase(metatable.Type)
	end

	---@param obj any
	---@param interfaceName string
	---@return boolean hasInterface
	function Class.HasInterface(obj, interfaceName)
	    if not Class.IsClass(obj) then
	        return false
	    end

	    local metatable = getmetatable(obj)

	    ---@param typeInfo Freemaker.ClassSystem.Type
	    local function hasInterface(typeInfo)
	        local typeName = typeInfo.Name
	        if typeName == interfaceName then
	            return true
	        end

	        for _, value in pairs(typeInfo.Interfaces) do
	            if hasInterface(value) then
	                return true
	            end
	        end

	        return false
	    end

	    return hasInterface(metatable.Type)
	end

	return Class

end

__fileFuncs__["src.Object"] = function()
	local Utils = __loadFile__("tools.Freemaker.bin.utils")
	local Config = __loadFile__("src.Config")
	local Class = __loadFile__("src.Class")

	---@class object
	local Object = {}

	---@protected
	---@return string typeName
	function Object:__tostring()
	    return Class.Typeof(self).Name
	end

	---@protected
	---@return string
	function Object.__concat(left, right)
	    return tostring(left) .. tostring(right)
	end

	---@class Freemaker.ClassSystem.Object.Modify
	---@field CustomIndexing boolean | nil

	---@protected
	---@param func fun(modify: Freemaker.ClassSystem.Object.Modify)
	function Object:Raw__ModifyBehavior(func)
	    ---@type Freemaker.ClassSystem.Metatable
	    local metatable = getmetatable(self)

	    local modify = {
	        CustomIndexing = metatable.Instance.CustomIndexing
	    }

	    func(modify)

	    metatable.Instance.CustomIndexing = modify.CustomIndexing
	end

	----------------------------------------
	-- Type Info
	----------------------------------------

	---@type Freemaker.ClassSystem.Type
	local objectTypeInfo = {
	    Name = "object",
	    Base = nil,
	    Interfaces = {},

	    Static = {},
	    MetaMethods = {},
	    Members = {},

	    HasPreConstructor = false,
	    HasConstructor = false,
	    HasDeconstructor = false,
	    HasClose = false,
	    HasIndex = false,
	    HasNewIndex = false,

	    Options = {
	        IsAbstract = true,
	    },

	    Instances = setmetatable({}, { __mode = 'k' }),

	    -- no blueprint since cannot be constructed
	    Blueprint = nil
	}

	for key, value in pairs(Object) do
	    if Config.AllMetaMethods[key] then
	        objectTypeInfo.MetaMethods[key] = value
	    else
	        if type(key) == 'string' then
	            local splittedKey = Utils.String.Split(key, '__')
	            if Utils.Table.Contains(splittedKey, 'Static') then
	                objectTypeInfo.Static[key] = value
	            else
	                objectTypeInfo.Members[key] = value
	            end
	        else
	            objectTypeInfo.Members[key] = value
	        end
	    end
	end

	setmetatable(
	        objectTypeInfo,
	        {
	            __tostring = function(self)
	                return self.Name
	            end
	        }
	    )

	return objectTypeInfo

end

__fileFuncs__["src.Type"] = function()
	---@class Freemaker.ClassSystem.TypeHandler
	local TypeHandler = {}

	---@param base Freemaker.ClassSystem.Type | nil
	---@param interfaces table<Freemaker.ClassSystem.Type>
	---@param options Freemaker.ClassSystem.Create.Options
	function TypeHandler.Create(base, interfaces, options)
	    local typeInfo = {
	        Name = options.Name,
	        Base = base,
	        Interfaces = interfaces,

	        Options = options,

	        MetaMethods = {},
	        Members = {},
	        Static = {},

	        Instances = setmetatable({}, { __mode = "k" }),
	    }

	    options.Name = nil
	    options.Inherit = nil
	    ---@cast typeInfo Freemaker.ClassSystem.Type

	    setmetatable(
	        typeInfo,
	        {
	            __tostring = function(self)
	                return self.Name
	            end
	        }
	    )

	    return typeInfo
	end

	return TypeHandler

end

__fileFuncs__["src.Instance"] = function()
	local Utils = __loadFile__("tools.Freemaker.bin.utils")

	---@class Freemaker.ClassSystem.InstanceHandler
	local InstanceHandler = {}

	---@param instance Freemaker.ClassSystem.Instance
	function InstanceHandler.Initialize(instance)
	    instance.CustomIndexing = true
	    instance.IsConstructed = false
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param instance object
	function InstanceHandler.Add(typeInfo, instance)
	    typeInfo.Instances[instance] = true

	    if typeInfo.Base then
	        InstanceHandler.Add(typeInfo.Base, instance)
	    end

	    for _, parent in pairs(typeInfo.Interfaces) do
	        InstanceHandler.Add(parent, instance)
	    end
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param instance object
	function InstanceHandler.Remove(typeInfo, instance)
	    typeInfo.Instances[instance] = nil

	    if typeInfo.Base then
	        InstanceHandler.Remove(typeInfo.Base, instance)
	    end

	    for _, parent in pairs(typeInfo.Interfaces) do
	        InstanceHandler.Remove(parent, instance)
	    end
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param name string
	---@param func function
	function InstanceHandler.UpdateMetaMethod(typeInfo, name, func)
	    typeInfo.MetaMethods[name] = func

	    for instance in pairs(typeInfo.Instances) do
	        local instanceMetatable = getmetatable(instance)

	        if not Utils.Table.ContainsKey(instanceMetatable, name) then
	            instanceMetatable[name] = func
	        end
	    end
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param key any
	---@param value any
	function InstanceHandler.UpdateMember(typeInfo, key, value)
	    typeInfo.Members[key] = value

	    for instance in pairs(typeInfo.Instances) do
	        if not Utils.Table.ContainsKey(instance, key) then
	            rawset(instance, key, value)
	        end
	    end
	end

	return InstanceHandler

end

__fileFuncs__["src.Members"] = function()
	local Utils = __loadFile__("tools.Freemaker.bin.utils")

	local Config = __loadFile__("src.Config")

	local InstanceHandler = __loadFile__("src.Instance")

	---@class Freemaker.ClassSystem.MembersHandler
	local MembersHandler = {}

	---@param typeInfo Freemaker.ClassSystem.Type
	function MembersHandler.UpdateState(typeInfo)
	    local metaMethods = typeInfo.MetaMethods

	    typeInfo.HasConstructor = metaMethods.__init ~= nil
	    typeInfo.HasDeconstructor = metaMethods.__gc ~= nil
	    typeInfo.HasClose = metaMethods.__close ~= nil
	    typeInfo.HasIndex = metaMethods.__index ~= nil
	    typeInfo.HasNewIndex = metaMethods.__newindex ~= nil
	end

	function MembersHandler.GetStatic(typeInfo, key)
	    return rawget(typeInfo.Static, key)
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param key string
	---@param value any
	---@return boolean wasFound
	local function assignStatic(typeInfo, key, value)
	    if rawget(typeInfo.Static, key) ~= nil then
	        rawset(typeInfo.Static, key, value)
	        return true
	    end

	    if typeInfo.Base then
	        return assignStatic(typeInfo.Base, key, value)
	    end

	    return false
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param key string
	---@param value any
	function MembersHandler.SetStatic(typeInfo, key, value)
	    if not assignStatic(typeInfo, key, value) then
	        rawset(typeInfo.Static, key, value)
	    end
	end

	-------------------------------------------------------------------------------
	-- Index & NewIndex
	-------------------------------------------------------------------------------

	---@param typeInfo Freemaker.ClassSystem.Type
	---@return fun(obj: object, key: any) : any value
	function MembersHandler.TemplateIndex(typeInfo)
	    return function(obj, key)
	        if type(key) ~= "string" then
	            error("can only use static members in template")
	            return {}
	        end

	        local splittedKey = Utils.String.Split(key, "__")
	        if Utils.Table.Contains(splittedKey, "Static") then
	            return MembersHandler.GetStatic(typeInfo, key)
	        end

	        error("can only use static members in template")
	    end
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@return fun(obj: object, key: any, value: any)
	function MembersHandler.TemplateNewIndex(typeInfo)
	    return function(obj, key, value)
	        if type(key) ~= "string" then
	            error("can only use static members in template")
	            return
	        end

	        local splittedKey = Utils.String.Split(key, "__")
	        if Utils.Table.Contains(splittedKey, "Static") then
	            MembersHandler.SetStatic(typeInfo, key, value)
	            return
	        end

	        error("can only use static members in template")
	    end
	end

	---@param instance Freemaker.ClassSystem.Instance
	---@param typeInfo Freemaker.ClassSystem.Type
	---@return fun(obj: object, key: any) : any value
	function MembersHandler.InstanceIndex(instance, typeInfo)
	    return function(obj, key)
	        if type(key) == "string" then
	            local splittedKey = Utils.String.Split(key, "__")
	            if Utils.Table.Contains(splittedKey, "Static") then
	                return MembersHandler.GetStatic(typeInfo, key)
	            elseif Utils.Table.Contains(splittedKey, "Raw") then
	                return rawget(obj, key)
	            end
	        end

	        if typeInfo.HasIndex and instance.CustomIndexing then
	            return typeInfo.MetaMethods.__index(obj, key)
	        end

	        return rawget(obj, key)
	    end
	end

	---@param instance Freemaker.ClassSystem.Instance
	---@param typeInfo Freemaker.ClassSystem.Type
	---@return fun(obj: object, key: any, value: any)
	function MembersHandler.InstanceNewIndex(instance, typeInfo)
	    return function(obj, key, value)
	        if type(key) == "string" then
	            local splittedKey = Utils.String.Split(key, "__")
	            if Utils.Table.Contains(splittedKey, "Static") then
	                return MembersHandler.SetStatic(typeInfo, key, value)
	            elseif Utils.Table.Contains(splittedKey, "Raw") then
	                rawset(obj, key, value)
	            end
	        end

	        if typeInfo.HasNewIndex and instance.CustomIndexing then
	            return typeInfo.MetaMethods.__newindex(obj, key, value)
	        end

	        rawset(obj, key, value)
	    end
	end

	-------------------------------------------------------------------------------
	-- Sort
	-------------------------------------------------------------------------------

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param name string
	---@param func function
	local function isNormalFunction(typeInfo, name, func)
	    if Utils.Table.ContainsKey(Config.AllMetaMethods, name) then
	        typeInfo.MetaMethods[name] = func
	        return
	    end

	    typeInfo.Members[name] = func
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param name string
	---@param value any
	local function isNormalMember(typeInfo, name, value)
	    if type(value) == 'function' then
	        isNormalFunction(typeInfo, name, value)
	        return
	    end

	    typeInfo.Members[name] = value
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param name string
	---@param value any
	local function isStaticMember(typeInfo, name, value)
	    typeInfo.Static[name] = value
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param key any
	---@param value any
	local function sortMember(typeInfo, key, value)
	    if type(key) == 'string' then
	        local splittedKey = Utils.String.Split(key, '__')
	        if Utils.Table.Contains(splittedKey, 'Static') then
	            isStaticMember(typeInfo, key, value)
	            return
	        end

	        isNormalMember(typeInfo, key, value)
	        return
	    end

	    typeInfo.Members[key] = value
	end

	function MembersHandler.Sort(data, typeInfo)
	    for key, value in pairs(data) do
	        sortMember(typeInfo, key, value)
	    end

	    MembersHandler.UpdateState(typeInfo)
	end

	-------------------------------------------------------------------------------
	-- Extend
	-------------------------------------------------------------------------------

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param name string
	---@param func function
	local function UpdateMethods(typeInfo, name, func)
	    if Utils.Table.ContainsKey(typeInfo.Members, name) then
	        error("trying to extend already existing meta method: " .. name)
	    end

	    InstanceHandler.UpdateMetaMethod(typeInfo, name, func)
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param key any
	---@param value any
	local function UpdateMember(typeInfo, key, value)
	    if Utils.Table.ContainsKey(typeInfo.Members, key) then
	        error("trying to extend already existing member: " .. tostring(key))
	    end

	    InstanceHandler.UpdateMember(typeInfo, key, value)
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param name string
	---@param value any
	local function extendIsStaticMember(typeInfo, name, value)
	    if Utils.Table.ContainsKey(typeInfo.Static, name) then
	        error("trying to extend already existing static member: " .. name)
	    end

	    typeInfo.Static[name] = value
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param name string
	---@param func function
	local function extendIsNormalFunction(typeInfo, name, func)
	    if Utils.Table.ContainsKey(Config.AllMetaMethods, name) then
	        UpdateMethods(typeInfo, name, func)
	    end

	    UpdateMember(typeInfo, name, func)
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param name string
	---@param value any
	local function extendIsNormalMember(typeInfo, name, value)
	    if type(value) == 'function' then
	        extendIsNormalFunction(typeInfo, name, value)
	        return
	    end

	    UpdateMember(typeInfo, name, value)
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param key any
	---@param value any
	local function extendMember(typeInfo, key, value)
	    if type(key) == 'string' then
	        local splittedKey = Utils.String.Split(key, '__')
	        if Utils.Table.Contains(splittedKey, 'Static') then
	            extendIsStaticMember(typeInfo, key, value)
	            return
	        end

	        extendIsNormalMember(typeInfo, key, value)
	        return
	    end

	    if not Utils.Table.ContainsKey(typeInfo.Members, key) then
	        typeInfo.Members[key] = value
	    end
	end

	---@param data table
	---@param typeInfo Freemaker.ClassSystem.Type
	function MembersHandler.Extend(typeInfo, data)
	    for key, value in pairs(data) do
	        extendMember(typeInfo, key, value)
	    end

	    MembersHandler.UpdateState(typeInfo)
	end

	-------------------------------------------------------------------------------
	-- Check
	-------------------------------------------------------------------------------

	---@private
	---@param baseInfo Freemaker.ClassSystem.Type
	---@param member string
	---@return boolean
	function MembersHandler.CheckForMetaMethod(baseInfo, member)
	    if Utils.Table.ContainsKey(baseInfo.MetaMethods, member) then
	        return true
	    end

	    if baseInfo.Base then
	        return MembersHandler.CheckForMetaMethod(baseInfo.Base, member)
	    end

	    return false
	end

	---@private
	---@param typeInfo Freemaker.ClassSystem.Type
	---@param member string
	---@return boolean
	function MembersHandler.CheckForMember(typeInfo, member)
	    if Utils.Table.ContainsKey(typeInfo.Members, member)
	        and typeInfo.Members[member] ~= Config.AbstractPlaceholder
	        and typeInfo.Members[member] ~= Config.InterfacePlaceholder then
	        return true
	    end

	    if typeInfo.Base then
	        return MembersHandler.CheckForMember(typeInfo.Base, member)
	    end

	    return false
	end

	---@private
	---@param typeInfo Freemaker.ClassSystem.Type
	---@param typeInfoToCheck Freemaker.ClassSystem.Type
	function MembersHandler.CheckAbstract(typeInfo, typeInfoToCheck)
	    for key, value in pairs(typeInfo.MetaMethods) do
	        if value == Config.AbstractPlaceholder then
	            if not MembersHandler.CheckForMetaMethod(typeInfoToCheck, key) then
	                error(
	                    typeInfoToCheck.Name
	                    .. " does not implement inherited abstract meta method: "
	                    .. typeInfo.Name .. "." .. tostring(key)
	                )
	            end
	        end
	    end

	    for key, value in pairs(typeInfo.Members) do
	        if value == Config.AbstractPlaceholder then
	            if not MembersHandler.CheckForMember(typeInfoToCheck, key) then
	                error(
	                    typeInfoToCheck.Name
	                    .. " does not implement inherited abstract member: "
	                    .. typeInfo.Name .. "." .. tostring(key)
	                )
	            end
	        end
	    end

	    if typeInfo.Base and typeInfo.Base.Options.IsAbstract then
	        MembersHandler.CheckAbstract(typeInfo.Base, typeInfoToCheck)
	    end
	end

	---@private
	---@param typeInfo Freemaker.ClassSystem.Type
	---@param typeInfoToCheck Freemaker.ClassSystem.Type
	function MembersHandler.CheckInterfaces(typeInfo, typeInfoToCheck)
	    for _, interface in pairs(typeInfo.Interfaces) do
	        for key, value in pairs(interface.MetaMethods) do
	            if value == Config.InterfacePlaceholder then
	                if not MembersHandler.CheckForMetaMethod(typeInfoToCheck, key) then
	                    error(
	                        typeInfoToCheck.Name
	                        .. " does not implement inherited interface meta method: "
	                        .. interface.Name .. "." .. tostring(key)
	                    )
	                end
	            end
	        end

	        for key, value in pairs(interface.Members) do
	            if value == Config.InterfacePlaceholder then
	                if not MembersHandler.CheckForMember(typeInfoToCheck, key) then
	                    error(
	                        typeInfoToCheck.Name
	                        .. " does not implement inherited interface member: "
	                        .. interface.Name .. "." .. tostring(key)
	                    )
	                end
	            end
	        end
	    end

	    if typeInfo.Base then
	        MembersHandler.CheckInterfaces(typeInfo.Base, typeInfoToCheck)
	    end
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	function MembersHandler.Check(typeInfo)
	    if not typeInfo.Options.IsAbstract then
	        if Utils.Table.Contains(typeInfo.MetaMethods, Config.AbstractPlaceholder) then
	            error(typeInfo.Name .. " has abstract meta method/s but is not marked as abstract")
	        end

	        if Utils.Table.Contains(typeInfo.Members, Config.AbstractPlaceholder) then
	            error(typeInfo.Name .. " has abstract member/s but is not marked as abstract")
	        end
	    end

	    if not typeInfo.Options.IsInterface then
	        if Utils.Table.Contains(typeInfo.Members, Config.InterfacePlaceholder) then
	            error(typeInfo.Name .. " has interface meta methods/s but is not marked as interface")
	        end

	        if Utils.Table.Contains(typeInfo.Members, Config.InterfacePlaceholder) then
	            error(typeInfo.Name .. " has interface member/s but is not marked as interface")
	        end
	    end

	    if not typeInfo.Options.IsAbstract and not typeInfo.Options.IsInterface then
	        MembersHandler.CheckInterfaces(typeInfo, typeInfo)

	        if typeInfo.Base and typeInfo.Base.Options.IsAbstract then
	            MembersHandler.CheckAbstract(typeInfo.Base, typeInfo)
	        end
	    end
	end

	return MembersHandler

end

__fileFuncs__["src.Metatable"] = function()
	local Utils = __loadFile__("tools.Freemaker.bin.utils")

	local Config = __loadFile__("src.Config")

	local MembersHandler = __loadFile__("src.Members")

	---@class Freemaker.ClassSystem.MetatableHandler
	local MetatableHandler = {}

	---@param typeInfo Freemaker.ClassSystem.Type
	---@return Freemaker.ClassSystem.BlueprintMetatable metatable
	function MetatableHandler.CreateTemplateMetatable(typeInfo)
	    ---@type Freemaker.ClassSystem.BlueprintMetatable
	    local metatable = { Type = typeInfo }

	    metatable.__index = MembersHandler.TemplateIndex(typeInfo)
	    metatable.__newindex = MembersHandler.TemplateNewIndex(typeInfo)

	    for key in pairs(Config.BlockMetaMethodsOnBlueprint) do
	        local function blockMetaMethod()
	            error("cannot use meta method: " .. key .. " on a template from a class")
	        end
	        ---@diagnostic disable-next-line: assign-type-mismatch
	        metatable[key] = blockMetaMethod
	    end

	    metatable.__tostring = function()
	        return typeInfo.Name .. ".__Blueprint__"
	    end

	    return metatable
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param instance Freemaker.ClassSystem.Instance
	---@param metatable Freemaker.ClassSystem.Metatable
	function MetatableHandler.Create(typeInfo, instance, metatable)
	    metatable.Type = typeInfo

	    metatable.__index = MembersHandler.InstanceIndex(instance, typeInfo)
	    metatable.__newindex = MembersHandler.InstanceNewIndex(instance, typeInfo)

	    for key, _ in pairs(Config.BlockMetaMethodsOnInstance) do
	        if not Utils.Table.ContainsKey(typeInfo.MetaMethods, key) then
	            local function blockMetaMethod()
	                error("cannot use meta method: " .. key .. " on class: " .. typeInfo.Name)
	            end
	            metatable[key] = blockMetaMethod
	        end
	    end
	end

	return MetatableHandler

end

__fileFuncs__["src.Construction"] = function()
	local Utils = __loadFile__("tools.Freemaker.bin.utils")

	local Config = __loadFile__("src.Config")

	local InstanceHandler = __loadFile__("src.Instance")
	local MetatableHandler = __loadFile__("src.Metatable")

	---@class Freemaker.ClassSystem.ConstructionHandler
	local ConstructionHandler = {}

	---@param obj object
	---@return Freemaker.ClassSystem.Instance instance
	local function construct(obj, ...)
	    ---@type Freemaker.ClassSystem.Metatable
	    local metatable = getmetatable(obj)
	    local typeInfo = metatable.Type

	    if typeInfo.Options.IsAbstract then
	        error("cannot construct abstract class: " .. typeInfo.Name)
	    end
	    if typeInfo.Options.IsInterface then
	        error("cannot construct interface class: " .. typeInfo.Name)
	    end

	    if typeInfo.HasPreConstructor then
	        local result = typeInfo.MetaMethods.__preinit(...)
	        if result ~= nil then
	            return result
	        end
	    end

	    local classInstance, classMetatable = {}, {}
	    ---@cast classInstance Freemaker.ClassSystem.Instance
	    ---@cast classMetatable Freemaker.ClassSystem.Metatable
	    classMetatable.Instance = classInstance
	    local instance = setmetatable({}, classMetatable)

	    InstanceHandler.Initialize(classInstance)
	    MetatableHandler.Create(typeInfo, classInstance, classMetatable)
	    ConstructionHandler.Construct(typeInfo, instance, classInstance, classMetatable, ...)

	    InstanceHandler.Add(typeInfo, instance)

	    return instance
	end

	---@param data table
	---@param typeInfo Freemaker.ClassSystem.Type
	function ConstructionHandler.CreateTemplate(data, typeInfo)
	    local metatable = MetatableHandler.CreateTemplateMetatable(typeInfo)
	    metatable.__call = construct

	    setmetatable(data, metatable)

	    if not typeInfo.Options.IsAbstract and not typeInfo.Options.IsInterface then
	        typeInfo.Blueprint = data
	    end
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param class table
	local function invokeDeconstructor(typeInfo, class)
	    if typeInfo.HasClose then
	        typeInfo.MetaMethods.__close(class, Config.Deconstructing)
	    end
	    if typeInfo.HasDeconstructor then
	        typeInfo.MetaMethods.__gc(class)

	        if typeInfo.Base then
	            invokeDeconstructor(typeInfo.Base, class)
	        end
	    end
	end

	---@param typeInfo Freemaker.ClassSystem.Type
	---@param obj object
	---@param instance Freemaker.ClassSystem.Instance
	---@param metatable Freemaker.ClassSystem.Metatable
	---@param ... any
	function ConstructionHandler.Construct(typeInfo, obj, instance, metatable, ...)
	    ---@type function
	    local super = nil

	    local function constructMembers()
	        for key, value in pairs(typeInfo.MetaMethods) do
	            if not Utils.Table.ContainsKey(Config.IndirectMetaMethods, key) and not Utils.Table.ContainsKey(metatable, key) then
	                metatable[key] = value
	            end
	        end

	        for key, value in pairs(typeInfo.Members) do
	            if obj[key] == nil then
	                rawset(obj, key, Utils.Value.Copy(value))
	            end
	        end

	        for _, interface in pairs(typeInfo.Interfaces) do
	            for key, value in pairs(interface.MetaMethods) do
	                if not Utils.Table.ContainsKey(Config.IndirectMetaMethods, key) and not Utils.Table.ContainsKey(metatable, key) then
	                    metatable[key] = value
	                end
	            end

	            for key, value in pairs(interface.Members) do
	                if not Utils.Table.ContainsKey(obj, key) then
	                    obj[key] = value
	                end
	            end
	        end

	        metatable.__gc = function(class)
	            invokeDeconstructor(typeInfo, class)
	        end

	        setmetatable(obj, metatable)
	    end

	    if typeInfo.Base then
	        if typeInfo.Base.HasConstructor then
	            function super(...)
	                constructMembers()
	                ConstructionHandler.Construct(typeInfo.Base, obj, instance, metatable, ...)
	                return obj
	            end
	        else
	            constructMembers()
	            ConstructionHandler.Construct(typeInfo.Base, obj, instance, metatable)
	        end
	    else
	        constructMembers()
	    end

	    if typeInfo.HasConstructor then
	        if super then
	            typeInfo.MetaMethods.__init(obj, super, ...)
	        else
	            typeInfo.MetaMethods.__init(obj, ...)
	        end
	    end

	    instance.IsConstructed = true
	end

	---@param obj object
	---@param metatable Freemaker.ClassSystem.Metatable
	---@param typeInfo Freemaker.ClassSystem.Type
	function ConstructionHandler.Deconstruct(obj, metatable, typeInfo)
	    InstanceHandler.Remove(typeInfo, obj)
	    invokeDeconstructor(typeInfo, obj)

	    Utils.Table.Clear(obj)
	    Utils.Table.Clear(metatable)

	    local function blockedNewIndex()
	        error("cannot assign values to deconstruct class: " .. typeInfo.Name, 2)
	    end
	    metatable.__newindex = blockedNewIndex

	    local function blockedIndex()
	        error("cannot get values from deconstruct class: " .. typeInfo.Name, 2)
	    end
	    metatable.__index = blockedIndex

	    setmetatable(obj, metatable)
	end

	return ConstructionHandler

end

__fileFuncs__["__main__"] = function()
	-- required at top to be at the top of the bundled file
	local Configs = __loadFile__("src.Config")

	-- to package meta in the bundled file
	__loadFile__("src.Meta")

	local Utils = __loadFile__("tools.Freemaker.bin.utils")

	local Class = __loadFile__("src.Class")
	local ObjectType = __loadFile__("src.Object")
	local TypeHandler = __loadFile__("src.Type")
	local MembersHandler = __loadFile__("src.Members")
	local ConstructionHandler = __loadFile__("src.Construction")

	---@class Freemaker.ClassSystem
	local ClassSystem = {}

	ClassSystem.Deconstructing = Configs.Deconstructing
	ClassSystem.IsAbstract = Configs.AbstractPlaceholder
	ClassSystem.IsInterface = Configs.InterfacePlaceholder --//TODO: how to find better name

	ClassSystem.ObjectType = ObjectType

	ClassSystem.Typeof = Class.Typeof
	ClassSystem.Nameof = Class.Nameof
	ClassSystem.GetInstanceData = Class.GetInstanceData
	ClassSystem.IsClass = Class.IsClass
	ClassSystem.HasBase = Class.HasBase
	ClassSystem.HasInterface = Class.HasInterface

	---@param options Freemaker.ClassSystem.Create.Options
	---@return Freemaker.ClassSystem.Type | nil base, table<Freemaker.ClassSystem.Type> interfaces
	local function processOptions(options)
	    options.IsAbstract = options.IsAbstract or false
	    options.IsInterface = options.IsInterface or false

	    if options.IsAbstract and options.IsInterface then
	        error("cannot mark class as interface and abstract class")
	    end

	    if options.Inherit then
	        if ClassSystem.IsClass(options.Inherit) then
	            options.Inherit = { options.Inherit }
	        end
	    else
	        -- could also return here
	        options.Inherit = {}
	    end

	    ---@type Freemaker.ClassSystem.Type, table<Freemaker.ClassSystem.Type>
	    local base, interfaces = nil, {}
	    for i, parent in ipairs(options.Inherit) do
	        local parentType = ClassSystem.Typeof(parent)
	        ---@cast parentType Freemaker.ClassSystem.Type

	        if options.IsAbstract and (not parentType.Options.IsAbstract and not parentType.Options.IsInterface) then
	            error("cannot inherit from not abstract class: ".. tostring(parent) .." in abstract class: " .. options.Name)
	        end

	        if parentType.Options.IsInterface then
	            interfaces[i] = ClassSystem.Typeof(parent)
	        else
	            if base ~= nil then
	                error("cannot inherit from more than one (abstract) class: " .. tostring(parent) .. " in class: " .. options.Name)
	            end

	            base = parentType
	        end
	    end

	    if not options.IsInterface and not base then
	        base = ObjectType
	    end

	    return base, interfaces
	end

	---@generic TClass
	---@param data TClass
	---@param options Freemaker.ClassSystem.Create.Options
	---@return TClass
	function ClassSystem.Create(data, options)
	    options = options or {}
	    local base, interfaces = processOptions(options)

	    local typeInfo = TypeHandler.Create(base, interfaces, options)

	    MembersHandler.Sort(data, typeInfo)
	    MembersHandler.Check(typeInfo)

	    Utils.Table.Clear(data)

	    ConstructionHandler.CreateTemplate(data, typeInfo)

	    return data
	end

	---@generic TClass
	---@param class TClass
	---@param extensions TClass
	---@return TClass
	function ClassSystem.Extend(class, extensions)
	    if not ClassSystem.IsClass(class) then
	        error("provided class is not an class")
	    end

	    ---@type Freemaker.ClassSystem.Metatable
	    local metatable = getmetatable(class)
	    local typeInfo = metatable.Type

	    MembersHandler.Extend(typeInfo, extensions)

	    return class
	end

	---@param obj object
	function ClassSystem.Deconstruct(obj)
	    ---@type Freemaker.ClassSystem.Metatable
	    local metatable = getmetatable(obj)
	    local typeInfo = metatable.Type

	    ConstructionHandler.Deconstruct(obj, metatable, typeInfo)
	end

	---@generic TClass : object
	---@param name string
	---@param table TClass
	---@param options Freemaker.ClassSystem.Create.Options | nil
	---@return TClass
	function class(name, table, options)
	    options = options or {}
	    ---@cast options Freemaker.ClassSystem.Create.Options
	    options.Name = name

	    return ClassSystem.Create(table, options)
	end

	---@generic TInterface
	---@param name string
	---@param table TInterface
	---@param options Freemaker.ClassSystem.Create.Options | nil
	---@return TInterface
	function interface(name, table, options)
	    options = options or {}
	    ---@cast options Freemaker.ClassSystem.Create.Options
	    options.Name = name
	    options.IsInterface = true

	    return ClassSystem.Create(table, options)
	end

	typeof = ClassSystem.Typeof
	nameof = ClassSystem.Nameof

	return ClassSystem

end

return __fileFuncs__["__main__"]()
