# PI = Perfect Interrupts

Never miss that critical interrupt or purge again. Blocks clicks until desired action.

### Current Development Config
`PI/core.lua`  
at the bottom add one of the following to your need.

* `watch_for_cast(unit, spell)`
* `watch_for_casts(unit, force)`
* `watch_for_aura(unit, spell, filter)`

Example:
    
    watch_for_cast('target', 'Hurricane')