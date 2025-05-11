# 🚀 NVIDIA Jetson Builder Container Image

A ready-to-use container image for flashing and customizing NVIDIA Jetson devices using the official L4T release packages.

This image simplifies the flashing process by bundling:

* The **Jetson Linux release package** for a specified L4T version.
* Essential tools and dependencies required to flash and customize Jetson boards.
* A containerized, reproducible environment following NVIDIA's official flashing guide.
* A foundation for CI/CD pipelines and automation of Jetson device customization.

Perfect for robotics engineers and embedded developers working with **Jetson Nano**, **Xavier**, **Orin**, and other Jetson boards.

---

## 🧰 Features

* Downloads and unpacks the official **Jetson Linux L4T release package**.
* Includes all dependencies to run `l4t_flash_prerequisites.sh`.
* Suitable for scripting and automation in CI/CD or development pipelines.
* Supports container-based development without polluting your host system.

**IMPORTANT: Changes inside the container are not persistent.**

## 🔧 Usage
Run the container to access a consistent Jetson flashing environment with all necessary tools and dependencies preinstalled. You can use it interactively or within automation pipelines.

### Example: Enter the Container With Jetson Release Workspace
This will create a container with the Jetson Release contents available at `/workspace` (default folder). Inside the container, you can run the `./flash.sh` script and other tools as needed.

```bash
The container will be removed after exiting.
```bash
docker run -it --rm \
  --privileged \
  --network host \
  -v /dev/bus/usb:/dev/bus/usb/ \
  -v /dev:/dev \
  ghcr.io/getdevopspro/jetson-linux-builder:36.4.3
```

### Example: Create a Sample RootFS
This will create a minimal sample rootfs from L4t scripts. It will be saved at `.shared/sample_fs-jammy-minimal.tbz2` of the current directory.
```bash
mkdir -p .shared
docker run --rm \
        --name build-rootfs-36.4.3-minimal \
        --privileged \
        --network host \
        -v /var/home/job/mydata/myrepos/jetson-linux-rootfs/.shared:/workspace/shared \
        --workdir /workspace/tools/samplefs \
        --platform linux/amd64 \
        ghcr.io/getdevopspro/jetson-linux-builder:36.4.3 bash -xc \
                'sed -i "s@arch | grep .*@arch | grep \"$(arch)\")\"@" nv_build_samplefs.sh; \
                sudo bash -x ./nv_build_samplefs.sh \
                --abi aarch64 \
                --distro ubuntu \
                --flavor minimal \
                --version jammy; \
                chown 1000 sample_fs.tbz2; \
                mv sample_fs.tbz2 /workspace/shared/sample_fs-jammy-minimal.tbz2'
```

## 🙌 Contributing

Contributions are welcome! Whether it's a bug report, feature request, or a pull request — we'd love your input to make this project better.

## 🙏 Acknowledgements

This project references and uses software from officially and publicly available resources provided by NVIDIA, including the Jetson Linux L4T release packages and associated tools. It also relies on Ubuntu and other open source components.
While this container is designed to simplify the use of these tools, it is not an official NVIDIA project and is not affiliated with or endorsed by NVIDIA.

All trademarks and registered trademarks are the property of their respective owners.
