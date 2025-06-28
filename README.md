# Video Compressor

Video Compressor is a lightweight and powerful web-based tool designed to efficiently compress video files directly in your browser. It leverages **FFmpeg** compiled to **WebAssembly (WASM)**, eliminating the need for server-side processing and ensuring user privacy by keeping all operations local to the browser.

## Features

- **Browser-Based Compression**: Compress video files directly in your browser without uploading them to a server.
- **FFmpeg WASM Integration**: Built with **FFmpeg WASM** for fast and efficient video compression.
- **No Installation Required**: Works entirely in the browser, requiring no additional software installation.
- **High-Quality Compression**: Reduces video file sizes while maintaining high-quality output.
- **Multi-Format Support**: Supports a wide range of video formats for compression and conversion.
- **Local Tool Option**: Includes a script for offline video compression and GIF conversion on macOS and Linux.

## How to Use

### Online Tool

1. Navigate to the homepage of the Video Compressor.
2. Upload your video file using the provided interface.
3. Adjust compression settings as needed.
4. Download the compressed video file.

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

- **React**: For building the user interface.
- **FFmpeg WASM**: For video compression and conversion in the browser.
- **Bootstrap**: For responsive and modern styling.
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

### Notes

- The script uses `zenity` for graphical dialogs. Ensure `zenity` is installed and working correctly.
- On macOS, the script will automatically open the output directory after processing.

## Development
1. Pull repository
2. At the local run
   ```bash
   npm i && npm run dev
   ```

## Deployment

The web application is deployed using Firebase Hosting. The deployment process is automated via a GitHub Actions workflow. The workflow builds the project and deploys it to Firebase Hosting upon a push to the `main` branch.

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.
