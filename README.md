# PI = Perfect Interrupts

Never miss that critical interrupt or purge again. Blocks clicks until desired action.

### Current Development Config
`PI/core.lua`  
at the bottom add one of the following to your need.

* `detect_cast(unit, spell)`
* `detect_casts(unit, force)`
* `detect_aura(unit, spell, filter)`

Example:
    
    pass_on_cast('target', 'Hurricane')