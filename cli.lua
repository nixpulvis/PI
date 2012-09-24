local PI = select(2, ...)

SLASH_PI1 = '/pi'
function SlashCmdList.PI( msg, editbox )
  if msg == "" then
    print("PI (Perfect Interrupt)")
  else
    if msg == "create" then
      PI.blocker:SetPoint("BOTTOM", 0, 50)
      PI.blocker:SetSize(300, 50)
    end

    if string.find(msg, "spell") then
      spell = string.gsub(msg, "spell ", "")
      PI.blocker:pass_on_cast( 'player', spell )
    end
  end
end