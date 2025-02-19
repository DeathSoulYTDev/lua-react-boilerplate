RegisterCommand("ui", function()
  SetNuiFocus(true, true) -- allows mouse and keyboard input in the UI
  local randomNumber = math.random(1,99)
  SendReactMessage('openBox', {randomNumber})
end)
