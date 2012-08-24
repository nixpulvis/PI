local PI = select(2, ...)

-- ## Detection

-- Single frame to handle all events.
local event_handler = CreateFrame("Frame", nil, UIParent)

-- ### `watch_for_casts( unit )`
-- Trigger callback function when any interruptible cast is started by the
-- given unit. Can be forced to trigger callback even when cast is protected,
-- by setting optional 2nd arg equal to true.
function PI:watch_for_casts( unit, force, trigger, rollback )

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
function PI:watch_for_cast( unit, spell, trigger, rollback )

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
function PI:watch_for_auras( unit, filter, type )
  -- body
end

-- ### `watch_for_aura( string, string, string, function, function )`
-- Trigger callback when given unit has the given spell aura.
-- The filter is the same as the input to `UnitAura`, and determines what
-- type of aura to look for on the unit. Rollback callback is called when
-- the unit no longer has the aura.
function PI:watch_for_aura( unit, spell, filter, trigger, rollback )
  
  -- Watch for auras on unit.
  event_handler:RegisterEvent("UNIT_AURA")
  event_handler:HookScript("OnEvent", function( self, event, ... )
    if event == "UNIT_AURA" then
      local aura_unit = ...
      if aura_unit == unit then

        -- Activation callback when the unit has the aura.
        if PI:has_aura(unit, spell, filter) then
          trigger()

        -- Rollback when the unit no longer has the aura.
        else
          rollback()
        end

      end
    end
  end)

end