# Persönliche Notizen (Neovim)

Hier kannst du wichtige oder oft genutzte Funktionen festhalten. Diese Datei ist nur für dich – kein `:help`-Tag nötig.

---

## Colorscheme wechseln

**Installiert:** `tokyonight` (Standard) + `catppuccin`

**Wechseln:**
- **Temporär:** `:colorscheme catppuccin` (oder `tokyonight-night`, `tokyonight-day`, `tokyonight-storm`)
- **Mit Preview:** `<leader>st` (Telescope colorscheme picker)
- **Permanent:** In `lua/plugins/ui.lua` die Zeile `vim.cmd.colorscheme '...'` ändern

**Catppuccin-Varianten:** `catppuccin-latte` (light), `catppuccin-frappe`, `catppuccin-macchiato`, `catppuccin-mocha` (dark)

---

## Terminal (toggleterm)

| Taste | Bedeutung |
|--------|-----------|
| `<leader>tt` | Terminal **unten** (horizontal) ein-/ausblenden (gleiche Shell-Session bleibt) |
| `<leader>tv` | Terminal **rechts** (vertikal) |
| `<leader>tF` | Terminal als **schwebendes** Fenster (Großbuchstabe **F**, damit kein Konflikt mit TypeScript `<leader>tf`) |
| `<Esc><Esc>` | Aus dem Terminal-„Einfügen“-Modus in den normalen Modus (Neovim) |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Im Terminal-Modus: **Fokus** zu anderen Fenstern (wie sonst auch) |

**Hinweis:** Toggle blendet nur aus — die Shell läuft weiter, bis du `exit` tippst. Neo-tree: `<leader>tg` / `<leader>tS` bleiben frei (keine Kollision mit `tt`).

---

## Suche & Wort unter dem Cursor

| Taste | Bedeutung |
|--------|-----------|
| `*` | Vorwärts nach dem **ganzen Wort** unter dem Cursor (wie `\<wort\>`) |
| `#` | Dasselbe **rückwärts** |
| `g*` | Vorwärts, auch **Teiltreffer** in längeren Wörtern |
| `g#` | Rückwärts, Teiltreffer |

Nach `*` / `#`: **`n`** = nächster Treffer, **`N`** = vorheriger Treffer.

---

## Markierten Text suchen (Visual)

1. **Neovim:** Text im **Visual-Modus** markieren, dann **`*`** (Stern) – sucht die Markierung vorwärts.
2. **Alternative:** Markieren → **`y`** (yank) → **`/`** → **`Ctrl+r`** dann **`"`** (Register `0` = letzter Yank) – Suchzeile enthält den Text. Bei Sonderzeichen ggf. **`/\V`** für „fast literal“ nutzen, dann **`Ctrl+r`** **`"`**.

---

## Git-Navigation & Diff

**Alle Git-Befehle unter `<leader>g`:**

| Taste | Bedeutung |
|--------|-----------|
| `]g` / `[g` | Nächste/vorherige Git-Änderung (Hunk) |
| `<leader>gl` | **LazyGit** – Öffnet LazyGit Terminal-UI |
| `<leader>gp` | **Preview hunk** – Zeigt Diff der aktuellen Änderung in Popup (schließt mit beliebiger Taste) |
| `<leader>gd` | **Diff** – Öffnet Split mit kompletter Datei-Diff gegen Index (schließen: `:q` oder `<C-w>c`) |
| `<leader>gD` | **Diff** – Öffnet Split mit Diff gegen letzten Commit (schließen: `:q` oder `<C-w>c`) |
| `<leader>gb` | **Blame line** – Zeigt Commit-Info für aktuelle Zeile |
| `<leader>gs` | **Stage hunk** – Staged die aktuelle Änderung |
| `<leader>gr` | **Reset hunk** – Verwirft die aktuelle Änderung |
| `<leader>gS` | **Stage buffer** – Staged die ganze Datei |
| `<leader>gR` | **Reset buffer** – Verwirft alle Änderungen der Datei |
| `<leader>gu` | **Undo stage** – Macht letztes Staging rückgängig |
| `<leader>tb` | **Toggle blame** – Zeigt Blame inline (toggle) |
| `<leader>tD` | **Toggle inline diff** – Zeigt gelöschte Zeilen inline |

**Tipp:** Nach `<leader>gd` oder `<leader>gD` bist du im Diff-Split. Um zurück zur Original-Datei zu kommen:
- **`:q`** – Schließt den aktuellen Split (Diff verschwindet)
- **`<C-w>c`** – Schließt das aktuelle Fenster (gleiches wie `:q`)
- **`<C-w>w`** – Wechselt zwischen den Splits (falls du beide sehen willst)

---

## Neo-tree: Projektweite Fehler (workspace-diagnostics)

**Was es tut:** Neo-tree zeigt **LSP-Fehler** (rote Icons) für **alle** Dateien im Projekt, nicht nur für geöffnete Buffer. Das Plugin sendet `textDocument/didOpen` an gopls für alle `.go`-Dateien (via `git ls-files`), ohne sie wirklich zu öffnen.

**Wichtig:** Beim ersten Start nach Refactoring kann es **1–2 Sekunden** dauern, bis gopls alle Dateien analysiert hat. Danach siehst du in Neo-tree, welche Dateien Fehler haben (z. B. nach Import-Path-Änderungen).

**Manuelle Aktualisierung:** Falls Neo-tree die Fehler nicht sofort zeigt, kurz `:e` (Datei neu laden) oder `:LspRestart gopls`.

---

## Go: Auto-Imports

**Automatisch beim Speichern:** Gopls führt **`organizeImports`** aus → **fehlende Imports** werden hinzugefügt, **ungenutzte** entfernt (wie `goimports`). Passiert vor dem Formatting (conform.nvim).

**Manuell:** Code Action (`gra` in Visual/Normal) → „Organize Imports" auswählen (falls du es vor dem Speichern testen willst).

---

## LazyGit: Syntax-Highlighting in Diffs

**Was es tut:** Diffs in LazyGit zeigen **farbigen Code** (Syntax-Highlighting via **delta**) statt nur grün/rot. Grüne/rote **Plus/Minus** am Rand bleiben, aber der Code selbst ist lesbar (Keywords, Strings, etc. farbig).

**Setup:**
1. **Delta installieren:** `brew install git-delta`
2. **Configs (alle in `~/.config/`):**
   - **LazyGit:** `~/.config/lazygit/config.yml` (symlinked zu macOS-Pfad)
   - **Delta:** `~/.config/delta/config` (Theme, Farben — gilt auch für `git diff` im Terminal)
3. **Light/Dark Mode wechseln:** In LazyGit **`|`** (Pipe) drücken → wechselt zwischen:
   - **Light Mode** (sehr subtile Pastellfarben: fast weiß mit Hauch Rot/Grün)
   - **Dark Mode** (gedämpfte dunkle Hintergründe: `#2d1515` Rot, `#152d15` Grün)
4. **Theme anpassen:** In `~/.config/lazygit/config.yml` die `pager`-Zeilen editieren.
   - Verfügbare Themes: `delta --list-syntax-themes`
   - Beliebte: `GitHub` (light), `Catppuccin Mocha` (dark), `Nord`, `Dracula`

**Limitation:** Im **Hunk-Staging-Modus** (Enter drücken, um einzelne Zeilen zu stagen) nutzt LazyGit den eingebauten Viewer → **kein** Syntax-Highlighting (technische Einschränkung von LazyGit).

---

## Weitere Hilfe in Neovim

- `:help *`
- `:help word-motions`
- `:help visual-search` (falls verfügbar)

