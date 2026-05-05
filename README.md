# Company Infra Compose

Docker-Compose-Setup fuer:
- `Nextcloud` mit `PostgreSQL`, `Redis`, `Collabora`
- `coturn` fuer `Nextcloud Talk`
- `Gitea` oeffentlich per HTTPS
- `Caddy` als oeffentlicher Reverse Proxy

## Dateien
- `compose.edge.yml`: `Caddy` und `coturn`
- `compose.nextcloud.yml`: `Nextcloud`, `PostgreSQL`, `Redis`, `Collabora`
- `compose.internal-dev.yml`: `Gitea`, `PostgreSQL`
- `.env.example`: alle benoetigten Variablen

## Vorbereitung
1. `.env.example` nach `.env` kopieren und alle Platzhalter setzen.
2. `company_proxy` Netzwerk anlegen:

```sh
docker network create company_proxy
```

3. DNS anlegen:
   - `cloud.<domain>` auf den Server
   - `office.<domain>` auf den Server
   - `gitea.<domain>` auf den Server
   - optional `turn.<domain>` auf den Server

## Start
Oeffentliche Dienste:

```sh
docker compose -f compose.edge.yml up -d
docker compose -f compose.nextcloud.yml up -d
```

Gitea:

```sh
docker compose -f compose.internal-dev.yml up -d
```

Optionaler Gitea-Admin-User nach dem ersten Start:

```sh
docker compose -f compose.internal-dev.yml --profile setup run --rm gitea-init
```

## Hinweise
- `Gitea` ist ueber `https://gitea.<domain>` erreichbar und selbst nicht direkt per Host-Port exponiert; nur `Caddy` published nach aussen.
- Wenn Git-over-SSH genutzt werden soll, muss Port `2222/tcp` am Host zusaetzlich explizit veroeffentlicht oder separat per Reverse-SSH/Host-SSH geloest werden. Der aktuelle Stack deckt HTTPS-basiertes Git direkt ab.
- `Nextcloud Talk` benoetigt die TURN-Daten aus `.env` spaeter zusaetzlich in der Nextcloud-Adminoberflaeche.
- `Collabora` erwartet `NEXTCLOUD_DOMAIN_REGEX` als escaped Regex, z. B. `cloud\\.example\\.com`.
- Fuer Produktion muessen `GITEA_SECRET_KEY` und `GITEA_INTERNAL_TOKEN` eindeutige, lange Zufallswerte sein.
