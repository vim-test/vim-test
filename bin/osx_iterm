#!/usr/bin/osascript

on run argv
  tell application "iTerm2"
    set _window to (current window)
    if _window is equal to missing value then
      create window with default profile
    end if
    tell current window
      tell current session
        write text (item 1 of argv)
      end tell
    end tell
  end tell

  tell application "MacVim"
    activate
  end tell
end run
