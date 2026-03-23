# Persönliche Notizen (Neovim)

Hier kannst du wichtige oder oft genutzte Funktionen festhalten. Diese Datei ist nur für dich – kein `:help`-Tag nötig.

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

## Weitere Hilfe in Neovim

- `:help *`
- `:help word-motions`
- `:help visual-search` (falls verfügbar)

