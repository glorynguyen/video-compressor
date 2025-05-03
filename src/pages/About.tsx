import { useNavigate } from "react-router-dom";

const About = () => {
    const navigate = useNavigate();    
    return (
      <div className="container mt-5">
        <div className="row justify-content-center">
          <div className="col-md-8">
            <div className="card shadow-lg border-0">
              <div className="card-body p-4">
                <h1 className="card-title text-center mb-4">About Video Compressor</h1>
                <p className="card-text">
                  <strong>Video Compressor</strong> is a lightweight and powerful web-based tool designed 
                  to efficiently compress video files directly in your browser.  
                  This tool is built by <strong>
                    <a 
                      href="https://www.linkedin.com/in/vinh-nguyen-479781130/" 
                      className="fw-bold text-decoration-none" 
                      target="_blank" 
                      rel="noopener noreferrer"
                    >
                      Vinh Nguyen
                    </a>
                  </strong>, utilizing <a 
                  href="https://www.ffmpeg.org/" 
                  className="fw-bold text-decoration-none" 
                  target="_blank" 
                  rel="noopener noreferrer"
                >
                  FFmpeg
                </a> compiled to 
                  <strong> WebAssembly (WASM)</strong>, eliminating the need for server-side processing.
                </p>
                <p className="card-text">
                  With <strong>FFmpeg WASM</strong>, Video Compressor allows users to reduce video sizes while 
                  maintaining quality, making it ideal for quick video optimizations without requiring 
                  software installation.
                </p>
                <div className="text-center">
                  <button onClick={() => navigate("/")} className="btn btn-primary px-4 py-2">
                    Try Video Compressor
                  </button>
                </div>
              </div>
            </div>
            <div className="text-center mt-4">
              <small className="text-muted">
                Developed with ❤️ by <strong>
                  <a 
                    href="https://www.linkedin.com/in/vinh-nguyen-479781130/" 
                    className="text-muted text-decoration-none" 
                    target="_blank" 
                    rel="noopener noreferrer"
                  >
                    Vinh Nguyen
                  </a>
                </strong>
              </small>
            </div>
          </div>
        </div>
      </div>
    );
  };
  
  export default About;