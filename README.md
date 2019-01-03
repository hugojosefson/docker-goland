# Docker image hugojosefson/webstorm

Runs Jetbrains WebStorm.

## Usage

```bash
docker run --rm -it \
  --volume "$(pwd)":"$(pwd)" \
  --workdir "$(pwd)"
  --user $(id -u):$(id -g) \
  hugojosefson/webstorm .
```

## License

MIT