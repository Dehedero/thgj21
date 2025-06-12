# 5. Справочник API

В этом разделе приведены краткие описания ключевых синглтонов и классов шаблона GOAT, их назначение и основные методы.

---

## goat
**Главный управляющий синглтон шаблона.**
- Управляет игровым режимом (`game_mode`), хранит глобальные настройки.
- Методы: `set_game_mode(mode)`, `get_game_resources_directory()` и др.

## goat_state
**Глобальное хранилище состояния игры.**
- Позволяет хранить и получать любые переменные прогресса.
- Методы: `set(key, value)`, `get(key)`, `_register_variable(key, value)`.

## goat_inventory
**Менеджер инвентаря.**
- Управляет предметами, их добавлением, удалением, выбором и использованием.
- Методы: `add_item(item_name)`, `remove_item(item_name)`, `use_item(item_name, used_on_name)`, `get_items()`, `get_selected_item()`.
- Сигналы: `item_added`, `item_removed`, `item_selected`, `item_used`, `items_changed`.

## goat_interaction
**Менеджер взаимодействия с интерактивными объектами.**
- Отвечает за выбор, активацию и альтернативную активацию объектов.
- Методы: `select_object`, `deselect_object`, `activate_object`, `alternatively_activate_object`.
- Сигналы: `object_selected`, `object_activated`, `object_activated_alternatively`.

## goat_voice
**Система озвучки и голосовых реплик.**
- Управляет воспроизведением аудиофайлов для диалогов и событий.
- Методы: `start_dialogue(dialogue_id)`, `play(audio_path)`.
- Сигналы: `started`, `finished`.

## goat_settings
**Менеджер настроек игры.**
- Управляет всеми параметрами (графика, звук, управление, интерфейс).
- Методы: `get_value(section, key)`, `set_value(section, key, value)`.
- Сигналы: `value_changed`, `value_changed_<section>_<key>`.

## goat_audio_bus
**Менеджер звуковых шин.**
- Управляет громкостью, эффектами и проигрыванием звуков.
- Методы: `play(audio_path)`, `set_volume(bus, value)`.

## goat_locale
**Менеджер локализации.**
- Управляет языками и переводами.
- Методы: `set_locale(locale)`, `get_locale()`.

## DialogueManager
**Менеджер диалогов.**
- Загружает, запускает и управляет диалогами.
- Методы: `start_dialogue(resource)`, `get_next_dialogue_line(resource, key)`.
- Сигналы: `dialogue_started`, `got_dialogue`, `dialogue_ended`, `mutated`.

---

## UI-сцены и компоненты

- **Player.tscn** — контроллер игрока (движение, камера, взаимодействие)
- **Inventory.tscn** — окно инвентаря с 3D-просмотром предмета
- **InventoryBar.tscn** — панель быстрого доступа к предметам
- **InteractiveItem.tscn** — базовый интерактивный предмет
- **InteractiveScreen.tscn** — интерактивный экран/терминал
- **Settings.tscn** — меню настроек

## UI Helper Scenes

- **Inventory.tscn** — полноэкранный 3D-инвентарь ([подробно](./features/helper_scenes.md#inventory))
- **InventoryBar.tscn** — панель быстрого доступа к предметам
- **ContextInventory.tscn** — контекстное меню инвентаря
- **Settings.tscn** — меню настроек
- **Subtitles.tscn** — субтитры и варианты ответов
- **IconMaker.tscn** — генератор иконок для предметов
- **RayCast3D.tscn** — специализированный RayCast для взаимодействия

## Основные сцены (main_scenes)

- **Player.tscn** — контроллер игрока (движение, камера, взаимодействие) ([подробно](./features/main_scenes.md#playertscn))
- **InteractiveItem.tscn** — базовый интерактивный предмет ([подробно](./features/main_scenes.md#interactiveitemtscn))
- **InteractiveScreen.tscn** — интерактивный экран/терминал ([подробно](./features/main_scenes.md#interactivescreentscn))
- **DetailedInteraction.tscn** — сцена детального взаимодействия/зум на головоломку ([подробно](./features/main_scenes.md#detailedinteractiontscn))

---

Для подробного изучения методов и сигналов см. исходные скрипты в папке `addons/goat/`.
