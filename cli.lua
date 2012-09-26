local PI = select(2, ...)

SLASH_PI1 = '/pi'
function SlashCmdList.PI( msg, editbox )

  -- no args
  if msg == "" then
    print("PI (Perfect Interrupt)")
  else

    -- ### `/pi move` or `/pi resize`
    if msg == "move" or msg == "resize" then
      print("moving")
      PI.blocker:toggle_movable()
    end

    -- ### `/pi cast _player_ _spell_`
    if string.find(msg, "cast") then
      local unit, spell = strsplit(" ", string.gsub(msg, "cast ", ""), 2)
      PI.blocker:pass_on_cast(unit, spell)
    end

    -- ### `/pi aura _player_ _spell_ _filter_`
    if string.find(msg, "aura") then
      local unit, spell, filter = strsplit(" ", string.gsub(msg, "aura ", ""), 3)
      PI.blocker:pass_on_aura(unit, spell, filter)
    end

    -- ### `/pi reset`
    if msg == "reset" then
      PI:reset_detection()
    end

  end
end