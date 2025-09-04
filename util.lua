local util = {}

function util.copydata(message)
    -- 16 on x32, 24 on x64
    local size = 24
    local ptr = memory.allocate(size)

    local message_ptr = memory.allocate(#message + 1)
    memory.write.string(message_ptr, message)

    memory.write.uint64(ptr, 0x0) -- dwData
    memory.write.uint64(memory.address(ptr.raw + size / 3), #message + 1) -- cbData
    memory.write.uint64(memory.address(ptr.raw + size / 1.5), message_ptr.raw) -- lpData

    return ptr
end

util.memory = {}
function util.memory.write_string(str)
    local ptr = memory.allocate(#str + 1)
    memory.write.string(ptr, str)

    return ptr
end

return util