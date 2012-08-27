local PI = select(2, ...)

-- ## Helper Functions

-- ### `has_aura( string, string, string )
-- Returns true when the given unit has the given aura. Filter is a string
-- describing attributes of the aura. For a complete list of valid filters
-- look up the documentation of `UnitAura()`.
function PI:has_aura( unit, spell, filter )
  i = 1 -- spells in WoW are indexed starting at 1
  repeat
    name = UnitAura(unit, i, filter)
    if name == spell then
      return true
    end
    i = i + 1
  until name == nil

  return false  -- unit doesn't have spell on it
end