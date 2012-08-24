-- ### For Development Only ### ---
SLASH_RELOAD1 = '/rl'
function SlashCmdList.RELOAD( msg, editbox )
  ReloadUI()
end

-- ## Helper Functions

-- ### `has_aura( string, string, string )
-- Returns true when the given unit has the given aura. Filter is a string
-- describing attributes of the aura. For a complete list of valid filters
-- look up the documentation of `UnitAura()`.
local function has_aura( unit, spell, filter )
  i = 1 -- spells in WoW are indexed starting at 1
  repeat
    name = UnitAura(unit, i, filter)
    if name == spell then
      return true
    end
    i = i + 1
  until name == nil

  return false  -- spell does not exist.
end

-- ## Detection

-- Single frame to handle all events.
local event_handler = CreateFrame("Frame", nil, UIParent)

-- ### `watch_for_casts( unit )`
-- Trigger callback function when any interruptible cast is started by the
-- given unit. Can be forced to trigger callback even when cast is protected,
-- by setting optional 2nd arg equal to true.
local function watch_for_casts( unit, force, trigger, rollback )

  -- Watch for spell casts from unit.
  event_handler:RegisterEvent("UNIT_SPELLCAST_START")
  event_handler:RegisterEvent("UNIT_SPELLCAST_STOP")
  event_handler:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
  event_handler:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
  event_handler:HookScript("OnEvent", function( self, event, ... )
    local cast_unit = ...
    local interrupt = select(9, UnitCastingInfo(unit))
    
    -- Activation.
    if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
      if cast_unit == unit and (interrupt or force) then
        trigger()
      end
    
    -- Rollback.
    elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" then
      if cast_unit == unit and (interrupt or force) then
        rollback()
      end
    end

  end)
  
end

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
    local cast_unit, cast_spell = ...

    -- Activation.
    if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
      if cast_unit == unit and cast_spell == spell then
        trigger()
      end
    
    -- Rollback.
    elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" then
      if cast_unit == unit and cast_spell == spell then
        rollback()
      end
    end

  end)
end

-- ### `watch_for_auras( string, string, string )
-- Trigger the callback when given unit has any spell matching the given
-- type and filter. The type will be set to auras the player can dispel or
-- purge be default.
local function watch_for_auras( unit, filter, type )
  -- body
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
  watch_for_casts(unit, force, function()
    self:pass()
  end, function()
    self:block()
  end)
end

-- ### `blocker:watch_for_cast( string, string )
-- Set clickablitliy based on spell cast
function blocker:watch_for_cast( unit, spell )
  watch_for_cast(unit, spell, function()
    self:pass()
  end, function()
    self:block()
  end)
end

-- ### `blocker:watch_for_aura( string, string, string )
-- Set clickablitliy based on spell aura
function blocker:watch_for_aura( unit, spell, filter )
  watch_for_aura(unit, spell, filter, function()
    self:pass()
  end, function()
    self:block()
  end)
end