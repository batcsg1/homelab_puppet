# immich_k8s

Deploys Immich on MicroK8s using the chart in `files/chart/`.
Requires the `microk8s` module.

- `values.yaml` is generated on the node from Hiera (mode 0600); it is not in the chart.
- Secrets: `immich_k8s::db_password`, `immich_k8s::tunnel_token` (eyaml, converted to Sensitive).
- See `examples/` for hiera.yaml, data files and site.pp.

Do NOT apply to a node still running the Compose stack: both would use
`/srv/immich/db`. Stop Compose first or use a test node with restored data.

GPU: `gpu_ml` puts ML on the GPU. `gpu_transcoding` (NVENC) needs GPU Operator
time-slicing, otherwise the app pod stays Pending.

Cloudflare: point the tunnel hostname at `http://app:2283`.
