# Persönliche Notizen (Neovim)

Hier kannst du wichtige oder oft genutzte Funktionen festhalten. Diese Datei ist nur für dich – kein `:help`-Tag nötig.

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

