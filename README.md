# scratchpad

Script to
1. unmap/hide windows with bspwm and
2. show dmenu prompt for selecting which one to map/unhide again

## Usage
```
Usage: scratchpad.bash process_name [executable_name] [--take-first]
    process_name       As recognized by 'xdo' command
    executable_name    As used for launching from terminal
    --take-first       In case 'xdo' returns multiple process IDs
    --current          Add the current window to the scratchpad
    --show             Show one of the scratchpad windows
```

### Special scratchpads
If you want to kinda map some special names to e.g. run that command in a shell,
you need to add cases to the switch-case in `scratchpad.bash:67` accordingly
(see `ddcalc` or `yubioath-desktop`).
