local PI = select(2, ...)

-- ## Singleton Blocker

-- The frame that sits over action buttons and prevents clicking until
-- conditions are met.
PI.blocker = CreateFrame("Frame", "PIBlocker", UIParent)

-- ### `toggle_movable()`
-- Toggle the blocks ability to be repositioned.
function PI.blocker:toggle_movable()
  -- don't allow toggle in combat
  if InCombatLockdown() then return end

  if self:IsMovable() then
    self:SetMovable(false)
    self:RegisterForDrag() -- disables mouse event dragging
    self:SetScript("OnDragStart", nil)
    self:SetScript("OnDragStop", nil)
  else
    self:SetMovable(true)
    self:RegisterForDrag("LeftButton")
    self:SetScript("OnDragStart", self.StartMoving)
    self:SetScript("OnDragStop", self.StopMovingOrSizing)
  end
end

-- ### `pass`
-- Allow clicks, and set color to indicate passing condition.
function PI.blocker:pass()
  self:EnableMouse(false)
  self.texture:SetTexture(0.0, 1.0, 0.0, 0.5)
end

-- ### `block`
-- Intercept mouse clicks and set color to indicate no conditions met.
function PI.blocker:block()
  self:EnableMouse(true)
  self.texture:SetTexture(1.0, 0.0, 0.0, 0.5)
end

-- ### `PI.blocker:detect_casts( string, string )
-- Set clickablitliy based on spell cast
function PI.blocker:pass_on_casts( unit, force )
  PI:detect_casts(unit, force, function()
    self:pass()
  end, function()
    self:block()
  end)
end

-- ### `PI.blocker:detect_cast( string, string )
-- Set clickablitliy based on spell cast
function PI.blocker:pass_on_cast( unit, spell )
  PI:detect_cast(unit, spell, function()
    self:pass()
  end, function()
    self:block()
  end)
end

-- ### `PI.blocker:detect_aura( string, string, string )
-- Set clickablitliy based on spell aura
function PI.blocker:pass_on_aura( unit, spell, filter )
  PI:detect_aura(unit, spell, filter, function()
    self:pass()
  end, function()
    self:block()
  end)
end

-- ## Blocker Frame Settings

-- Sit on top of everything.
PI.blocker:SetFrameStrata("TOOLTIP")

-- Default position and size
PI.blocker:SetPoint("CENTER", 0, 0)
PI.blocker:SetSize(50, 50)

-- The blocker's texture.
PI.blocker.texture = PI.blocker:CreateTexture(nil, "BACKGROUND")
PI.blocker.texture:SetAllPoints()

-- Block by default.
PI.blocker:block()