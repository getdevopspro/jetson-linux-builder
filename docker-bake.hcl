// docker-bake.hcl
variable "IMAGE_NAME" {
  default = "ghcr.io/getdevopspro/jetson-linux-builder"
}

variable "JETSON_VERSIONS" {
  # IMPORTANT: latest always be the first element in the list
  default = [
    {
      ubuntu_release = "jammy"
      number         = "36.4.3"
    },
    {
      ubuntu_release = "focal"
      number         = "35.6.1"
    },
  ]
}

target "docker-metadata-action" {}

target "build" {
  inherits   = ["docker-metadata-action"]
  context    = "./"
  dockerfile = "Dockerfile"
  name       = "${replace(sanitize(IMAGE_NAME), "_", "-")}-${replace(sanitize(jetson_version.number), "_", "-")}"
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  matrix = {
    jetson_version = JETSON_VERSIONS
  }
  args = {
    JETSON_VERSION       = jetson_version.number,
    JETSON_VERSION_MAJOR = split(".", jetson_version.number)[0],
    JETSON_VERSION_MINOR = split(".", jetson_version.number)[1],
    JETSON_VERSION_PATCH = split(".", jetson_version.number)[2],
    ARG_IMAGE_FROM       = "docker.io/ubuntu:${jetson_version.ubuntu_release}",
  }
  tags = concat(
    jetson_version.number == JETSON_VERSIONS[0].number ? ["${IMAGE_NAME}:latest"] : [],
    [
      "${IMAGE_NAME}:${split(".", jetson_version.number)[0]}",
      "${IMAGE_NAME}:${split(".", jetson_version.number)[0]}.${split(".", jetson_version.number)[1]}",
      "${IMAGE_NAME}:${jetson_version.number}",
      "${IMAGE_NAME}:${jetson_version.number}-${formatdate("YYYYMMDDhhmm", timestamp())}",
    ]
  )
  labels = {
    "manifest:org.opencontainers.image.version" : jetson_version.number
    "org.opencontainers.image.version" = jetson_version.number
  }
}
