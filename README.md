# 🚀 NVIDIA Jetson Builder Container Image

A ready-to-use container image for flashing and customizing NVIDIA Jetson devices using the official L4T release packages.

This image simplifies the flashing process by bundling:

* The **Jetson Linux release package** for a specified L4T version.
* Essential tools and dependencies required to flash and customize Jetson boards.
* A containerized, reproducible environment following NVIDIA's official flashing guide.

Perfect for robotics engineers and embedded developers working with **Jetson Nano**, **Xavier**, **Orin**, and other Jetson boards.

---

## 🧰 Features

* Downloads and unpacks the official **Jetson Linux L4T release package**.
* Includes all dependencies to run `l4t_flash_prerequisites.sh`.
* Suitable for scripting and automation in CI/CD or development pipelines.
* Supports container-based development without polluting your host system.

**IMPORTANT: Changes inside the container are not persistent.**

## 🔧 Usage

### Example: Enter the container
```bash
docker run -it --rm \
  --privileged \
  --network host \
  -v /dev/bus/usb:/dev/bus/usb/ \
  -v /dev:/dev \
  ghcr.io/getdevopspro/jetson-linux-builder:36.4.3
```
