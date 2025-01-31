---@class lua-cmake.utils.stopwatch : object
---@field m_start number
---@field m_end number
---@field m_diff number
---@overload fun() : lua-cmake.utils.stopwatch
local stopwatch = {}

function stopwatch:start()
    self.m_start = os.clock()
end

function stopwatch:stop()
    self.m_end = os.clock()
end

---@private
---@return number
function stopwatch:get_diff()
    if self.m_diff then
        return self.m_diff
    end

    self.m_diff = self.m_end - self.m_start
    return self.m_diff
end

---@return number
function stopwatch:get_time_seconds()
    return self:get_diff()
end

---@return string
function stopwatch:get_pretty_seconds()
    ---@type number | string
    local time = math.floor(self:get_time_milliseconds() / 10) / 10
    if time < 0.1 then
        return "<0.1"
    end

    return tostring(time)
end

---@return number
function stopwatch:get_time_milliseconds()
    return self:get_diff() * 1000
end

---@return string
function stopwatch:get_pretty_milliseconds()
    ---@type number | string
    local time = math.floor(self:get_time_milliseconds() * 10) / 10
    if time < 0.1 then
        return "<0.1"
    end

    return tostring(time)
end

return class("lua-cmake.utils.stopwatch", stopwatch)
