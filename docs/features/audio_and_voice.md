# 3.7. Работа со звуком и озвучкой

GOAT предоставляет централизованную систему для работы со звуками (SFX, музыка) и озвучкой реплик через синглтоны goat_audio_bus и goat_voice.

## Архитектура

- **goat_audio_bus** — глобальный менеджер для проигрывания звуковых эффектов и музыки, управления громкостью и эффектами.
- **goat_voice** — система для проигрывания озвучки реплик, диалогов и событий.
- **Интеграция с goat_settings** — громкость и параметры звука настраиваются через меню настроек.

## Проигрывание звуков через goat_audio_bus

- Для проигрывания звука используйте:

```gdscript
goat_audio_bus.play("res://path/to/sound.ogg")
```

- Для управления громкостью используйте:

```gdscript
goat_audio_bus.set_volume("GoatEffects", 0.5) # 0.0 — тише, 1.0 — громче
```

- Все звуки автоматически маршрутизируются на нужные аудиошины (Music, Effects).

## Озвучка и диалоги через goat_voice

- Для проигрывания озвучки используйте:

```gdscript
goat_voice.play("res://path/to/voice.ogg")
```

- Для запуска озвученного диалога:

```gdscript
goat_voice.start_dialogue("dialogue_id")
```

- goat_voice автоматически блокирует управление игроком на время реплики (если требуется).
- Сигналы:
    - `started(audio_name)` — озвучка началась
    - `finished(audio_name)` — озвучка завершена

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
