local PI = select(2, ...)

-- ## Implementation

-- The frame that sits over action buttons and prevents clicking until
-- conditions are met.
local blocker = CreateFrame("Frame", "PIBlocker", UIParent)

-- Default position and size
blocker:SetPoint("CENTER")
blocker:SetSize(300, 50)

-- The blocker's looks.
blocker.texture = blocker:CreateTexture(nil, "BACKGROUND")
blocker.texture:SetAllPoints()
blocker.texture:SetTexture(1.0, 0.0, 0.0, 0.5)

-- Intercept mouse clicks, preventing any mouse interactions with elements
-- below this frame.
blocker:EnableMouse(true)

-- ### `pass`
-- Allow clicks, and set color to indicate passing condition.
function blocker:pass()
  self:EnableMouse(false)
  self.texture:SetTexture(0.0, 1.0, 0.0, 0.5)
end

-- ### `block`
-- Intercept mouse clicks and set color to indicate no conditions met.
function blocker:block()
  self:EnableMouse(true)
  self.texture:SetTexture(1.0, 0.0, 0.0, 0.5)
end

-- ### `blocker:watch_for_casts( string, string )
-- Set clickablitliy based on spell cast
function blocker:watch_for_casts( unit, force )
  PI:watch_for_casts(unit, force, function()
    self:pass()
  end, function()
    self:block()
  end)
end

-- ### `blocker:watch_for_cast( string, string )
-- Set clickablitliy based on spell cast
function blocker:watch_for_cast( unit, spell )
  PI:watch_for_cast(unit, spell, function()
    self:pass()
  end, function()
    self:block()
  end)
end

-- ### `blocker:watch_for_aura( string, string, string )
-- Set clickablitliy based on spell aura
function blocker:watch_for_aura( unit, spell, filter )
  PI:watch_for_aura(unit, spell, filter, function()
    self:pass()
  end, function()
    self:block()
  end)
end