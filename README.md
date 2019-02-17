# Docker image hugojosefson/goland

Runs Jetbrains GoLand, in as much isolation, or as little, as you
wish.

## Usage

This docker image must be started as `root`, so don't use `docker
run --user=...`. Instead,  pass environment variables `USER_NAME`,
`USER_ID`, `GROUP_NAME`, `GROUP_ID` (and optionally `HOME`) for the
user you want to become.

Example which runs gives GoLand access to the current directory, but
not your actual `HOME` on your host.

```bash
# Create a new temp directory to hold the user HOME inside the container
GOLAND_HOME=$(mktemp -d) # (or use another specific directory)

# Run GoLand using in the current directory, as yourself, with config
# saved in the new HOME
docker run --rm -it \
  --env USER_ID="$(id -u)" \
  --env USER_NAME="$(id -un)" \
  --env GROUP_ID="$(id -g)" \
  --env GROUP_NAME="$(id -gn)" \
  --env HOME="${HOME}" \
  --volume "${GOLAND_HOME}":"${HOME}" \
  --env WEBIDE_VM_OPTIONS="-Duser.home=${HOME}" \
  --volume /tmp/.X11-unix:/tmp/.X11-unix \
  --env DISPLAY="unix${DISPLAY}" \
  --volume "$(pwd)":"$(pwd)" \
  --workdir "$(pwd)" \
  hugojosefson/goland goland $(pwd)
```

## License

MIT
