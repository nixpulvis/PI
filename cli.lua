local PI = select(2, ...)

SLASH_PI1 = '/pi'
function SlashCmdList.PI( msg, editbox )

  -- no args
  if msg == "" then
    print("PI (Perfect Interrupt)")
  else

    -- spells
    if string.find(msg, "spell") then
      local unit, spell = strsplit(" ", string.gsub(msg, "spell ", ""), 2)
      PI.blocker:pass_on_cast(unit, spell)
    end

    -- auras
    if string.find(msg, "aura") then
      local unit, spell, filter = strsplit(" ", string.gsub(msg, "aura ", ""), 3)
      PI.blocker:pass_on_aura(unit, spell, filter)
    end
  end
end