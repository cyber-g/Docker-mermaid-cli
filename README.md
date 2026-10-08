# Docker mermaid-cli

This repository builds a Docker image based on [`minlag/mermaid-cli:latest`](https://hub.docker.com/r/minlag/mermaid-cli), with GNU `make` added. The image runs Mermaid CLI (`mmdc`) by default.

## Build

Build the image locally:

```sh
docker build -t docker-mermaid-cli .
```

## Use

Mount the directory containing your Mermaid diagram at `/data`, then run `mmdc` directly:

```sh
docker run --rm -v "$PWD:/data" docker-mermaid-cli -i diagram.mmd -o diagram.svg
```

Or use the published Docker Hub image:

```sh
docker run --rm -v "$PWD:/data" drdpham/docker-mermaid-cli:latest -i diagram.mmd -o diagram.svg
```

To run an interactive shell, override the default entrypoint:

```sh
docker run --rm -it -v "$PWD:/data" --entrypoint /bin/sh docker-mermaid-cli
```

### Run Makefile

Run a Makefile in the mounted project directory by overriding the Mermaid CLI entrypoint:

```sh
docker run --rm -v "$PWD:/data" --entrypoint make target_name docker-mermaid-cli
```

### Use in GitLab CI

Override the image entrypoint so the GitLab runner can execute its job shell, then invoke `mmdc` in the `script` section:

The `-p` option points `mmdc` to Puppeteer's JSON configuration, which configures the browser used to render diagrams. The base image's entrypoint actually passes `/puppeteer-config.json`; because GitLab overrides that entrypoint (by setting it to an empty string), pass the option explicitly:

```yaml
render:
  image:
    name: drdpham/docker-mermaid-cli:latest
    entrypoint: [""]
  script:
    - mmdc -p /puppeteer-config.json -i diagram.mmd -o diagram.svg
```

## Maintenance

To enable publishing, add these GitHub repository secrets under **Settings > Secrets and variables > Actions**:

- `DOCKERHUB_USERNAME`: Docker Hub username.
- `DOCKERHUB_TOKEN`: Docker Hub access token with permission to push images.

Add the repository variable `DOCKERHUB_IMAGE` with the Docker Hub image name, for example `your-dockerhub-user/docker-mermaid-cli`.

The GitHub Actions workflow builds the image on pull requests targeting `main` without publishing it. Pushes to `main` publish the `latest` tag, and pushes of version tags such as `v1.0.0` publish the matching version tag.
