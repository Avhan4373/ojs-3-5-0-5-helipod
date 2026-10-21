# OJS 3.5.0-5 — deploy Helipod

Image deploy OJS (Open Journal Systems) 3.5.0-5 ke Helipod.

- Base image: `pkpofficial/ojs:3_5_0-5` (PHP 8.3 + Apache).
- `overlay/` berisi kustomisasi lokal: plugin `blocks/sidebarCards`, theme
  `academic`, template `frontend/components/footer.tpl`, file locale `id` dan
  patch `lib/pkp/classes/publication/PKPPublication.php`.
- `config.inc.php.template` adalah konfigurasi OJS dengan placeholder yang
  diisi oleh `ojs-entrypoint.sh` saat container start.
- `ojs-entrypoint.sh` menunggu MySQL, mengimpor dump database (sekali saja),
  memulihkan file terpublikasi ke volume `public/`, lalu menjalankan Apache.

## Environment variables

| Key | Keterangan |
| --- | --- |
| `OJS_BASE_URL` | URL publik, mis. `https://ojs.helipod.app` |
| `OJS_APP_KEY` | `app_key` OJS (base64) |
| `OJS_TIME_ZONE` | mis. `Asia/Jakarta` |
| `OJS_ALLOWED_HOSTS` | JSON array, mis. `["ojs.helipod.app"]` |
| `OJS_REPOSITORY_ID` | repository id OJS |
| `DB_HOST` | host MySQL (private domain service MySQL) |
| `DB_USER` / `DB_PASSWORD` / `DB_NAME` | kredensial database |
| `SEED_DB_FILE` | path dump SQL (default `/seed/ojs-db.sql.gz`) |
| `SEED_PUBLIC_FILE` | path arsip file terpublikasi (default `/seed/ojs-public.tar.gz`) |

## Secret files (write-only)

- `/seed/ojs-db.sql.gz` — dump database OJS.
- `/seed/ojs-public.tar.gz` — arsip `public/journals` (cover image, PDF galley).
