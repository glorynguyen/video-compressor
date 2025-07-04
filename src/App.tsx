import { FFmpeg } from "@ffmpeg/ffmpeg";
import { fetchFile } from "@ffmpeg/util";
import coreURL from "@ffmpeg/core?url";
import wasmURL from "@ffmpeg/core/wasm?url";
import { Compress } from "@cheryx2020/core";
import { Routes, Route, Link } from "react-router-dom";
import NotFound from "./pages/NotFound";
import About from "./pages/About";
import LocalTool from "./pages/LocalTool";
import "/node_modules/@cheryx2020/core/dist/index.css"

function App() {
  return <>
    <div className="container">
      <nav className="navbar navbar-expand-lg navbar-light bg-light">
        <div className="container-fluid">
          <Link className="navbar-brand flex center" to="/">
            <div className="logo"></div>
            <div className="ml-10">Video Compressor</div>
          </Link>

          <button
            className="navbar-toggler"
            type="button"
            data-bs-toggle="collapse"
            data-bs-target="#navbarNav"
            aria-controls="navbarNav"
            aria-expanded="false"
            aria-label="Toggle navigation"
          >
            <span className="navbar-toggler-icon"></span>
          </button>

          <div className="collapse navbar-collapse" id="navbarNav">
            <ul className="navbar-nav ms-auto">
              <li className="nav-item">
                <Link className="nav-link" to="/">
                Compress Video
                </Link>
              </li>
              <li className="nav-item">
                <Link className="nav-link" to="/videotogif">
                Convert to GIF
                </Link>
              </li>
              <li className="nav-item">
                <Link className="nav-link" to="/localtool">
                  Local Tool Guide
                </Link>
              </li>
              <li className="nav-item">
                <Link className="nav-link" to="/about">
                  About
                </Link>
              </li>
            </ul>
          </div>
        </div>
      </nav>

      <Routes>
        <Route path="/" element={<Compress key={Compress.CompressType.COMPRESS} FFmpeg={FFmpeg} fetchFile={fetchFile} coreURL={coreURL} wasmURL={wasmURL} type={Compress.CompressType.COMPRESS}/>} />
        <Route path="/videotogif" element={<Compress key={Compress.CompressType.GIF} FFmpeg={FFmpeg} fetchFile={fetchFile} coreURL={coreURL} wasmURL={wasmURL} type={Compress.CompressType.GIF}/>} />
        <Route path="/about" element={<About />} />
        <Route path="/localtool" element={<LocalTool />} />
        <Route path="*" element={<NotFound />} />
      </Routes>
    </div>
  </>
}

export default App
