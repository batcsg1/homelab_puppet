# immich_kiosk

Deploys [immich-kiosk](https://github.com/damongolding/immich-kiosk) via Docker Compose.
Host needs Docker + compose plugin and a `docker` group. x86_64/arm64 only (no armv7 image).

## Hiera

```yaml
immich_kiosk::immich_url: 'http://immich_server:2283'   # or http://192.168.20.100:2283
immich_kiosk::immich_api_key: >
  ENC[PKCS7,...]                                        # eyaml
immich_kiosk::network: 'immich_default'                 # join Immich's network; omit to use LAN URL
immich_kiosk::image_tag: '0.44.1'
immich_kiosk::settings:
  duration: 60
  albums: ['<album-id>']
  show_date: true
  show_time: true
```

The API key param is `Sensitive`, so convert it in Hiera:

```yaml
lookup_options:
  immich_kiosk::immich_api_key:
    convert_to: 'Sensitive'
```

Classify: `include immich_kiosk`. Kiosk on `http://<host>:3000`.
