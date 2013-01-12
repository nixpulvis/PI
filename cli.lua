local PI = select(2, ...)

local function print_help()
  print("PI - Perfect Interrupt (Vox Protectors)")
  print("    help  : Display this message.")
  print("    move : Toggle moving the blocker frame.")
  print(" ")
  print("made with love by Nathan Lilienthal (Epicgrim)")
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

  end
end