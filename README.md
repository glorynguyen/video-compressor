# Video Compressor

Video Compressor is a lightweight and powerful web-based tool designed to efficiently compress video files directly in your browser. It leverages **FFmpeg** compiled to **WebAssembly (WASM)**, eliminating the need for server-side processing and ensuring user privacy by keeping all operations local to the browser.

## Features

- **Browser-Based Compression**: Compress video files directly in your browser without uploading them to a server.
- **FFmpeg WASM Integration**: Built with **FFmpeg WASM** for fast and efficient video processing.
- **No Installation Required**: Works entirely in the browser, requiring no additional software installation.
- **High-Quality Compression**: Reduces video file sizes while maintaining high-quality output.
- **Multi-Format Support**: Supports a wide range of video formats for compression and conversion.
- **Format Conversion**: Convert videos between formats directly in the browser.
- **Audio Extraction**: Extract audio tracks from video files.
- **Custom FFmpeg Commands**: Run custom FFmpeg commands for advanced video processing.
- **FFmpeg Options Panel**: Expose full FFmpeg options through an interactive panel.
- **Local Tool Option**: Includes a script for offline video compression and GIF conversion on macOS and Linux.

## How to Use

### Online Tool

The web app provides the following tools accessible from the navigation bar:

| Route | Feature | Description |
|-------|---------|-------------|
| `/` | Compress Video | Compress video files using H.264 with adjustable quality settings |
| `/videotogif` | Convert to GIF | Convert video files to animated GIFs |
| `/convert` | Convert Format | Convert videos between different formats |
| `/audio` | Extract Audio | Extract audio tracks from video files |
| `/custom` | Custom FFmpeg | Run custom FFmpeg commands for advanced processing |
| `/localtool` | Local Tool Guide | Documentation for the offline bash script |

**Basic usage:**

1. Navigate to the desired tool using the top navigation bar.
2. Upload your video file using the file selection interface.
3. Adjust processing settings using the FFmpeg options panel as needed.
4. Download the output file when processing is complete.

### Local Tool

For users who prefer an offline solution, the `video_compress.sh` script is available. This script allows you to compress videos or convert them to GIFs on macOS or Linux.

#### Steps to Use the Local Tool:

1. Download the script from the [GitHub repository](https://github.com/glorynguyen/video-compressor/blob/main/video_compress.sh) or use `curl`:
   ```bash
   curl -O https://raw.githubusercontent.com/glorynguyen/video-compressor/main/video_compress.sh
   ```
2. Make the script executable:
   ```bash
   chmod +x video_compress.sh
   ```
3. Run the script:
   ```bash
   ./video_compress.sh
   ```
4. Follow the on-screen prompts to compress videos or convert them to GIFs.

## Prerequisites for Local Tool

- **Dependencies**:
  - `ffmpeg`: Used for video compression and conversion.
  - `zenity`: Provides graphical dialogs for user interaction.
- The script will automatically install these tools if they are not already installed, using either Homebrew (macOS) or APT (Linux).

## About the Developer

This tool was developed with ❤️ by [Vinh Nguyen](https://www.linkedin.com/in/vinh-nguyen-479781130/). You can connect with him on LinkedIn for more information about his work and other projects.

## Technologies Used

- **React 18**: For building the user interface.
- **TypeScript**: For type-safe development.
- **Vite**: For fast development and production builds.
- **FFmpeg WASM**: For client-side video processing in the browser.
- **@cheryx2020/core 1.4.0**: Compression UI component with FFmpeg options panel.
- **Bootstrap 5**: For responsive and modern styling.
- **React Router DOM**: For client-side navigation and routing.
- **Zenity**: For graphical dialogs in the local tool.
- **Firebase Hosting**: For deploying and hosting the web application.

## Local Tool Features

### Compressing a Video

1. Select the **Compress Video** option from the menu.
2. Choose a video file using the file selection dialog.
3. The script will compress the video and save it with `_compressed` appended to the filename in the same directory.

### Converting a Video to GIF

1. Select the **Convert Video to GIF** option from the menu.
2. Choose a video file using the file selection dialog.
3. The script will convert the video to a GIF and save it in the same directory.

### Converting Images to WebP

1. Select the **Convert Images to WebP** option from the menu.
2. Choose one or more image files (JPG, JPEG, PNG, GIF, BMP) using the file selection dialog.
3. The script will convert each image to WebP format and save the output alongside the original.

### Setting Up a Shell Alias

1. Select the **Setup Alias** option from the menu.
2. Enter a name for the alias (default: `vtool`).
3. The script adds the alias to your shell config (`~/.zshrc`, `~/.bashrc`, or `~/.bash_profile`).
4. Reload your shell config (e.g., `source ~/.zshrc`) to activate the alias.

### Notes

- The script uses `zenity` for graphical dialogs. Ensure `zenity` is installed and working correctly.
- On macOS, the script will automatically open the output directory after processing.

## macOS Quick Action (Automator)

You can add a **right-click Quick Action** in Finder so you can compress videos, convert to GIF, or convert images to WebP without opening a terminal.

### Prerequisites

- macOS 12 or later
- FFmpeg installed via Homebrew (`brew install ffmpeg`)

### Setup Steps

1. Open **Automator** (search for it in Spotlight or find it in `/Applications`).
2. Click **New Document**, then select **Quick Action** and click **Choose**.
3. At the top of the workflow, configure:
   - **Workflow receives current**: `files or folders`
   - **in**: `Finder`
4. In the left sidebar, search for **Run Shell Script** and drag it into the workflow area.
5. In the Run Shell Script action, set:
   - **Shell**: `/bin/bash`
   - **Pass input**: `as arguments`
6. Replace the default script content with the contents of [`video_compress_automator.sh`](./video_compress_automator.sh).
7. Go to **File → Save**, name it **Video & Image Tool**, and close Automator.

The Quick Action is now installed at `~/Library/Services/Video & Image Tool.workflow`.

### How to Use

1. In Finder, select one or more files.
2. **Right-click** → **Quick Actions** → **Video & Image Tool**.
3. Choose an action from the dialog (Compress Video, Convert to GIF, or Convert to WebP).
4. A notification will appear when processing is complete.

### Distributing to Other Macs

**Method 1: Double-click install**

Send the `Video & Image Tool.workflow` folder (from `~/Library/Services/`) to another user. When they double-click it, macOS will prompt them to install it automatically.

**Method 2: Shell script installer**

1. Copy the `.workflow` out of `~/Library/Services/` into a folder.
2. Add an `install.sh` alongside it:
   ```bash
   #!/bin/bash
   WORKFLOW_NAME="Video & Image Tool.workflow"
   SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
   TARGET_DIR="$HOME/Library/Services"

   if [ ! -d "$SCRIPT_DIR/$WORKFLOW_NAME" ]; then
     echo "Error: Cannot find '$WORKFLOW_NAME' next to this script."
     exit 1
   fi

   mkdir -p "$TARGET_DIR"
   cp -R "$SCRIPT_DIR/$WORKFLOW_NAME" "$TARGET_DIR/"
   killall pbs 2>/dev/null

   echo "Installed! Right-click a file in Finder → Quick Actions → Video & Image Tool."
   ```
3. Zip the folder and distribute. Recipients unzip and run `bash install.sh`.

## Development

1. Pull repository
2. Install dependencies and start the dev server:
   ```bash
   yarn install
   yarn dev
   ```

**Other commands:**
```bash
yarn build    # Type-check and build for production
yarn lint     # Run ESLint on source files
yarn preview  # Preview the production build locally
yarn deploy   # Build and deploy to Firebase
```

## Deployment

The web application is deployed using Firebase Hosting. The deployment process is automated via a GitHub Actions workflow. The workflow builds the project and deploys it to Firebase Hosting upon a push to the `main` branch.

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.
