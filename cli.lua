local PI = select(2, ...)

local function print_help()
  print("PI (perfect interrupt)")
  print("  help : Display this message.")
  print("  move : Toggle moving the blocker frame.")
  print("  cast [SPELL] : Watch for given spellcast.")
  print("  aura [SPELL] : Watch for given aura.")
  print("  reset : Reset PI's watching.")
  print(" ")
  print("  made with love by Nathan Lilienthal (Epicgrim)")
end

SLASH_PI1 = '/pi'
function SlashCmdList.PI( msg, editbox )

  -- no args
  if msg == "" then
    print_help()
  else

    -- ### `/pi move`
    if msg == "move" then
      if PI.blocker:IsMovable() then
        print("PI is now locked")
      else
        print("PI is now movable")
      end
      PI.blocker:toggle_movable()
    end

    -- ### `/pi cast _player_ _spell_`
    if string.find(msg, "cast") then
      local unit, spell = strsplit(" ", string.gsub(msg, "cast ", ""), 2)
      print("PI is now watching "..unit.." for "..spell)
      PI.blocker:pass_on_cast(unit, spell)
    end

    -- ### `/pi aura _player_ _spell_ _filter_`
    if string.find(msg, "aura") then
      local unit, spell, filter = strsplit(" ", string.gsub(msg, "aura ", ""), 3)
      print("PI is now watching "..unit.." for "..spell.."["..filter.."]")
      PI.blocker:pass_on_aura(unit, spell, filter)
    end

    -- ### `/pi reset`
    if msg == "reset" then
      print("PI is not watching anything now")
      PI:reset_detection()
    end

  end
end