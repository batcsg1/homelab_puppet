# microk8s

Installs MicroK8s via snap, enables addons, adds users to the `microk8s` group,
and provides `microk8s::helm_release` for deploying charts.

## Hiera

```yaml
microk8s::users:
  - batcsg1
microk8s::gpu: true        # GPU nodes only; adds the nvidia addon (host driver)
# microk8s::channel: '1.33/stable'
```

## Deploying a chart

```puppet
microk8s::helm_release { 'myapp':
  chart       => '/opt/myapp-chart',
  values_file => '/opt/myapp-chart/values.yaml',
  subscribe   => File['/opt/myapp-chart/values.yaml'],
}
```
