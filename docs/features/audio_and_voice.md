# 3.7. Работа со звуком и озвучкой

GOAT предоставляет централизованную систему для работы со звуками (SFX, музыка) и озвучкой реплик через синглтоны goat_audio_bus и goat_voice.

## Архитектура

- **goat_audio_bus** — глобальный менеджер для проигрывания звуковых эффектов и музыки, управления громкостью и эффектами.
- **goat_voice** — система для проигрывания озвучки реплик, диалогов и событий.
- **Интеграция с goat_settings** — громкость и параметры звука настраиваются через меню настроек.

## `goat_audio_bus`: Создание аудиошин

**Важно:** Вопреки названию, `goat_audio_bus` **не является** менеджером для проигрывания звуков. Это скрипт-автозагрузка, единственная задача которого — создать в `AudioServer` две кастомные аудиошины при запуске игры:
-   **`GoatEffects`**: Для звуковых эффектов (SFX).
-   **`GoatMusic`**: Для фоновой музыки.

Это позволяет централизованно управлять громкостью всех эффектов и всей музыки через меню настроек (`goat_settings`), которое изменяет громкость именно этих шин.

### Как правильно проигрывать звуки

Поскольку у `goat_audio_bus` нет метода `play()`, для проигрывания звуков следует использовать стандартный для Godot узел `AudioStreamPlayer`.

1.  **Добавьте узел**: Добавьте узел `AudioStreamPlayer` или `AudioStreamPlayer3D` к сцене, которая должна издать звук (например, к двери, которая открывается).
2.  **Назначьте аудиофайл**: В инспекторе `AudioStreamPlayer` в поле `Stream` загрузите ваш звуковой файл (`.ogg` или `.wav`).
3.  **Выберите шину**: В поле `Bus` выберите нужную шину (`GoatEffects` для SFX или `GoatMusic` для музыки).
4.  **Запустите из кода**: В коде вызовите метод `play()` у этого узла.

### Пример: Звук открытия двери

```gdscript
# Скрипт на сцене с дверью, к которой добавлен узел AudioStreamPlayer
# с именем 'SoundEffectPlayer' и настроенной шиной 'GoatEffects'.

@onready var sound_effect_player: AudioStreamPlayer = $SoundEffectPlayer

func open_door():
    # Здесь логика открытия двери...
    # Проигрываем звук, привязанный к этому узлу
    sound_effect_player.play()
```

### Как управлять громкостью

Управлять громкостью нужно не через `goat_audio_bus`, а напрямую через `AudioServer`, используя имя шины.

```gdscript
# Установить громкость всех эффектов на 50%
var effects_bus_idx = AudioServer.get_bus_index("GoatEffects")
AudioServer.set_bus_volume_db(effects_bus_idx, linear_to_db(0.5))

# Установить громкость музыки на 80%
var music_bus_idx = AudioServer.get_bus_index("GoatMusic")
AudioServer.set_bus_volume_db(music_bus_idx, linear_to_db(0.8))
```
**Примечание:** Система настроек `goat_settings` делает это автоматически, когда игрок меняет ползунки громкости в меню.

## Озвучка и диалоги через goat_voice

## `goat_voice`: Движок для озвученных диалогов

**Важно:** `goat_voice` — это **не** универсальный проигрыватель звуков. Его основная и единственная задача — работать в связке с аддоном **Dialogue Manager** для воспроизведения озвученных реплик и управления ходом диалога. Для обычных звуковых эффектов (шаги, выстрелы, звуки UI) всегда используйте `goat_audio_bus`.

### Концепция работы

`goat_voice` выступает в роли "голоса" для системы диалогов.
1.  **Запуск диалога**: Вы вызываете `goat_voice.start_dialogue("id_стартовой_реплики")`.
2.  **Загрузка ресурса**: `goat_voice` автоматически загружает мастер-файл диалога из `res://game/goat/dialogues/goat.dialogue`.
3.  **Поиск реплики**: `DialogueManager` находит реплику по ее ID.
4.  **Озвучка и субтитры**: `goat_voice` ищет аудиофайл, соответствующий `translation_key` реплики в `res://game/goat/voice/`. Если находит — проигрывает его. Одновременно он посылает сигнал `started(text)`, который `Subtitles.tscn` использует для показа субтитров.
5.  **Завершение**: По окончании реплики посылается сигнал `finished(text)`.
6.  **Ответы игрока**: Если у реплики есть варианты ответа, `goat_voice` посылает сигнал `responses(array)`, который `Subtitles.tscn` использует для отображения кнопок с вариантами.

### Ключевые методы и сигналы

- **Методы**:
    - `start_dialogue(dialogue_name: String)`: Начинает диалог из мастер-файла `goat.dialogue`, находя первую реплику по `dialogue_name`.
    - `select_response(response)`: Вызывается UI (сценой `Subtitles`), когда игрок нажимает на кнопку с вариантом ответа.
    - `prevent_default()`: **Очень важный метод.** Предотвращает проигрывание "звука по умолчанию" (см. ниже).
    - `stop()`: Немедленно прекращает проигрывание текущей реплики и таймера. Полезно для реализации пропуска диалога.
    - `is_playing() -> bool`: Возвращает `true`, если в данный момент проигрывается какая-либо часть диалога.
    - `set_default_audio_names(names: Array)`: Устанавливает список ID реплик, которые будут проигрываться как "звук неудачи".
    - `connect_default(trigger_signal: Signal)`: Подключает сигнал (например, неудачное использование предмета) к запуску "звука по умолчанию".

- **Сигналы**:
    - `started(text)`: Посылается в момент начала реплики.
    - `finished(text)`: Посылается при завершении реплики.
    - `responses(responses_array)`: Посылается, когда диалог требует ответа от игрока.

### Система "звуков по умолчанию"

Это механизм для звуковой обратной связи на бессмысленные действия игрока.
-   В `_ready()` `goat_voice` автоматически подключается к сигналам `goat_inventory.item_used` и `goat_interaction.object_activated`.
-   Если игрок, например, пытается использовать несовместимые предметы, срабатывает `item_used`. `goat_voice` планирует проиграть случайный звук из списка "звуков по умолчанию".
-   Если ваше действие имеет **собственный** звуковой отклик (например, звук открытия терминала), вы должны вызвать `goat_voice.prevent_default()`, чтобы отменить проигрывание звука "неудачи".

### Настройка и интеграция

1.  **Регистрация озвучки**:
    *   В файле `.dialogue` задайте для реплики `translation_key` (это ее ID).
    *   Поместите аудиофайл в `res://game/goat/voice/`. Имя файла должно совпадать с `translation_key` (например, `npc_hello.ogg` для ключа `npc_hello`).

2.  **Интеграция с Dialogue Manager**:
    *   В редакторе диалогов (`Dialogue` -> `Characters`), создайте нового персонажа.
    *   В поле `Scene` укажите путь к `res://addons/goat/dialogues/goat_voice_dialogue.tscn`. Этот узел-прослойка будет перенаправлять все вызовы в синглтон `goat_voice`.

### Пример: запуск диалога и пропуск реплики

```gdscript
# В скрипте NPC
func _on_object_activated(object_name, _point):
    if object_name == "friendly_npc" and not goat_voice.is_playing():
        # Запускаем диалог со стартовой реплики "npc_greeting_line"
        goat_voice.start_dialogue("npc_greeting_line")

# В скрипте игрока или глобальном обработчике ввода
func _unhandled_input(event):
    if event.is_action_pressed("skip_dialogue") and goat_voice.is_playing():
        goat_voice.stop()
```

### Пример с `prevent_default()`

```gdscript
# Внутри скрипта InteractiveScreen.gd
func _on_object_activated(object_name, point):
    if object_name != unique_name:
        return

    # Сообщаем goat_voice, что стандартный звук "неудачи" не нужен.
    goat_voice.prevent_default()

    # ... дальнейшая логика обработки клика по экрану ...
```

## Интеграция с настройками

- Громкость музыки и эффектов регулируется через goat_settings:

```gdscript
goat_settings.set_value("sound", "music_volume", 0.8)
goat_settings.set_value("sound", "effects_volume", 0.5)
```

- Изменения применяются мгновенно и сохраняются между сессиями.

## Пример: проиграть звук при активации объекта

```gdscript
func _on_object_activated(object_name, _point):
    if object_name == "door":
        goat_audio_bus.play("res://sounds/door_open.ogg")
```

## Пример: озвучить реплику NPC

```gdscript
goat_voice.play("res://voices/npc_hello.ogg")
```

## Пример: озвученный диалог через DialogueManager

```gdscript
func _on_oa(object_name, _point):
    if object_name == "npc_demo":
        DialogueManager.start_dialogue(load("res://demo/dialogues/npc_demo.dialogue"))
        # В диалоговом ресурсе указывайте путь к аудиофайлу для каждой реплики
```

## Пример: динамическая смена музыки

```gdscript
# Смена фоновой музыки при переходе в новую зону
func _on_zone_entered(zone_name):
    match zone_name:
        "battle":
            goat_audio_bus.play("res://music/battle_theme.ogg")
        "peace":
            goat_audio_bus.play("res://music/peace_theme.ogg")
```

## Пример: проигрывание звука по глобальному событию (EventBus)

```gdscript
eventbus_demo.connect("demo_event", func(data):
    if data == "Ключ добавлен в инвентарь!":
        goat_audio_bus.play("res://sounds/key_pickup.ogg")
)
```

## Пример: плавное затухание музыки

```gdscript
# Плавно уменьшить громкость музыки
var tween = create_tween()
tween.tween_method(
    func(vol): goat_audio_bus.set_volume("GoatMusic", vol),
    goat_settings.get_value("sound", "music_volume"), 0.0, 2.0
)
```

## Best practices
- Используйте goat_audio_bus для всех SFX и музыки, не создавайте AudioStreamPlayer вручную.
- Для диалогов и реплик используйте goat_voice и интеграцию с DialogueManager.
- Все параметры звука выносите в goat_settings для удобства пользователя.
- Организуйте ассеты по папкам: `sounds/`, `music/`, `voices/`.
- Используйте отдельные аудиошины для музыки, эффектов, озвучки.
- Для сложных сценариев используйте сигналы started/finished для синхронизации с геймплеем.
- Для отладки используйте print и push_error при ошибках загрузки аудиофайлов.
