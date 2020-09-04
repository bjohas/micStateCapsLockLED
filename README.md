# micsStateCapLockLED

With long video conference calls, I use the hardware mute button on my Lenovo 520 (Ubuntu 20.04).

This script picks up the "mic mute/unmute" via dbus, and then turns the CapsLock LED light on ("on air") or off ("off air"). This way you always know whether you mic is on or off, and you can be a gooz video conference call citizen.

This script may not work on other hardware.

The script calls itself - that appeared to be necessary to properly handle the fact that dbus-monitor has to run without sudo, but the LED state can only be changed with sudo. If somebody has a simpler solution, let me know.
