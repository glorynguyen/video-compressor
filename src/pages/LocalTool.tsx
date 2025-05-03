import { useNavigate } from "react-router-dom";

const LocalTool = () => {
  const navigate = useNavigate();

  return (
    <div className="container mt-5">
      <div className="row justify-content-center">
        <div className="col-md-8">
          <div className="card shadow-lg border-0">
            <div className="card-body p-4">
              <h1 className="card-title text-center mb-4">Local Tool Guide</h1>
              <p className="card-text">
                This guide will help you run the <code>video_compress.sh</code> script to compress videos or convert them to GIFs on macOS or Linux.
              </p>
              <p>
                You can find the script on GitHub:{" "}
                <a
                  href="https://github.com/glorynguyen/video-compressor/blob/main/video_compress.sh"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  video_compress.sh
                </a>
              </p>
              <p>
                Alternatively, you can download and run the script directly using <code>curl</code>:
              </p>
              <pre>
                <code>
                  curl -O https://raw.githubusercontent.com/glorynguyen/video-compressor/main/video_compress.sh
                </code>
              </pre>
              <p>
                This method allows you to quickly fetch and execute the script without manually cloning the repository.
              </p>
              <h3>Prerequisites</h3>
              <ol>
                <li>
                  <strong>Ensure you have the required dependencies installed:</strong>
                  <ul>
                    <li><code>ffmpeg</code>: Used for video compression and conversion.</li>
                    <li><code>zenity</code>: Provides graphical dialogs for user interaction.</li>
                  </ul>
                  <p>The script will automatically install these tools if they are not already installed, using either Homebrew (macOS) or APT (Linux).</p>
                </li>
                <li>
                  <strong>Make the script executable:</strong>
                  <pre><code>chmod +x video_compress.sh</code></pre>
                </li>
              </ol>
              <h3>Running the Script</h3>
              <ol>
                <li>Open a terminal.</li>
                <li>Navigate to the script's directory:
                  <pre><code>cd /path/to/video-compressor</code></pre>
                </li>
                <li>Run the script:
                  <pre><code>./video_compress.sh</code></pre>
                </li>
              </ol>
              <h3>Using the Script</h3>
              <p>When you run the script, a graphical menu will appear with the following options:</p>
              <ul>
                <li><strong>Compress Video:</strong> Select this option to compress a video file.</li>
                <li><strong>Convert Video to GIF:</strong> Select this option to convert a video file to a GIF.</li>
                <li><strong>Exit:</strong> Exit the script.</li>
              </ul>
              <h4>Compressing a Video</h4>
              <ol>
                <li>Select <strong>Compress Video</strong>.</li>
                <li>Choose a video file using the file selection dialog.</li>
                <li>The script will compress the video and save it with <code>_compressed</code> appended to the filename in the same directory.</li>
              </ol>
              <h4>Converting a Video to GIF</h4>
              <ol>
                <li>Select <strong>Convert Video to GIF</strong>.</li>
                <li>Choose a video file using the file selection dialog.</li>
                <li>The script will convert the video to a GIF and save it in the same directory.</li>
              </ol>
              <h3>Notes</h3>
              <ul>
                <li>The script uses <code>zenity</code> for graphical dialogs. If you encounter issues, ensure <code>zenity</code> is installed and working correctly.</li>
                <li>On macOS, the script will automatically open the output directory after processing.</li>
              </ul>
              <div className="text-center mt-4">
                <button onClick={() => navigate("/")} className="btn btn-primary px-4 py-2">
                  Back to Home
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LocalTool;