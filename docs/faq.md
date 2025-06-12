# 6. FAQ — Часто задаваемые вопросы

Этот раздел содержит ответы на часто задаваемые и неочевидные вопросы по использованию, расширению и интеграции шаблона GOAT.

---

## Как правильно наследовать сцены и не потерять обновления шаблона?

- Всегда создавайте свои сцены через "Inherit Scene" или "Extend Script".
- Не изменяйте файлы в `addons/goat/` — все доработки делайте в своих директориях.
- При обновлении шаблона просто заменяйте папку `addons/goat/`.
- Подробнее: [Best practices по расширению](./advanced.md#best-practices)

---

## Как добавить свой глобальный синглтон (autoload)?

1. Создайте скрипт, например, `res://game/autoloads/MyManager.gd`.
2. В настройках проекта добавьте его в список Autoload с уникальным именем.
3. Используйте его как обычный синглтон:
```gdscript
MyManager.do_something()
```
- Подробнее: [Глобальные скрипты (Autoloads)](./features/autoloads.md)

---

## Как избежать конфликтов уникальных имён интерактивных объектов?

- Для каждого `InteractiveItem` и `InteractiveScreen` используйте уникальное имя (`unique_name`).
- Рекомендуется использовать префиксы по месту (например, `kitchen_door_key`, `npc_ivan`).
- Подробнее: [Система взаимодействия](./features/interaction_system.md)

---

## Как интегрировать свои UI-сцены с Player?

- Добавьте свою сцену как дочерний узел к Player.tscn.
- Для управления видимостью используйте сигналы `game_mode_changed`:
```gdscript
func _on_game_mode_changed(new_game_mode):
    my_ui.visible = (new_game_mode == goat.GameMode.MY_MODE)
```
- Подробнее: [Player.tscn](./features/main_scenes.md#playertscn)

---

## Как правильно сохранять и загружать состояние игры?

- Используйте goat_state для хранения флагов и переменных:
```gdscript
goat_state.set_value("quest_started", true)
```
- Для загрузки/сохранения используйте стандартные методы Godot (File, ConfigFile) и сериализуйте нужные переменные.
- Подробнее: [goat_state](./features/autoloads.md#глобальное-хранилище-состояния-goat_state)

---

## Как расширить инвентарь или добавить новые типы предметов?

- Для новых типов предметов наследуйте InventoryItem или расширяйте goat_inventory.
- Для кастомных UI — создайте свою сцену, подписывайтесь на сигналы goat_inventory.
- Подробнее: [Система инвентаря](./features/inventory_system.md)

---

## Как работать с локализацией и динамически менять язык?

- Используйте goat_locale и стандартный API Godot:
```gdscript
TranslationServer.set_locale("en")
```
- Для перевода строк используйте tr("KEY") и .translation-файлы.
- Подробнее: [goat_locale](./features/autoloads.md#локализация-и-goat_locale)

---

## Как обновлять шаблон GOAT без потери своих изменений?

- Все свои сцены, скрипты и ресурсы держите вне папки `addons/goat/`.
- При обновлении просто заменяйте папку шаблона.
- Для кастомных UI и логики используйте наследование и композицию.
- Подробнее: [Best practices по расширению](./advanced.md#best-practices)

---

## Как отлаживать сигналы и избегать утечек памяти?

- Всегда отключайте сигналы при удалении объектов:
```gdscript
my_signal.disconnect(my_func, self)
```
- Используйте print и push_error для отладки.
- Подробнее: [Best practices](./advanced.md#best-practices)

---

## Как реализовать несколько DetailedInteraction на одной сцене?

- По архитектуре GOAT поддерживается только один DetailedInteraction на сцену.
- Для нескольких — создавайте отдельные сцены и переключайте их программно.
- Подробнее: [DetailedInteraction.tscn](./features/main_scenes.md#detailedinteractiontscn)

---

## Как подключить EventBus для глобальных событий?

- Создайте автозагрузку EventBus.gd с нужными сигналами:
```gdscript
extends Node
signal my_event(data)
```
- В любом месте проекта:
```gdscript
EventBus.emit_signal("my_event", data)
```
- Подробнее: [Глобальные сигналы и EventBus](./advanced.md#глобальные-сигналы)

---

## Как добавить поддержку новых платформ (HTML5, мобильные)?

- Используйте только кроссплатформенные API Godot.
- Для специфичных функций (например, файловая система) используйте проверки:
```gdscript
if OS.get_name() == "HTML5":
    # Special logic
```
- Подробнее: [Best practices](./advanced.md#best-practices)

---

## Как добавить свои условия и мутации в DialogueManager?

- В ресурсах диалогов используйте поля `condition` и `mutation` для проверки и изменения состояния:
```gdscript
# В диалоговом ресурсе:
{
  "key": "line1",
  "text": "You need a key!",
  "condition": "goat_inventory.has('key')"
}
```
- Для сложных условий используйте goat_state и свои методы.
- Подробнее: [Менеджер диалогов](./features/dialogue_manager.md)

---

## Как подключить собственный UI для диалогов?

- Создайте свою сцену для отображения реплик и вариантов ответа.
- Подпишитесь на сигналы DialogueManager:
```gdscript
DialogueManager.connect("got_dialogue", self._on_got_dialogue)
```
- Для анимации портретов используйте отдельные узлы и обновляйте их в _on_got_dialogue.
- Подробнее: [Менеджер диалогов](./features/dialogue_manager.md)

---

## Как добавить новые категории взаимодействия в goat_interaction?

- Используйте параметр category в RayCast3D и методах goat_interaction:
```gdscript
goat_interaction.select_object("terminal_1", point, "terminals")
```
- Для новых групп объектов создайте отдельные RayCast3D с нужной категорией.
- Подробнее: [Система взаимодействия](./features/interaction_system.md)

---

## Как программно активировать интерактивный объект?

- Используйте методы goat_interaction:
```gdscript
goat_interaction.select_object("npc_1", point, "npcs")
goat_interaction.activate_object("npcs")
```
- Для автосценариев и кат-сцен используйте эти методы для управления выбором и активацией.
- Подробнее: [Система взаимодействия](./features/interaction_system.md)

---

## Как структурировать папки с ассетами для масштабируемого проекта?

- Рекомендуется структура:
```
game/
  scenes/
  scripts/
  assets/
    models/
    icons/
    sounds/
    music/
    locale/
```
- Для переводов используйте отдельную папку `locale/`.
- Для пользовательских ресурсов — отдельные подпапки по типу ассета.
- Подробнее: [Структура проекта](./getting_started.md#структура-проекта)

---

## Как добавить сложные параметры в меню настроек?

- В goat_settings.gd добавьте параметр с нужным типом (например, строка, число, bool):
```gdscript
DEFAULT_VALUES.append(["graphics", "quality", "high"])
```
- В пользовательской сцене настроек используйте нужный UI-элемент (например, OptionButton):
```gdscript
var quality = goat_settings.get_value("graphics", "quality")
```
- Для выпадающих списков, цветов и т.д. используйте соответствующие контролы Godot.
- Подробнее: [Меню настроек](./features/settings_menu.md)

---

## Как сбросить все настройки к значениям по умолчанию?

- В goat_settings реализуйте метод reset_to_defaults (или аналогичный):
```gdscript
func reset_to_defaults():
    for entry in DEFAULT_VALUES:
        goat_settings.set_value(entry[0], entry[1], entry[2])
```
- Добавьте кнопку "Сбросить настройки" в меню настроек и вызовите этот метод.
- Подробнее: [Меню настроек](./features/settings_menu.md)

---

## Как логировать ошибки и собирать отчёты о сбоях?

- Для логирования используйте print, push_error, push_warning:
```gdscript
push_error("Critical error in inventory!")
```
- Для сбора отчётов используйте File и сохраняйте логи в user://crash.log.
- Для сложных проектов интегрируйте сторонние сервисы (например, Sentry через HTTPRequest).
- Подробнее: [Best practices](./advanced.md#best-practices)

---

## Как использовать юнит-тесты для проверки логики?

- Используйте GUT (Godot Unit Test) или встроенные тесты Godot:
```gdscript
# Пример теста с GUT
gut.test("inventory add", func():
    goat_inventory.add_item("key")
    assert(goat_inventory.has("key"))
)
```
- Для сложных систем пишите отдельные тестовые сцены и скрипты.
- Подробнее: [Отладка и тестирование](./advanced.md#отладка-и-тестирование)

---

## Как безопасно мигрировать на новую версию GOAT?

- Перед обновлением сделайте резервную копию проекта.
- Все свои изменения держите вне папки `addons/goat/`.
- После обновления проверьте совместимость своих сцен и скриптов с новой версией.
- Для изменений в autoloads или main_scenes используйте наследование и минимальные патчи.
- Подробнее: [Best practices по расширению](./advanced.md#best-practices)

---

## Как хранить пользовательские данные и защитить прогресс?

- Для сохранения используйте ConfigFile или File с путём user://savegame.cfg.
- Для защиты от потери данных используйте резервные копии и проверки на целостность файла.
- Для шифрования используйте методы Godot (например, Crypto) при необходимости:
```gdscript
var encrypted = Crypto.encrypt(plain_data, key)
```
- Подробнее: [Best practices](./advanced.md#best-practices)

---

**Если не нашли ответ — ищите в соответствующем разделе или задайте вопрос в issue-трекере проекта!**
