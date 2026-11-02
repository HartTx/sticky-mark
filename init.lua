-- Digital Post-it flag
-- A colored arrow that floats on top of every window.
--   Drag it with the mouse to place it next to a step.
--   Control + Option + Down / Up : move the flag one step down or up
--   Control + Option + F         : hide the flag, or show it at the mouse pointer
--   Control + Option + C         : change color (pink, blue, yellow, green)

local STEP = 28          -- how far one key press moves the flag, in pixels
local W, H = 70, 28       -- flag size

local COLORS = { "#FF2D95", "#1EB8E0", "#E8F000", "#2ECC40" }
local colorIndex = 1

local screen = hs.screen.mainScreen():frame()
postitFlag = hs.canvas.new({ x = screen.x + screen.w / 2, y = screen.y + 200, w = W, h = H })
postitFlag:level(hs.canvas.windowLevels.overlay)
postitFlag:behavior({ "canJoinAllSpaces", "stationary" })
postitFlag:appendElements({
  type = "segments",
  closed = true,
  action = "fill",
  fillColor = { hex = COLORS[colorIndex], alpha = 0.85 },
  -- Arrow pointing left, like the paper flags
  coordinates = {
    { x = 0, y = H / 2 },
    { x = H / 2, y = 0 },
    { x = W, y = 0 },
    { x = W, y = H },
    { x = H / 2, y = H },
  },
  trackMouseDown = true,
})

-- Drag with the mouse
postitFlag:mouseCallback(function(canvas, message)
  if message ~= "mouseDown" then return end
  local start = hs.mouse.absolutePosition()
  local frame = canvas:frame()
  local dx, dy = start.x - frame.x, start.y - frame.y
  local types = hs.eventtap.event.types
  postitDrag = hs.eventtap.new({ types.leftMouseDragged, types.leftMouseUp }, function(event)
    if event:getType() == types.leftMouseUp then
      postitDrag:stop()
      return false
    end
    local p = hs.mouse.absolutePosition()
    canvas:topLeft({ x = p.x - dx, y = p.y - dy })
    return false
  end)
  postitDrag:start()
end)

local function nudge(dy)
  local f = postitFlag:frame()
  postitFlag:topLeft({ x = f.x, y = f.y + dy })
end

local function toggle()
  if postitFlag:isShowing() then
    postitFlag:hide()
  else
    local p = hs.mouse.absolutePosition()
    postitFlag:topLeft({ x = p.x + 10, y = p.y - H / 2 })
    postitFlag:show()
  end
end

local function nextColor()
  colorIndex = colorIndex % #COLORS + 1
  postitFlag[1].fillColor = { hex = COLORS[colorIndex], alpha = 0.85 }
end

local mods = { "ctrl", "alt" }
hs.hotkey.bind(mods, "down", function() nudge(STEP) end, nil, function() nudge(STEP) end)
hs.hotkey.bind(mods, "up", function() nudge(-STEP) end, nil, function() nudge(-STEP) end)
hs.hotkey.bind(mods, "F", toggle)
hs.hotkey.bind(mods, "C", nextColor)

postitFlag:show()
hs.alert.show("Post-it flag ready")
