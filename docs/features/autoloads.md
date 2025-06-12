# 3.1. Глобальные скрипты (Autoloads)

Глобальные скрипты (синглтоны) являются ядром шаблона GOAT. Они доступны из любого места вашего кода, что делает их центральным элементом для управления состоянием игры, инвентарем и другими глобальными системами.

Вот список всех синглтонов, зарегистрированных в `project.godot`:

| Имя (Global Variable) | Путь к файлу                                                    | Назначение                                                                                                           |
| --------------------- | --------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `goat_audio_bus`      | `res://addons/goat/autoload/audio_bus.gd`                       | Управляет звуковыми шинами, громкостью и эффектами. Используйте его для проигрывания звуков.                         |
| `goat_locale`         | `res://addons/goat/autoload/locale.gd`                          | Отвечает за локализацию и перевод строк.                                                                             |
| `goat_utils`          | `res://addons/goat/globals/goat_utils.gd`                       | Содержит набор вспомогательных утилит и функций, которые могут понадобиться в разных частях проекта.                 |
| `goat`                | `res://addons/goat/globals/goat.gd`                             | Главный управляющий синглтон шаблона. Управляет режимами игры, настройками, глобальными параметрами.                 |
| `goat_state`          | `res://addons/goat/globals/goat_state.gd`                       | Глобальное хранилище состояния игры: флаги, переменные прогресса, условия для диалогов и интерактивных объектов.     |
| `goat_inventory`      | `res://addons/goat/globals/goat_inventory.gd`                   | Отвечает за инвентарь игрока. Позволяет добавлять, удалять и проверять наличие предметов.                            |
| `goat_interaction`    | `res://addons/goat/globals/goat_interaction.gd`                 | Управляет системой взаимодействия. Регистрирует все интерактивные объекты на сцене и обрабатывает клики мыши по ним. |
| `goat_voice`          | `res://addons/goat/globals/goat_voice.gd`                       | Система для проигрывания голосовых реплик персонажей.                                                                |
| `goat_settings`       | `res://addons/goat/globals/goat_settings.gd`                    | Управляет настройками игры (графика, звук, управление) и их сохранением/загрузкой.                                   |
| `DialogueManager`     | `res://addons/goat/addons/dialogue_manager/dialogue_manager.gd` | Мощный менеджер диалогов, основанный на кастомных ресурсах `.dialogue`. Обрабатывает ветвление, условия и реплики.   |

## Как их использовать?

Вы можете обратиться к любому из этих синглтонов напрямую по его имени из любого скрипта GDScript.

**Пример**:

```gdscript
# Проверяем, есть ли у игрока ключ в инвентаре
if goat_inventory.has('key'):
    # Устанавливаем флаг, что дверь открыта
    goat_state.set('is_door_open', true)
    # Проигрываем звук открытия двери
    goat_audio_bus.play('res://path/to/door_open_sound.ogg')
```

---

### Главный управляющий синглтон goat

`goat` — это центральный управляющий синглтон шаблона. Он отвечает за смену режимов игры, хранит глобальные параметры и предоставляет API для управления состоянием и настройками.

**Основные свойства:**
- `game_mode` — текущий режим игры (см. enum GameMode: NONE, EXPLORING, DETAILED_INTERACTION, INVENTORY, CONTEXT_INVENTORY, SETTINGS)
- `PLAYER_SPEED` — скорость передвижения игрока
- `BOTTOM_CAMERA_ANGLE`, `TOP_CAMERA_ANGLE`, `LEFT_CAMERA_ANGLE`, `RIGHT_CAMERA_ANGLE` — ограничения камеры
- `ALLOW_CAMERA_MOVEMENT_WHEN_VOICE_IS_PLAYING` — разрешить ли движение камеры во время озвучки
- `SCREENSHOT_DIRECTORY` — папка для скриншотов

**Основные методы:**
- `set_game_mode(new_game_mode)` — сменить режим игры (вызывает сигнал `game_mode_changed`)
- `get_game_resources_directory()` — получить путь к папке ресурсов игры
- `take_screenshot()` — сделать скриншот экрана
- `reset_game()` — сбросить состояние инвентаря и прогресса

**Сигналы:**
- `game_mode_changed(new_game_mode)` — вызывается при смене режима игры

**Примеры использования:**

```gdscript
# Переключить режим на инвентарь
if Input.is_action_just_pressed("goat_toggle_inventory"):
    goat.set_game_mode(goat.GameMode.INVENTORY)

# Получить путь к папке ресурсов
var res_dir = goat.get_game_resources_directory()

# Сделать скриншот
if Input.is_action_just_pressed("goat_screenshot"):
    goat.take_screenshot()
```

**Best practices:**
- Используйте goat для смены режимов и глобальных настроек, а не напрямую через переменные.
- Подписывайтесь на сигнал `game_mode_changed` для реакции на смену режима в UI и других системах.
- Все глобальные параметры (скорость, углы камеры и т.д.) выносите в goat для централизованного управления.

### Локализация и goat_locale

`goat_locale` — это синглтон для автоматической загрузки и управления переводами в проекте.

**Как работает:**
- При запуске игры автоматически загружает все файлы переводов (`.translation`) из папки `res://addons/goat/locale/`.
- При выходе из игры — выгружает переводы.
- Использует goat_utils для поиска и загрузки файлов.
- Интегрируется с TranslationServer Godot.

**Основные методы:**
- Для смены языка используйте стандартный API Godot:

```gdscript
TranslationServer.set_locale("en") # или "ru", "de" и т.д.
```

- Для получения текущего языка:

```gdscript
var current_locale = TranslationServer.get_locale()
```

**Пример использования в UI:**

```gdscript
# Перевести строку с ключом
var text = tr("MY_KEY")
label.text = text
```

**Best practices:**
- Все строки, требующие перевода, должны быть помечены через tr("...") или экспортированы в .pot/.csv для локализации.
- Для добавления новых языков — поместите .translation-файлы в папку `res://addons/goat/locale/` или используйте goat_utils.add_translations для пользовательских директорий.
- Для динамической смены языка используйте TranslationServer.set_locale и обновляйте UI вручную.

### Вспомогательные функции goat_utils

`goat_utils` — это набор утилит для работы с файлами, директориями и локализацией. Используется для загрузки ресурсов, работы с текстовыми файлами и управления переводами.

**Основные функции:**
- `list_directory(path)` — возвращает список файлов в директории.
- `load_text_file(path)` — загружает текстовый файл и возвращает его содержимое.
- `add_translations(translation_directory_path)` — добавляет все переводы из директории в TranslationServer.
- `remove_translations(translation_directory_path)` — удаляет переводы из TranslationServer.

**Примеры использования:**

```gdscript
# Получить список всех файлов в папке ресурсов
var files = goat_utils.list_directory("res://game/resources/")

# Загрузить текстовый файл
var text = goat_utils.load_text_file("res://game/data/intro.txt")

# Добавить все переводы из папки
goat_utils.add_translations("res://game/locale/")
```

Эти функции полезны для динамической загрузки ресурсов, работы с пользовательскими файлами и поддержки мультиязычности.

### Глобальное хранилище состояния goat_state

`goat_state` — это синглтон для хранения флагов, переменных прогресса, условий для диалогов и интерактивных объектов. Используется для отслеживания событий, состояния мира, прохождения квестов и т.д.

**Основные методы:**
- `set_value(variable_name, value)` — установить значение переменной
- `get_value(variable_name)` — получить значение переменной
- `has_variable(variable_name)` — проверить, зарегистрирована ли переменная
- `_register_variable(variable_name, initial_value)` — зарегистрировать переменную (обычно вызывается автоматически)
- `reset()` — сбросить все переменные к значениям по умолчанию

**Сигналы:**
- `changed(variable_name, from_value, to_value)` — вызывается при изменении значения переменной

**Примеры использования:**

```gdscript
# Установить флаг, что игрок нашёл ключ
if goat_inventory.has('key'):
    goat_state.set_value('key_found', true)

# Проверить, был ли сыгран интро-ролик
if not goat_state.get_value('intro_played'):
    play_intro()
    goat_state.set_value('intro_played', true)

# Использовать переменные состояния в диалогах
if goat_state.get_value('power_on'):
    DialogueManager.start_dialogue(load('res://dialogues/power_on.dialogue'))
```

**Best practices:**
- Используйте goat_state для хранения только простых переменных (флаги, числа, строки), не храните большие структуры или объекты.
- Все переменные должны быть зарегистрированы через `_register_variable` (обычно автоматически при запуске).
- Для сброса состояния при новой игре используйте `goat_state.reset()`.
- Подписывайтесь на сигнал `changed` для реакции на изменение состояния в UI или логике игры.
