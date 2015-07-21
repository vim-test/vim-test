#!/usr/bin/osascript

on run argv
  tell application "iTerm"
    if (count of terminals) = 0 then
      set _terminal to (make new terminal)
    else
      set _terminal to current terminal
    end if

    activate

    tell _terminal
      tell the current session
        write text (item 1 of argv)
      end tell
    end tell
  end tell

  delay 0.02

  tell application "MacVim"
    activate
  end tell
end run
