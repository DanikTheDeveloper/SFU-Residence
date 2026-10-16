# SFU Residences 3D — быстрый старт (Debian / WSL2)

## Что уже считается установленным
Из ваших слов: WSL2 с Debian, Godot **4.7.2 Standard без .NET**, GDScript, Codex (GPT-6 Astra), Compatibility renderer. **Наличие дополнительных утилит неизвестно** — установщик не должен повторно ставить то, что уже работает.

## 1. Распаковать ZIP в Linux-файловую систему Debian
Откройте **Debian Terminal** (не PowerShell для этих команд). Если ZIP скачан в Windows `Downloads`:

```bash
mkdir -p ~/projects
# Вставьте реальный путь к ZIP в Windows Downloads, если отличается.
# Например, замените YOUR_WINDOWS_USER на имя пользователя Windows:
cp /mnt/c/Users/YOUR_WINDOWS_USER/Downloads/SFU_Residences_Codex_WSL2_Godot472_OnlineAPI.zip ~/projects/
cd ~/projects
unzip -o SFU_Residences_Codex_WSL2_Godot472_OnlineAPI.zip
cd SFU_Residences_Codex_WSL2_Godot472_OnlineAPI
```

Если ZIP уже распакован в Debian, переходите в корневую папку проекта (`AGENTS.md` должен быть здесь).

## 2. Проверить инструменты — без установки
```bash
bash scripts/wsl_diagnostics.sh
```

Показатель `OpenGL renderer string: D3D12 (NVIDIA ...)` говорит, что WSLg/Mesa использует NVIDIA; `llvmpipe` — программный рендеринг, низкая производительность. Если `glxinfo` отсутствует: `sudo apt update && sudo apt install mesa-utils`. Если Godot не находится командой `godot`/`godot4`, см. `docs/14_SETUP_AND_INSTALL.md` — у вас может быть установлен Godot под другим именем.

## 3. Открыть эту папку в Codex
В корне проекта передайте Codex инструкцию из `CODEX_TASK_PROMPT.md`. Codex должен изучить **все docs**, проверить окружение, создать `game/`, запустить проект и документировать результат. Текущая фаза: **ТОЛЬКО здания снаружи и прогулка**. Без NPC, API-ключей и онлайн-запросов.

## 4. Запустить результат
После того как Codex создал `game/project.godot`:
```bash
bash scripts/smoke_test.sh
# Если графика WSLg работает и исполняемый файл называется godot:
godot --path game --rendering-method gl_compatibility
```
Если Godot под именем `godot4` либо его путь задан `GODOT_BIN`, используйте `GODOT_BIN=/path/to/Godot bash scripts/smoke_test.sh`.

## 5. Если Godot запускается очень медленно
Сначала проверьте `glxinfo -B`, `/dev/dxg`, драйвер NVIDIA в Windows, WSLg и наличие `llvmpipe`. Современная видеокарта в Windows **не доказывает** её использование Godot внутри WSL. См. `docs/16_WSLG_GPU_TROUBLESHOOTING.md`.

## Что нужно установить?
**До проверки окружения нельзя точно знать.** Скорее всего достаточно `git`, `python3` (для проверок/импорта OSM), `unzip`, `curl` и `mesa-utils`, *если они отсутствуют*. Godot у вас уже есть по вашим словам; **не ставьте его снова просто по инструкции**. Blender, .NET, Unity, Vulkan SDK, Node.js, Docker и локальные LLM для этой задачи не нужны.
