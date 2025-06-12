# 3.2. Основные сцены (main_scenes)

Этот раздел описывает ключевые сцены шаблона GOAT, которые используются для построения игрового мира и взаимодействия с ним. Каждая сцена может быть унаследована и расширена под нужды вашего проекта.

## Player.tscn
**Назначение:** Контроллер игрока с поддержкой движения, камеры от первого лица, взаимодействия с объектами, инвентаря, настроек и других UI.

### Структура
- CharacterBody3D — основной узел для физики и перемещения
- Camera3D — камера от первого лица
- RayCast3D — для выбора интерактивных объектов
- Hand — для отображения предметов в руке
- Inventory, ContextInventory, Settings, Subtitles — UI-сцены
- Scope — прицел

### Интеграция
- Интегрируется с goat, goat_settings, goat_voice, goat_inventory, goat_interaction
- Использует сигналы: game_mode_changed, value_changed_gui_scope, started/finished (goat_voice)

### Пример расширения: добавление способности
```gdscript
# Ваша сцена наследует Player.tscn
extends "res://addons/goat/main_scenes/Player.gd"

func _input(event):
    super._input(event)
    if Input.is_action_just_pressed("goat_jump"):
        velocity.y = 5.0 # Simple jump
```

### Best practices
- Для расширения используйте наследование, не изменяйте оригинальный скрипт
- Для новых UI-элементов добавляйте дочерние узлы
- Подписывайтесь на сигналы только для нужных событий

### Ограничения
- Поддерживает только одного игрока на сцену
- Все UI-сцены должны быть дочерними узлами Player

---

## InteractiveItem.tscn
**Назначение:** Базовый интерактивный предмет (рычаг, ключ, кнопка, предмет для инвентаря, предмет "в руку", запуск диалога).

### Структура
- StaticBody3D — основной узел
- CollisionShape3D — форма для взаимодействия
- RandomAudioPlayer — проигрывание звуков
- InteractionIcon — иконка взаимодействия

### Интеграция
- Интегрируется с goat_interaction, goat_inventory, goat_state, goat_voice
- Использует сигналы: object_selected, object_activated, object_activated_alternatively, object_enabled, object_disabled

### Пример расширения: создание уникального предмета
```gdscript
# Ваша сцена наследует InteractiveItem.tscn
extends "res://addons/goat/main_scenes/InteractiveItem.gd"

func _on_object_activated(object_name, _point):
    super._on_object_activated(object_name, _point)
    if object_name == unique_name:
        print("Special logic for this item!")
```

### Best practices
- Для новых типов предметов используйте ItemType и наследование
- Для сложных сценариев подписывайтесь на нужные сигналы

### Ограничения
- Каждый предмет должен иметь уникальное имя
- Для предметов типа INVENTORY требуется задать inventory_item_name

---

## InteractiveScreen.tscn
**Назначение:** Интерактивный терминал/экран с 2D-контентом (мини-игры, панели, компьютеры).

### Структура
- StaticBody3D — основной узел
- ScreenSurface — MeshInstance3D для отображения экрана
- SubViewport — для рендеринга 2D-контента
- InteractionIcon — иконка взаимодействия
- Content — дочерний 2D-узел с интерфейсом

### Интеграция
- Интегрируется с goat_interaction, goat_voice
- Использует сигналы: object_selected, object_activated, object_activated_alternatively

### Пример расширения: добавление мини-игры
```gdscript
# В Content.gd (дочерний узел Content)
func _input(event):
    if event is InputEventMouseButton and event.pressed:
        print("Screen clicked at:", event.position)
```

### Best practices
- Для каждого экрана используйте уникальное имя
- Контент размещайте внутри Content

### Ограничения
- Поддерживает только один Content на экран
- Размер области задаётся через content_size

---

## DetailedInteraction.tscn
**Назначение:** Сцена для "зум-ин" на часть окружения (например, головоломка), с отдельной камерой и интерактивным предметом.

### Структура
- Node3D — основной узел
- InteractiveItem — вложенный интерактивный объект
- Camera3D — отдельная камера для детального вида
- RayCast3D — для взаимодействия внутри зоны
- Backplate — блокирует взаимодействие с окружением

### Интеграция
- Интегрируется с goat_interaction, goat_voice, goat
- Использует сигналы: object_activated

### Пример расширения: добавление логики выхода
```gdscript
func _input(event):
    super._input(event)
    if goat.game_mode == goat.GameMode.DETAILED_INTERACTION and Input.is_action_just_pressed("goat_dismiss"):
        print("Exiting detailed interaction")
```

### Best practices
- Для каждой DetailedInteraction используйте уникальный InteractiveItem
- Для плавного перехода используйте tween-ы для камеры

### Ограничения
- Только один DetailedInteraction на сцену
- Не использовать с предметами инвентаря
