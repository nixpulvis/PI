-- ### For Development Only ### ---
SLASH_RELOAD1 = '/rl'
function SlashCmdList.RELOAD( msg, editbox )
  ReloadUI()
end

-- ## Helper Functions

local function has_aura( unit, spell, filter )
  i = 1
  repeat
    name = UnitAura(unit, i, filter)
    -- check for the spell.
    if name == spell then
      return true
    end
    i = i + 1
  until name == nil

  -- If we get here the spell does not exist.
  return false
end

-- ## Detection

-- Frame to handle all events.
local event_handler = CreateFrame("Frame", nil, UIParent)

-- ### `watch for cast`
-- Trigger activation callback function when given spell cast is started by 
-- given unit, then call rollback function when spell is stopped being 
-- casted by given unit.
local function watch_for_cast( unit, spell, activation, rollback )

  -- Watch for spell casts from unit.
  event_handler:RegisterEvent("UNIT_SPELLCAST_START")
  event_handler:RegisterEvent("UNIT_SPELLCAST_STOP")
  event_handler:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
  event_handler:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")

  -- Activation condition.
  event_handler:HookScript("OnEvent", function( self, event, ... )
    if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
      local cast_unit, cast_spell = ...
      if cast_unit == unit and cast_spell == spell then
        activation()
      end
    end
  end)

  -- Rollback condition.
  event_handler:HookScript("OnEvent", function( self, event, ... )
    if event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" then
      local cast_unit, cast_spell = ...
      if cast_unit == unit and cast_spell == spell then
        rollback()
      end
    end
  end)
end

local function watch_for_aura( unit, spell, filter, activation, rollback )
  
  -- Watch for auras on unit.
  event_handler:RegisterEvent("UNIT_AURA")

  event_handler:HookScript("OnEvent", function( self, event, ... )
    if event == "UNIT_AURA" then
      local aura_unit = ...
      if aura_unit == unit then

        if has_aura(unit, spell, filter) then
          activation()
        else
          rollback()
        end

      end
    end
  end)

end

-- ## Blocker

-- The frame itself.
local blocker = CreateFrame("Frame", "PIBlocker", UIParent)

-- The blocker's looks.
blocker.texture = blocker:CreateTexture(nil, "BACKGROUND")
blocker.texture:SetAllPoints()
blocker.texture:SetTexture(1.0, 0.0, 0.0, 0.5)

-- Intercept Mouse Clicks, preventing any use of spells below the frame.
blocker:EnableMouse(true)

-- Set clickablitliy based on spell cast
function blocker:watch_for_cast( unit, spell )
  watch_for_cast(unit, spell, function()
    self:EnableMouse(false)
  end, function()
    self:EnableMouse(true)
  end)
end

-- Set clickablitliy based on spell aura
function blocker:watch_for_aura( unit, spell, filter )
  watch_for_aura(unit, spell, filter, function()
    self:EnableMouse(false)
    self.texture:SetTexture(0.0, 1.0, 0.0, 0.5)
  end, function()
    self:EnableMouse(true)
    self.texture:SetTexture(1.0, 0.0, 0.0, 0.5)
  end)
end

-- Default Position / Size
blocker:SetPoint("CENTER")
blocker:SetSize(300, 50)


-------------
-- TESTING --
-------------
-- blocker:watch_for_cast("player", "Healing Touch")
blocker:watch_for_aura("target", "Moonfire", "PLAYER|HARMFUL")
blocker:watch_for_aura("target", "Insect Swarm", "PLAYER|HARMFUL")