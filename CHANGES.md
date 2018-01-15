## 1.6.3

- Updated README.md and relase information

## 1.6.2

- Fixes TriggerMap for Haxe 3.2.1+
- Fixed enum bug where an enum trigger would not fire the command, added support for Int triggers
- Added unit test for unsupported type and added missing unmap call

## 1.6.1

- Type fix for Haxe 3.0.0

## 1.6.0

- Fixes #17: adds TriggerMap to allow mapping of TriggeredCommands to various types

## 1.5.0

- Added hamcrest dependency
- - Use 'remove' instead of 'delete' on maps (as delete is reserved on some platforms and messes with optimization in closure) - Code style.
- Add dce support using @:keep metadata where appropriate - Remove support for haxe < 2.x - General code cleanup - Upgrade minject dependency
