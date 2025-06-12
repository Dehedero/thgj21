# 3.3. Система взаимодействия

Система взаимодействия позволяет игроку взаимодействовать с объектами в игровом мире. Она управляется глобальным синглтоном `goat_interaction` и основана на двух основных типах сцен: `InteractiveItem` и `InteractiveScreen`.

## `InteractiveItem`

`InteractiveItem.tscn` — это базовый класс для создания простых интерактивных 3D-объектов, таких как рычаги, кнопки, или предметы, которые можно подобрать.

### Как создать InteractiveItem

1.  Создайте новую сцену, унаследованную от `addons/goat/main_scenes/InteractiveItem.tscn`.
2.  Добавьте в качестве дочернего узла вашу 3D-модель предмета.
3.  Настройте параметры в инспекторе.

### Настройки в инспекторе

*   `Unique Name`: **Обязательное поле.** Уникальное имя объекта, которое используется для его идентификации в системе. Например, `kitchen_door_key`.
*   `Item Type`: Определяет поведение предмета при активации.
    *   `NORMAL`: Обычный предмет, может быть использован многократно (например, выключатель света).
    *   `SINGLE_USE`: Одноразовый предмет. После использования отключается.
    *   `INVENTORY`: Предмет для инвентаря. При активации исчезает со сцены и добавляется в инвентарь игрока.
    *   `HAND`: Предмет, который можно взять в "руку" и затем положить в другом месте.
    *   `DIALOGUE`: Запускает диалог при активации.
*   `Inventory Item Name`: (Только для типа `INVENTORY` и `DIALOGUE`). Имя предмета, которое будет добавлено в инвентарь, или ID диалога для запуска.
*   `Collision Shape`: Форма коллайдера для взаимодействия. **Важно:** настройте ее так, чтобы она соответствовала видимой части вашего объекта.
*   `Sounds`: Массив звуков, которые будут проигрываться случайным образом при активации объекта.

### Как это работает?

Скрипт `InteractiveItem` автоматически регистрируется в `goat_interaction`. Когда игрок наводит прицел на объект, `goat_interaction` посылает сигнал `object_selected`, что заставляет иконку взаимодействия появиться. При клике (`goat_interact`) посылается сигнал `object_activated`, который запускает логику, определенную `Item Type`.

### Пример использования

Предположим, вы хотите создать ключ, который игрок может подобрать.

1.  Создаете унаследованную сцену `MyKey.tscn`.
2.  Устанавливаете `Unique Name` в "my_key".
3.  Устанавливаете `Item Type` в `INVENTORY`.
4.  Устанавливаете `Inventory Item Name` в "key_to_something".
5.  Размещаете `MyKey.tscn` на вашей игровой сцене.

Теперь, когда игрок активирует этот ключ, объект `MyKey` исчезнет, а в `goat_inventory` будет добавлен предмет "key_to_something".

## `InteractiveScreen`

`InteractiveScreen.tscn` — это сцена для создания интерактивных терминалов, панелей, компьютеров и других "плоских" экранов с 2D-контентом.

### Как создать интерактивный экран

1. Создайте новую сцену, унаследованную от `addons/goat/main_scenes/InteractiveScreen.tscn`.
2. В качестве дочернего узла добавьте 2D-узел с именем `Content` (например, `Control`, `Panel`, `VBoxContainer` и т.д.).
3. Разместите нужные элементы интерфейса внутри `Content`.
4. Настройте параметры в инспекторе:
    * `unique_name` — уникальное имя экрана.
    * `content_size` — размер области контента (в пикселях).
    * `emission_energy` — яркость свечения экрана.
    * `unshaded` — отключить затенение (экран всегда яркий).

### Как это работает?

- При наведении прицела на экран появляется иконка взаимодействия.
- Движение мыши и клики по экрану транслируются в дочерний узел `Content` как события мыши (InputEventMouseMotion, InputEventMouseButton).
- Можно реализовать полноценные мини-игры, терминалы, ввод паролей и т.д.

**Пример:**

```gdscript
# Внутри Content.gd
func _input(event):
    if event is InputEventMouseButton and event.pressed:
        print("Клик по экрану: ", event.position)
```

## Глобальный менеджер взаимодействия (`goat_interaction`)

`goat_interaction` — это синглтон, управляющий всей логикой выбора и активации интерактивных объектов.

### Основные сигналы

- `object_selected(object_name, point)` — объект выбран (прицел наведен), point — точка взаимодействия.
- `object_deselected(object_name)` — объект больше не выбран.
- `object_activated(object_name, point)` — объект активирован (ЛКМ).
- `object_activated_alternatively(object_name, point)` — альтернативная активация (ПКМ или другое действие).
- `object_enabled(object_name)` — объект включен для взаимодействия.
- `object_disabled(object_name)` — объект выключен для взаимодействия.

### Основные методы

- `get_selected_object(category: String)` — получить имя выбранного объекта в категории.
- `get_selected_point(category: String)` — получить точку взаимодействия с выбранным объектом.
- `select_object(object_name: String, point: Vector3, category: String)` — выбрать объект.
- `deselect_object(category: String)` — снять выбор.
- `activate_object(category: String)` — активировать выбранный объект.
- `alternatively_activate_object(category: String)` — альтернативная активация.
- `enable_object(object_name)` / `disable_object(object_name)` — включить/выключить объект для взаимодействия.

### Примеры использования

```gdscript
# Программно активировать объект в категории "default"
goat_interaction.activate_object("default")

# Подписаться на событие активации
func _ready():
    goat_interaction.connect("object_activated", self._on_object_activated)

func _on_object_activated(object_name, point):
    print("Объект ", object_name, " активирован в точке ", point)

# Программно выбрать объект (например, для подсветки или автосценария)
var point = Vector3(1, 2, 3)
goat_interaction.select_object("npc_demo", point, "default")

# Снять выбор объекта в категории
goat_interaction.deselect_object("default")

# Использование нескольких категорий (например, для разных групп объектов)
goat_interaction.select_object("terminal_demo", Vector3(0,0,0), "terminals")
goat_interaction.select_object("npc_demo", Vector3(1,2,3), "npcs")

# Получить выбранный объект в категории
var selected_terminal = goat_interaction.get_selected_object("terminals")
```

### Best practices
- Используйте категории для независимых групп интерактивных объектов (например, терминалы, NPC, предметы).
- Всегда отключайте сигналы при удалении объектов, чтобы избежать утечек памяти.
- Не вызывайте активацию без выбора объекта (activate_object работает только с выбранным объектом).
- Не храните прямые ссылки на объекты, используйте уникальные имена.
- Для сложных сценариев подписывайтесь на нужные сигналы только в нужных местах (например, только в UI или контроллере игрока).

Подробнее о RayCast3D.tscn см. [Вспомогательные UI-сцены](./helper_scenes.md#raycast3d).
