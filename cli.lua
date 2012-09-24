local PI = select(2, ...)

SLASH_PI1 = '/pi'
function SlashCmdList.PI( msg, editbox )

  -- no args
  if msg == "" then
    print("PI (Perfect Interrupt)")
  else

    -- resizing/moving
    if msg == "move" or msg == "resize" then
      PI.blocker:toggle_movable()
    end

    -- cast
    if string.find(msg, "cast") then
      local unit, spell = strsplit(" ", string.gsub(msg, "cast ", ""), 2)
      PI.blocker:pass_on_cast(unit, spell)
    end

    -- auras
    if string.find(msg, "aura") then
      local unit, spell, filter = strsplit(" ", string.gsub(msg, "aura ", ""), 3)
      PI.blocker:pass_on_aura(unit, spell, filter)
    end
  end
end