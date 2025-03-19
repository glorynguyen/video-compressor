# Video Compression and GIF Conversion Script

A simple, cross-platform script to compress video files and convert them to GIFs using `ffmpeg` and `zenity`. The script provides a graphical interface for selecting a video file, performing the desired action, and saving the resulting file.

## Features

- **Cross-platform**: Supports Homebrew (macOS) and APT (Linux) for package management.
- **Graphical Interface**: Uses `zenity` for a simple file selection and progress dialog.
- **Video Compression**: Uses `ffmpeg` to compress videos into `.mov` format with customizable settings.
- **Video to GIF Conversion**: Converts videos to GIFs with customizable frame rates and sizes.
- **Web Version**: A web-based version of the tool is available for online video processing (may be slower due to WebAssembly).

## Prerequisites

Before running the script, ensure that the following dependencies are installed:

- `ffmpeg`: A powerful multimedia processing tool.
- `zenity`: A GTK+ dialog box for creating graphical user interfaces.

### Installation

#### **Run the Script**

No need to manually install dependencies—the script will check for required packages (ffmpeg and zenity) and install them automatically if missing.
Simply execute the script in a terminal:

```bash
chmod +x video_compress.sh
./video_compress.sh
```

If ffmpeg or zenity are not installed, the script will detect the appropriate package manager (Homebrew for macOS, APT for Linux) and install them before proceeding.

### Web Version
I’ve also ported the video compression tool to a web version, which you can use at:
[Video to GIF Converter](https://chopper-vn.web.app/video)

Please note that the web version may take longer to convert due to the use of WebAssembly (WASM) for video processing.