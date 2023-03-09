# 3D-Menu-Cam
3D Camera specifically for Godot 4 Menus. Idle-Wiggle, screenshake, controller-rstick-motion etc.

## How to use
Grab the main_cam.tscn and .gd from the repo and put it in your scenes. The scene has a `get_cam()` function in case you need to make edits to the actual `Camera3D` Node. Other than that, call `set_go_to()` to move the cam to a given `Node3D` or call `set_look_at()` to make the cam point at a given `Node3D`.

### Other features
* Idle-Wiggle: The cam slightly moves around based on noise. This makes it look more natural, as if the cam is held by someone, who is slightly moving and breathing. 
* Screenshake: Call `screenshake` and pass `intensity`, `frequency` and `duration` as arguments. By default, the intensity decreases over time.
* RStick Motion: The cam can be moved around using the right stick of a Gamepad within constraints. That way the player can look around a little.
