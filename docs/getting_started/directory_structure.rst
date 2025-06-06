Project Structure
===================

As GOAT is a plugin, it does not enforce a rigid structure for your entire Godot project. You are free to organize your scenes, scripts, and assets as you see fit.

However, GOAT needs to know where to find specific game resources that it manages, such as inventory items, voice files, and dialogues.

Game Resources Directory
------------------------

You must specify a **Game Resources Directory** where GOAT will look for these assets. This is configured in the Godot editor:

1.  Go to ``Project -> Project Settings``.
2.  Navigate to the ``GOAT`` tab on the left (it may be at the bottom).
3.  Under the ``General`` section, set the ``Game Resources Directory`` property to a directory in your project (e.g., ``res://game``).

Required Subdirectories
-----------------------

Inside the directory you specified above, GOAT expects a specific subdirectory structure:

::

   <your_game_resources_directory>/
   └── goat/
       ├── inventory_items/
       │   ├── icons/      # PNG icons for inventory items (e.g., my_item.png)
       │   └── models/     # .tscn scenes for inventory items (e.g., MyItem.tscn)
       ├── voice/          # Audio files (.ogg, .wav) for voice lines
       └── dialogues/      # Dialogue Manager files (.dialogue)

-  **Inventory Items:** GOAT automatically discovers inventory items by scanning the ``models`` folder for ``.tscn`` files. The scene's filename will be converted to a snake_case ID (e.g., ``MyKey.tscn`` becomes ``my_key``). GOAT will then look for a corresponding icon at ``icons/my_key.png``.
-  **Voice:** Audio files for voice-overs should be placed here.
-  **Dialogues:** Files for the Dialogue Manager integration go here.

Example
-------

If you set your ``Game Resources Directory`` to ``res://my_game_data``, GOAT will look for inventory item models in ``res://my_game_data/goat/inventory_items/models/``.
