local PI = select(2, ...)

-- ## Implementation

-- The frame that sits over action buttons and prevents clicking until
-- conditions are met.
local blocker = CreateFrame("Frame", "PIBlocker", UIParent)
blocker:SetFrameStrata("TOOLTIP")

-- Default position and size
blocker:SetPoint("BOTTOM", 0, 50)
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

-- ### `blocker:detect_casts( string, string )
-- Set clickablitliy based on spell cast
function blocker:pass_on_casts( unit, force )
  PI:detect_casts(unit, force, function()
    self:pass()
  end, function()
    self:block()
  end)
end

-- ### `blocker:detect_cast( string, string )
-- Set clickablitliy based on spell cast
function blocker:pass_on_cast( unit, spell )
  PI:detect_cast(unit, spell, function()
    self:pass()
  end, function()
    self:block()
  end)
end

-- ### `blocker:detect_aura( string, string, string )
-- Set clickablitliy based on spell aura
function blocker:pass_on_aura( unit, spell, filter )
  PI:detect_aura(unit, spell, filter, function()
    self:pass()
  end, function()
    self:block()
  end)
end