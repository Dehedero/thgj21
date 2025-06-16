# 3.8. Вспомогательные UI-сцены (helper_scenes)

Этот раздел описывает готовые UI-компоненты, входящие в шаблон GOAT, и их интеграцию с глобальными системами. Все helper-сцены предназначены для быстрой интеграции, расширения и кастомизации пользовательского интерфейса.

## Inventory.tscn
**Назначение:** Полноэкранный 3D-инвентарь с возможностью вращения предметов, drag&drop, выбором и использованием предметов.

### Архитектура и интеграция
- Inventory.tscn — это сцена типа Control, включающая SubViewport для 3D-просмотра предмета, список предметов (InventoryItems), кнопки управления и обработку событий мыши.
- Интегрируется с goat_inventory (получение и изменение списка предметов), goat_voice (блокировка управления во время озвучки), goat_settings (чувствительность мыши, параметры интерфейса).
- Использует сигналы goat_inventory: item_selected, items_changed, item_used и собственный сигнал rotation_reset_requested.

### Основные сигналы
- `item_selected(item_name: String)` — выбран новый предмет.
- `items_changed(new_items: Array)` — изменился список предметов.
- `rotation_reset_requested()` — пользователь запросил сброс вращения 3D-модели.

### Пример расширения: добавление новой кнопки
```gdscript
# Ваша сцена наследует Inventory.tscn
extends "res://addons/goat/helper_scenes/Inventory.gd"

@onready var my_button = $MyButton

func _ready():
    super._ready()
    my_button.pressed.connect(_on_my_button_pressed)

func _on_my_button_pressed():
    # Example: print selected item name
    var selected_item = goat_inventory.get_selected_item()
    print("Selected item:", selected_item)
```

### Пример: обработка события использования предмета
```gdscript
func _ready():
    super._ready()
    goat_inventory.item_used.connect(_on_item_used)

func _on_item_used(item_name, used_on_name):
    print("Item used:", item_name, "on", used_on_name)
```

### Best practices
- Подписывайтесь на сигналы только в нужных режимах (например, только когда открыт инвентарь).
- Не изменяйте оригинальный скрипт Inventory.gd — используйте наследование или композицию.
- Для кастомизации интерфейса добавляйте свои кнопки и элементы через дочерние узлы.
- Для сложных предметов реализуйте отдельные 3D-модели и логику использования через обработку сигнала item_used.
- Максимальная вместимость инвентаря задаётся константой CAPACITY (по умолчанию 8).

### Архитектурные ограничения
- Inventory.tscn предполагает работу только с goat_inventory и не поддерживает несколько независимых инвентарей.
- Все предметы должны иметь уникальные имена и соответствующие 3D-модели/иконки.
- Для корректной работы drag&drop используйте стандартные методы Godot и не меняйте структуру InventoryItems.tscn без необходимости.

## InventoryBar.tscn
**Назначение:** Компактная панель быстрого доступа к предметам, отображается в режиме исследования.

### Архитектура и интеграция
- InventoryBar.tscn — это сцена типа Control, содержащая VBoxContainer с кнопками для каждого предмета и AnimationPlayer для анимации появления/скрытия панели.
- Интегрируется с goat_inventory (отображение предметов, обновление иконок, обработка событий добавления/замены предметов).
- Использует сигналы goat_inventory: item_added, item_replaced, items_changed.

### Основные сигналы
- `item_added(item_name: String)` — предмет добавлен в инвентарь.
- `item_replaced(replaced_item_name: String, replacing_item_name: String)` — предмет заменён.
- `items_changed(new_items: Array)` — изменился список предметов.

### Пример расширения: добавление нового слота
```gdscript
# Ваша сцена наследует InventoryBar.tscn
extends "res://addons/goat/helper_scenes/InventoryBar.gd"

func _ready():
    super._ready()
    # Add a new button for an extra slot
    var new_button = Button.new()
    new_button.icon = preload("res://game/goat/inventory_items/icons/special_item.png")
    $Items.add_child(new_button)
    new_button.pressed.connect(_on_special_item_pressed)

func _on_special_item_pressed():
    print("Special item button pressed!")
```

### Пример: изменение анимации панели
```gdscript
# Изменить длительность анимации через AnimationPlayer
@onready var animation_player = $AnimationPlayer

func _ready():
    super._ready()
    animation_player.get_animation("show").length = 2.0 # Set animation duration to 2 seconds
```

### Best practices
- Не изменяйте оригинальный скрипт InventoryBar.gd — используйте наследование для добавления логики.
- Для кастомизации внешнего вида используйте theme_override_styles и собственные иконки.
- Для расширения панели добавляйте новые кнопки через дочерние узлы.
- Подписывайтесь на сигналы только при необходимости, чтобы избежать лишних обновлений UI.

### Архитектурные ограничения
- InventoryBar.tscn рассчитан на работу с goat_inventory и не поддерживает динамическое изменение количества слотов без модификации структуры.
- Для корректной работы анимаций не изменяйте структуру VBoxContainer и AnimationPlayer без необходимости.

## ContextInventory.tscn
**Назначение:** Контекстное меню инвентаря для быстрого использования предметов на объектах окружения.

### Архитектура и интеграция
- ContextInventory.tscn — это сцена типа Control, реализующая всплывающее меню с кнопками для каждого предмета инвентаря и кнопкой выхода.
- Интегрируется с goat_inventory (получение и обновление списка предметов, использование предметов), goat_interaction (получение выбранного объекта окружения).
- Использует сигналы goat_inventory: items_changed, а также goat: game_mode_changed.

### Основные сигналы
- `items_changed(new_items: Array)` — изменился список предметов.
- `game_mode_changed(new_game_mode: int)` — изменился режим игры (от goat).

### Пример расширения: добавление нового типа взаимодействия
```gdscript
# Ваша сцена наследует ContextInventory.tscn
extends "res://addons/goat/helper_scenes/ContextInventory.gd"

# Переопределяем оригинальный метод, чтобы добавить свою логику
func _on_item_button_pressed(item_index):
    var item_name = goat_inventory.get_items()[item_index]
    # Получаем объект, на который игрок смотрел перед открытием меню
    var target_object_name = goat_interaction.get_selected_object("default")

    # Пример кастомной логики: если ключ используется на запертой двери
    if item_name == "my_key" and target_object_name == "locked_door":
        print("Открываем дверь с помощью ключа!")
        # Здесь может быть ваша логика: проиграть звук, анимацию и т.д.
        goat_inventory.remove_item("my_key") # Удаляем ключ
        # Не забываем закрыть меню
        _go_back_to_exploring()
    else:
        # Если это не наша особая комбинация, вызываем стандартную логику
        super._on_item_button_pressed(item_index)
```

### Пример: обработка выхода из меню
```gdscript
func _on_ExitButton_pressed():
    print("Context inventory closed, playing a sound.")
    # goat_audio_bus.play("res://path/to/sound.ogg") # Пример дополнительного действия
    _go_back_to_exploring()
```

### Best practices
- Для расширения логики использования предметов переопределяйте _on_item_button_pressed.
- Не изменяйте оригинальный скрипт ContextInventory.gd — используйте наследование.
- Для кастомизации интерфейса добавляйте свои кнопки и элементы через дочерние узлы.
- Подписывайтесь на сигналы только при необходимости, чтобы избежать лишних обновлений UI.

### Архитектурные ограничения
- ContextInventory.tscn рассчитан на работу только с goat_inventory и goat_interaction.
- Для корректной работы не изменяйте структуру CenterContainer и кнопок без необходимости.
- Поддерживает только один выбранный объект окружения за раз.

## Settings.tscn
**Назначение:** Меню настроек, автоматически подгружает кастомную или дефолтную реализацию.

### Архитектура и интеграция
- Settings.tscn — это сцена типа Control, которая при инициализации подгружает стандартную или пользовательскую сцену настроек.
- Интегрируется с goat_settings (чтение и запись параметров), goat (управление режимами), поддерживает кастомные параметры через DEFAULT_VALUES.
- Использует сигналы goat: game_mode_changed, goat_settings: value_changed и value_changed_<section>_<key>.

### Основные сигналы
- `game_mode_changed(new_game_mode: int)` — изменился режим игры (от goat).
- `value_changed(section: String, key: String, value: Variant)` — изменилось значение параметра (от goat_settings).

### Пример расширения: добавление нового параметра

**Важное архитектурное замечание:** В текущей версии GOAT система настроек не имеет механизма расширения без модификации кода аддона. Чтобы добавить новую настройку, вам потребуется внести изменения напрямую в `addons/goat/globals/goat_settings.gd`. Помните, что эти изменения могут быть утеряны при обновлении аддона.

**Шаг 1: Добавление параметра в `DEFAULT_VALUES`**

Откройте `addons/goat/globals/goat_settings.gd` и добавьте вашу настройку в массив `DEFAULT_VALUES`.

```gdscript
# addons/goat/globals/goat_settings.gd
var DEFAULT_VALUES := [
	# ... существующие настройки ...
	["gameplay", "show_tutorials", true], # Ваша новая настройка
]
```

**Шаг 2: Использование параметра в коде**

Теперь вы можете использовать `goat_settings.get_value()` и `goat_settings.set_value()` для работы с вашей новой настройкой. Система автоматически создаст для нее сигнал `value_changed_gameplay_show_tutorials`.

```gdscript
# В коде вашей игры
func _on_some_event():
    if goat_settings.get_value("gameplay", "show_tutorials"):
        # ... показать обучение ...

# В вашей кастомной сцене настроек
func _ready():
    var checkbox = $MyTutorialsCheckbox
    # Устанавливаем начальное значение
    checkbox.button_pressed = goat_settings.get_value("gameplay", "show_tutorials")
    # Сохраняем значение при изменении
    checkbox.toggled.connect(func(pressed):
        goat_settings.set_value("gameplay", "show_tutorials", pressed)
    )
```

### Пример: кастомизация UI
```gdscript
# Ваша сцена наследует Settings.tscn
extends "res://addons/goat/helper_scenes/Settings.gd"

func _ready():
    super._ready()
    # Add a custom button to the settings menu
    var custom_button = Button.new()
    custom_button.text = "Reset Progress"
    custom_button.pressed.connect(_on_reset_progress_pressed)
    add_child(custom_button)

func _on_reset_progress_pressed():
    goat_state.reset()
    print("Game progress reset!")
```

### Best practices
- **Ввиду ограничений, основной "best practice" — создать свою сцену настроек, унаследованную от `Control`, и в ней реализовать всю логику для ваших кастомных параметров.** Вы можете по-прежнему использовать `goat_settings` для стандартных настроек (звук, графика), а для своих — реализовать собственную логику сохранения/загрузки.
- Для кастомизации интерфейса стандартных настроек добавляйте свои элементы через наследование от `Settings.tscn` или его дочерних узлов.
- Подписывайтесь на сигналы `value_changed` только для нужных параметров.

### Архитектурные ограничения
- **Главное ограничение:** `Settings.tscn` не поддерживает добавление новых, сохраняемых параметров без модификации исходного кода аддона `goat_settings.gd`.
- Рассчитан на работу только с `goat_settings` и `goat`.
- Все параметры должны быть зарегистрированы в `DEFAULT_VALUES` для корректного сохранения и загрузки.

## Subtitles.tscn
**Назначение:** Вывод субтитров и вариантов ответов в диалогах, интеграция с goat_voice и goat_settings.

### Архитектура и интеграция
- Subtitles.tscn — это сцена типа Control, содержащая Label для субтитров и VBoxContainer для вариантов ответов.
- Интегрируется с goat_voice (отображение субтитров и вариантов ответа при диалогах), goat_settings (включение/отключение субтитров), поддерживает динамическое обновление UI.
- Использует сигналы goat_voice: responses, started, finished, а также goat_settings: value_changed_gui_subtitles.

### Основные сигналы
- `responses(responses: Array)` — отображение вариантов ответа.
- `started(audio_name: String)` — начало озвучки (от goat_voice).
- `finished(audio_name: String)` — завершение озвучки (от goat_voice).
- `value_changed_gui_subtitles(_section, _key, value: bool)` — изменение настройки субтитров (от goat_settings).

### Пример расширения: изменение стиля субтитров
```gdscript
# Ваша сцена наследует Subtitles.tscn
extends "res://addons/goat/helper_scenes/Subtitles.gd"

@onready var bottom_text = $MarginContainer/BottomText

func _ready():
    super._ready()
    # Change font and color
    # ВАЖНО: Замените путь на реальный путь к вашему шрифту
    var custom_font = preload("res://game/fonts/MyFont.tres")
    bottom_text.add_theme_font_override("font", custom_font)
    bottom_text.add_theme_color_override("font_color", Color(1, 0.8, 0.2))
```

### Пример: добавление кастомной логики для вариантов ответа
```gdscript
# Ваша сцена наследует Subtitles.tscn
extends "res://addons/goat/helper_scenes/Subtitles.gd"

# Переопределяем оригинальный метод, чтобы изменить текст ответов
func show_responses(responses: Array) -> void:
    # Создаем новый массив для измененных ответов
    var modified_responses: Array = []
    for response in responses:
        var new_response = response.duplicate()
        # Добавляем префикс к каждому ответу
        new_response.text = "[Спросить] " + new_response.text
        modified_responses.append(new_response)

    # Вызываем оригинальный метод, но с измененными данными
    super.show_responses(modified_responses)
```

### Best practices
- Для изменения внешнего вида используйте theme_override_fonts, theme_override_colors и кастомные стили.
- Для расширения логики обработки ответов переопределяйте show_responses.
- Не изменяйте оригинальный скрипт Subtitles.gd — используйте наследование.
- Подписывайтесь на сигналы только для нужных событий.

### Архитектурные ограничения
- Subtitles.tscn рассчитан на работу только с goat_voice и goat_settings.
- Для корректной работы не изменяйте структуру MarginContainer и Responses без необходимости.
- Поддерживает только один активный набор вариантов ответа за раз.

## IconMaker.tscn
**Назначение:** Генератор иконок для предметов инвентаря на основе 3D-моделей.

### Архитектура и интеграция
- IconMaker.tscn — это сцена типа Node3D, содержащая SubViewport, Camera3D, Pivot и окружение для рендеринга 3D-моделей в иконки.
- Интегрируется с goat_inventory (генерация иконок для предметов), может использоваться отдельно для создания иконок любых 3D-объектов.
- Основной метод: make_icon_texture(model_scene_path: String) -> Texture2D.

### Основные методы
- `make_icon_texture(model_scene_path: String) -> Texture2D` — загружает 3D-модель, размещает её на Pivot и возвращает текстуру SubViewport.

### Пример расширения: изменение размера иконок
```gdscript
# Ваша сцена наследует IconMaker.tscn
extends "res://addons/goat/helper_scenes/IconMaker.gd"

func _ready():
    # Используем синтаксис уникальных имен для доступа к узлу
    %SubViewport.size = Vector2i(128, 128) # Set icon size to 128x128
```

### Пример: добавление эффекта постобработки
```gdscript
# Ваша сцена наследует IconMaker.tscn
extends "res://addons/goat/helper_scenes/IconMaker.gd"

func _ready():
    # Используем синтаксис уникальных имен для доступа к камере
    var camera = %Camera3D
    var environment = camera.environment.duplicate()
    environment.glow_enabled = true
    environment.glow_intensity = 0.8
    camera.environment = environment
```

### Best practices
- Для генерации иконок используйте только оптимизированные 3D-модели без лишних полигонов.
- Для изменения внешнего вида иконок используйте настройки SubViewport и Camera3D.
- Не изменяйте оригинальный скрипт IconMaker.gd — используйте наследование.
- Для пакетной генерации иконок вызывайте make_icon_texture в цикле для всех нужных моделей.

### Архитектурные ограничения
- IconMaker.tscn рассчитан на работу только с 3D-моделями, не поддерживает 2D-ресурсы.
- Для корректной работы не изменяйте структуру Pivot и SubViewport без необходимости.
- Размер иконки ограничен размером SubViewport.

## RayCast3D.tscn
**Назначение:** Специализированный RayCast для выбора и активации интерактивных объектов, поддерживает разные категории (окружение, инвентарь, "рука" и т.д.).

- Интеграция: goat_interaction
- Основные сигналы: object_selected, object_activated
- Примеры расширения: добавление новых категорий, изменение логики выбора

---

**Best practices:**
- Всегда указывайте, как сцена интегрируется с глобальными синглтонами.
- Приводите реальные примеры кода для расширения и кастомизации.
- Описывайте сигналы, которые можно использовать для связи с другими системами.
- Не забывайте про архитектурные ограничения (например, про работу с категориями RayCast3D, обработку событий в Inventory).

**Для подробных примеров и архитектурных деталей см. исходные скрипты в папке `addons/goat/helper_scenes/`.**
