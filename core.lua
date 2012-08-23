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

-- ### `watch_for_cast( string, string, function, function )`
-- Trigger callback function when given spell cast is started by 
-- given unit, then call rollback function when spell is stopped being 
-- casted by given unit.
local function watch_for_cast( unit, spell, trigger, rollback )

  -- Watch for spell casts from unit.
  event_handler:RegisterEvent("UNIT_SPELLCAST_START")
  event_handler:RegisterEvent("UNIT_SPELLCAST_STOP")
  event_handler:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
  event_handler:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")

  event_handler:HookScript("OnEvent", function( self, event, ... )

   -- Activation.
   if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
      local cast_unit, cast_spell = ...
      if cast_unit == unit and cast_spell == spell then
        trigger()
      end
    
    -- Rollback.
    elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" then
      local cast_unit, cast_spell = ...
      if cast_unit == unit and cast_spell == spell then
        rollback()
      end
    end

  end)
end

-- ### `watch_for_aura( string, string, string, function, function )`
-- Trigger callback when given unit has the given spell aura.
-- The filter is the same as the input to `UnitAura`, and determines what
-- type of aura to look for on the unit. Rollback callback is called when
-- the unit no longer has the aura.
local function watch_for_aura( unit, spell, filter, trigger, rollback )
  
  -- Watch for auras on unit.
  event_handler:RegisterEvent("UNIT_AURA")

  event_handler:HookScript("OnEvent", function( self, event, ... )
    if event == "UNIT_AURA" then
      local aura_unit = ...
      if aura_unit == unit then

        -- Activation callback when the unit has the aura.
        if has_aura(unit, spell, filter) then
          trigger()

        -- Rollback when the unit no longer has the aura.
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
-- 

-- ### `blocker:watch_for_cast( string, string )
-- Set clickablitliy based on spell cast
function blocker:watch_for_cast( unit, spell )
  watch_for_cast(unit, spell, self:pass, self:block)
end

-- ### `blocker:watch_for_aura( string, string, string )
-- Set clickablitliy based on spell aura
function blocker:watch_for_aura( unit, spell, filter )
  watch_for_aura(unit, spell, filter, self:pass, self:block)
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