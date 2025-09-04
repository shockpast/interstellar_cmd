local util = require("util")

---@class memory
memory = memory
---@class os
os = os

--
local kernel32 = memory.module("kernel32.dll")
local load_library = memory.fetch(kernel32, "LoadLibraryA")
local get_last_error = memory.fetch(kernel32, "GetLastError")

memory.subroutine.emit(load_library, util.memory.write_string("user32.dll"))

local user32 = memory.module("user32.dll")
local find_window = memory.fetch(user32, "FindWindowA")
local send_message = memory.fetch(user32, "SendMessageA")

---
local valve_001 = memory.subroutine.emit(find_window, util.memory.write_string("Valve001"), memory.address(0x0))
if valve_001.raw == 0 then return end

local command = table.concat(os.argv.positional(), " ", 2)
local ok = memory.subroutine.emit(send_message, valve_001, memory.address(0x004A), memory.address(0x0), util.copydata(command))
if ok.raw == 0 then
    local error_code = memory.subroutine.emit(get_last_error)

    print("[ - ] send_message failed")
    print("[ - ] error: " .. string.format("0x%x", error_code.raw))
else
    print("[ + ] " .. command)
end