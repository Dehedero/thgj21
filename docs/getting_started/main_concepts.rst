Main concepts
=============

GOAT is a plugin for Godot Engine that provides a foundation for creating
3D, first-person, single-player adventure games. This section provides a
general overview of the template's core concepts.

GOAT's primary features are delivered through:

-  **Global Scripts (Singletons):** A set of autoloaded scripts like ``goat``,
   ``goat_inventory``, and ``goat_state`` that manage the game's core logic.
   You can access them from anywhere in your code.
-  **Ready-to-use Scenes:** Pre-made scenes for common adventure game elements.
   The three main scenes you will use are located in ``addons/goat/main_scenes/``:
   -  ``Player.tscn``
   -  ``InteractiveItem.tscn``
   -  ``InteractiveScreen.tscn``

Game Modes
----------

The template uses a system of game modes, managed by the ``goat`` global script.
The current mode is stored in the ``goat.game_mode`` variable. There are 6 modes
available:

-  ``NONE``: The game hasn't started yet (default).
-  ``EXPLORING``: The player is moving and interacting with the 3D environment.
-  ``DETAILED_INTERACTION``: The player is closely examining an object.
-  ``INVENTORY``: The player is browsing 3D items in the inventory.
-  ``CONTEXT_INVENTORY``: The player is trying to use an inventory item
   on an environment object (e.g., using a key on a door).
-  ``SETTINGS``: The settings screen is shown.

**Note: The game does not pause in any of these modes.**

Core Principles
---------------

-  **Interaction:** The player explores a 3D environment and interacts with
   objects. Special interactions can add items to an inventory.
-  **Inventory:** The inventory holds 3D items that can be rotated and
   interacted with, both with each other and with objects in the environment.
-  **Signals:** GOAT uses signals extensively to allow different parts of your
   game to communicate without being tightly coupled. For example, the
   ``goat_interaction`` singleton emits signals when an object is activated.
-  **Configuration:** To add new inventory items or voice recordings, you will
   need to provide configuration files and assets in your own game directory,
   not inside the ``addons/goat`` folder.

GOAT provides default UI styles and layouts for the inventory, subtitles, and
settings. You can either use them as-is or create your own UI that interacts
with the GOAT global scripts.

.. _Godot Engine: https://github.com/godotengine/godot
.. _3.2 stable: https://downloads.tuxfamily.org/godotengine/3.2/
.. _readthedocs: https://miskatonicstudio-goat.readthedocs.io

.. |Interactive button of a remote control in inventory| image:: https://user-images.githubusercontent.com/36821133/73209215-14c30f80-4148-11ea-8afc-3f2fc7ef9037.png
