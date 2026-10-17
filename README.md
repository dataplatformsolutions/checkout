# Riff checkout action

Create a Riff workspace at the exact revision carried by a dispatch event. The action optionally materializes only the paths in `sparse`.

```yaml
- uses: dataplatformsolutions/checkout@v1
  with:
    server: ${{ vars.RIFF_SERVER }}
    repo: ${{ github.event.client_payload.repo }}
    revision: ${{ github.event.client_payload.revision }}
    token: ${{ secrets.RIFF_TOKEN }}
    sparse: services/api,libs
    path: riff-workspace
```

The runner must have `riff` on `PATH`. To download it at runtime, set `riff-binary-url` to a URL serving the executable. The `path` output is the absolute workspace path.

Inputs: `server`, `repo`, and `revision` are required. `token`, `sparse`, `path`, and `riff-binary-url` are optional.
