# Video Compressor - Knowledge Base

## Project Overview

**Video Compressor** is a lightweight, web-based video compression tool that processes videos directly in the browser using FFmpeg compiled to WebAssembly (WASM). It eliminates the need for server-side processing, ensuring complete user privacy by keeping all operations local to the browser.

### Key Value Propositions

- Browser-based compression without server uploads
- Privacy-focused: all processing happens client-side
- No software installation required
- High-quality compression maintaining video resolution
- Multiple format support for compression and conversion
- Optional local tool for offline processing on macOS/Linux

---

## Architecture

### System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Web Application                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Compress   │  │   Video to  │  │    Local Tool       │  │
│  │   Video     │  │     GIF     │  │     Guide           │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │         @cheryx2020/core (Compress Component)         │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           @ffmpeg/ffmpeg (FFmpeg WASM)                │   │
│  │     ┌─────────────┐         ┌─────────────────┐       │   │
│  │     │  ffmpeg-core│         │  ffmpeg-core    │       │   │
│  │     │    (JS)     │         │    (WASM)       │       │   │
│  │     └─────────────┘         └─────────────────┘       │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                    ┌─────────┴─────────┐
                    ▼                   ▼
            ┌──────────────┐    ┌──────────────┐
            │  Firebase    │    │   Local      │
            │  Hosting     │    │   Script     │
            └──────────────┘    └──────────────┘
```

### Technology Stack

| Layer | Technology | Purpose |
|-------|------------|---------|
| Frontend Framework | React 18.3.1 | UI component library |
| Build Tool | Vite 6.2.0 | Fast development and bundling |
| Language | TypeScript 5.7.2 | Type-safe development |
| Styling | Bootstrap 5.3 + SCSS | Responsive UI styling |
| Routing | React Router DOM 7.4.0 | Client-side navigation |
| Video Processing | FFmpeg WASM 0.12.x | Browser-based video processing |
| UI Components | @cheryx2020/core 1.1.142 | Custom compression interface |
| Hosting | Firebase Hosting | Production deployment |
| CI/CD | GitHub Actions | Automated deployment |

---

## Project Structure

```
video-compressor/
├── public/                          # Static assets
│   ├── index.html                   # HTML template
│   ├── apple-touch-icon-180x180.png # iOS icon
│   ├── logo.png                     # Logo image
│   └── video-compressor.png         # App icon
├── src/
│   ├── pages/                       # Route components
│   │   ├── About.tsx               # About page
│   │   ├── LocalTool.tsx           # Local tool documentation
│   │   └── NotFound.tsx            # 404 error page
│   ├── types/
│   │   └── cheryx-core.d.ts        # Type declarations for @cheryx2020/core
│   ├── App.scss                    # Component-specific styles
│   ├── App.tsx                     # Main app with routing
│   ├── index.css                   # Global styles
│   ├── main.tsx                    # Application entry point
│   └── vite-env.d.ts               # Vite environment types
├── .github/workflows/
│   └── deploy-to-firebase.yml      # CI/CD pipeline
├── dist/                           # Build output
├── video_compress.sh               # Local bash tool for macOS/Linux
├── firebase.json                   # Firebase hosting config
├── vite.config.ts                  # Vite configuration
├── tsconfig.json                   # TypeScript project references
├── tsconfig.app.json               # App TypeScript config
├── tsconfig.node.json              # Node tooling TS config
├── eslint.config.js                # ESLint configuration
├── package.json                    # Dependencies and scripts
├── yarn.lock                       # Dependency lock file
└── index.html                      # Development HTML entry
```

---

## Core Components

### Application Entry (main.tsx)

Located at `src/main.tsx`, this is the application bootstrap:

- Uses React 18's `StrictMode` for development-time checks
- Creates root using `createRoot` API
- Wraps application with `BrowserRouter` for SPA routing

```typescript
createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </StrictMode>,
)
```

### Main App Component (App.tsx)

Located at `src/App.tsx`, handles routing and navigation:

**Routes Configuration:**
| Route | Component | Description |
|-------|-----------|-------------|
| `/` | `<Compress type={COMPRESS} />` | Video compression interface |
| `/videotogif` | `<Compress type={GIF} />` | Video to GIF conversion |
| `/localtool` | `<LocalTool />` | Local bash tool documentation |
| `/about` | `<About />` | Project information |
| `*` | `<NotFound />` | 404 error page |

**Navigation Structure:**
- Responsive Bootstrap navbar with collapsible mobile menu
- Logo and brand name in header
- Navigation links: Compress Video, Convert to GIF, Local Tool Guide, About

**FFmpeg Integration:**
The App component passes FFmpeg configuration to the Compress component:
- `FFmpeg`: The FFmpeg WASM constructor
- `fetchFile`: Utility for reading files into FFmpeg's virtual filesystem
- `coreURL`: URL to the FFmpeg core JavaScript file
- `wasmURL`: URL to the FFmpeg WASM binary

### Compress Component (@cheryx2020/core)

The core compression functionality is provided by the external package `@cheryx2020/core`. This is a proprietary UI component that wraps FFmpeg operations.

**Props Interface:**
```typescript
interface CompressProps {
  FFmpeg: typeof FFmpeg;          // FFmpeg WASM constructor
  fetchFile: (file: File) => Promise<Uint8Array>;  // File reader utility
  coreURL: string;                // Core JS bundle URL
  wasmURL: string;                // WASM binary URL
  type: CompressType;             // Operation mode
}
```

**Operation Modes:**
- `Compress.CompressType.COMPRESS`: Video compression with quality reduction
- `Compress.CompressType.GIF`: Convert video to animated GIF

**Key Features:**
- File upload interface with drag-and-drop
- Progress indication during processing
- Quality settings adjustment
- Output file download

---

## Local Tool (video_compress.sh)

A bash script providing offline video processing for macOS and Linux systems.

### Features

1. **Compress Video**: H.264 compression with configurable quality
2. **Convert to GIF**: Transform videos into animated GIFs
3. **Convert Images to WebP**: Batch convert image files to WebP format
4. **Setup Alias**: Create shell alias for easy tool access

### Dependencies

| Tool | Purpose | Auto-install |
|------|---------|--------------|
| `ffmpeg` | Video/audio processing | Yes (Homebrew/APT) |
| `zenity` | GUI dialogs | Yes (Homebrew/APT) |

### Supported Package Managers

- **Homebrew** (macOS): `brew install <package>`
- **APT** (Linux): `sudo apt update && sudo apt install -y <package>`

### FFmpeg Commands Used

**Video Compression:**
```bash
ffmpeg -i "$INPUT_FILE" \
  -vcodec libx264 \
  -crf 28 \
  -preset fast \
  -acodec aac \
  -b:a 128k \
  "$OUTPUT_FILE"
```

**Parameters:**
- `libx264`: H.264 video codec
- `crf 28`: Constant Rate Factor (quality, lower = better, 23 default)
- `preset fast`: Encoding speed/quality tradeoff
- `aac`: Audio codec
- `b:a 128k`: Audio bitrate 128 kbps

**GIF Conversion:**
```bash
ffmpeg -i "$INPUT_FILE" \
  -vf "fps=10,scale=1000:-1:flags=lanczos" \
  -c:v gif \
  "$OUTPUT_FILE"
```

**Parameters:**
- `fps=10`: 10 frames per second
- `scale=1000:-1`: Width 1000px, height auto-maintained
- `lanczos`: High-quality scaling algorithm

**Image to WebP:**
```bash
ffmpeg -i "$INPUT_FILE" \
  -c:v libwebp \
  -quality 85 \
  "$OUTPUT_FILE" \
  -y
```

**Parameters:**
- `libwebp`: WebP encoder
- `quality 85`: WebP quality setting (0-100)
- `-y`: Overwrite existing files

### Alias Setup Feature

The script can configure a shell alias for convenient access:

1. Detects shell type (zsh/bash)
2. Identifies config file (~/.zshrc, ~/.bashrc, or ~/.bash_profile)
3. Prompts for alias name (default: "vtool")
4. Validates alias name (alphanumeric + underscore)
5. Adds or replaces alias in shell config
6. Provides instructions for activation

---

## Build Configuration

### Vite Configuration (vite.config.ts)

```typescript
export default defineConfig({
  plugins: [react()],
  optimizeDeps: {
    exclude: ["@ffmpeg/ffmpeg", "@ffmpeg/util"]
  },
  server: {
    headers: {
      "Cross-Origin-Opener-Policy": "same-origin",
      "Cross-Origin-Embedder-Policy": "require-corp",
    }
  }
})
```

**Key Settings:**

| Setting | Value | Purpose |
|---------|-------|---------|
| `optimizeDeps.exclude` | `@ffmpeg/ffmpeg`, `@ffmpeg/util` | Prevent Vite from optimizing FFmpeg packages (required for WASM) |
| `Cross-Origin-Opener-Policy` | `same-origin` | Security header required for SharedArrayBuffer |
| `Cross-Origin-Embedder-Policy` | `require-corp` | Security header required for SharedArrayBuffer |

**Why COOP/COEP Headers Matter:**
FFmpeg WASM uses `SharedArrayBuffer` for performance, which requires these security headers to prevent Spectre-like attacks. Without them, the WASM module cannot function.

### TypeScript Configuration

**Project References (tsconfig.json):**
- `tsconfig.app.json`: Application source code
- `tsconfig.node.json`: Build tooling (Vite config)

**App Configuration (tsconfig.app.json):**
- Target: ES2020
- JSX: react-jsx transform
- Module: ESNext with bundler resolution
- Path mapping: `@cheryx2020/core` → `src/types/cheryx-core.d.ts`
- Strict mode enabled with additional safety checks

### ESLint Configuration (eslint.config.js)

Uses the new flat config format:
- Base: ESLint recommended + TypeScript recommended
- Plugins: react-hooks, react-refresh
- Rules: Standard React Hooks rules, refresh only-export-components

---

## Deployment

### Firebase Hosting

**Configuration (firebase.json):**
```json
{
  "hosting": {
    "public": "dist",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

**Features:**
- Serves content from `dist/` directory
- SPA routing: all routes serve `index.html`
- Ignores dotfiles and node_modules

### CI/CD Pipeline (.github/workflows/deploy-to-firebase.yml)

**Triggers:**
- Push to `main` branch

**Steps:**
1. Checkout repository
2. Setup Node.js 22 with Yarn caching
3. Install Yarn globally
4. Install dependencies: `yarn install --frozen-lockfile`
5. Build: `yarn build`
6. Deploy to Firebase Hosting using `FirebaseExtended/action-hosting-deploy@v0`

**Required Secrets:**
- `GITHUB_TOKEN`: Auto-provided by GitHub Actions
- `FIREBASE_SERVICE_ACCOUNT_VIDEO_COMPRESSOR_D6B5E`: Firebase service account JSON

---

## Styling

### Global Styles (index.css)

**CSS Variables:**
```css
:root {
  --primary-color: #28bac9;
}
```

**Primary Color Usage:**
- Progress bars: background color
- Text primary: color override
- Buttons: background and border with hover opacity transition

**Utility Classes:**
- `.flex`: display: flex
- `.center`: align-items: center
- `.ml-10`: margin-left: 10px
- `.logo`: Logo background image (46x46px)

### Component Styles (App.scss)

Additional utility classes mirroring index.css for component-scoped usage.

### Bootstrap Integration

**CDN Links (index.html):**
- CSS: Bootstrap 5.3.0-alpha1
- JS: Bootstrap bundle with Popper

**Components Used:**
- Navbar with responsive collapse
- Cards for content containers
- Buttons with primary/success styling
- Grid system (container, row, col-md-8, etc.)

---

## SEO & Meta Tags

### HTML Head Configuration

**Title:** "Video Compressor - Free Online Video Compression Tool"

**Meta Description:**
"Compress your videos online for free without losing quality. Reduce file size while maintaining high resolution. Fast and secure video compression tool."

**Open Graph (Facebook/LinkedIn):**
- Type: website
- URL: https://video-compressor.com/
- Image: /logo.png

**Twitter Card:**
- Type: summary_large_image
- Image: /logo.png

**Structured Data (JSON-LD):**
```json
{
  "@context": "https://schema.org",
  "@type": "SoftwareApplication",
  "name": "Online Video Compressor",
  "operatingSystem": "All",
  "applicationCategory": "MultimediaApplication",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.9",
    "reviewCount": "1548"
  }
}
```

**Google Analytics:**
- Tracking ID: G-BP5XYGWK5N
- gtag.js implementation

---

## Available Scripts

| Command | Description |
|---------|-------------|
| `yarn dev` | Start Vite development server |
| `yarn build` | Type-check and build for production |
| `yarn deploy` | Build and deploy to Firebase |
| `yarn lint` | Run ESLint on source files |
| `yarn preview` | Preview production build locally |

---

## Dependencies

### Production Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| @cheryx2020/core | ^1.1.142 | Compression UI component |
| @ffmpeg/core | ^0.12.10 | FFmpeg WASM core |
| @ffmpeg/ffmpeg | ^0.12.15 | FFmpeg WASM bindings |
| @ffmpeg/util | ^0.12.2 | FFmpeg utilities (fetchFile) |
| react | ^18.3.1 | React library |
| react-dom | ^18.3.1 | React DOM renderer |
| react-router-dom | ^7.4.0 | Routing library |

### Development Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| @eslint/js | ^9.21.0 | ESLint core |
| @types/react | ^19.0.10 | React TypeScript types |
| @types/react-dom | ^19.0.4 | React DOM TypeScript types |
| @vitejs/plugin-react | ^4.3.4 | Vite React plugin |
| eslint | ^9.21.0 | Linting tool |
| eslint-plugin-react-hooks | ^5.1.0 | React Hooks lint rules |
| eslint-plugin-react-refresh | ^0.4.19 | React Refresh lint rules |
| globals | ^15.15.0 | Global variable definitions |
| sass | ^1.86.3 | SCSS compiler |
| typescript | ~5.7.2 | TypeScript compiler |
| typescript-eslint | ^8.24.1 | TypeScript ESLint plugin |
| vite | ^6.2.0 | Build tool |

---

## Browser Compatibility

### Requirements

- Modern browsers with WebAssembly support
- SharedArrayBuffer support (requires COOP/COEP headers)
- ES2020+ JavaScript features

### Supported Browsers

- Chrome 80+
- Firefox 79+
- Safari 16.4+
- Edge 80+

### Why SharedArrayBuffer Matters

FFmpeg WASM uses multiple threads for performance. SharedArrayBuffer enables:
- Memory sharing between Web Workers
- Efficient data transfer without copying
- Required for real-time video processing

---

## Security Considerations

1. **Client-Side Processing**: All video processing happens in the browser; no files uploaded to servers
2. **COOP/COEP Headers**: Required for SharedArrayBuffer security
3. **No Sensitive Data**: Application doesn't handle authentication or personal data
4. **MIT License**: Open source with permissive licensing

---

## Development Workflow

1. **Local Development:**
   ```bash
   yarn install
   yarn dev
   ```

2. **Building:**
   ```bash
   yarn build
   ```

3. **Linting:**
   ```bash
   yarn lint
   ```

4. **Deployment:**
   - Push to `main` branch triggers automatic deployment
   - Or manually: `yarn deploy`

---

## Common Issues & Solutions

### FFmpeg WASM Not Loading

**Symptom:** Black screen or "FFmpeg not loaded" error

**Solutions:**
1. Check COOP/COEP headers are set in vite.config.ts
2. Ensure `@ffmpeg/core` and `@ffmpeg/ffmpeg` are in `optimizeDeps.exclude`
3. Clear browser cache and reload

### Build Failures

**Symptom:** TypeScript errors during build

**Solutions:**
1. Run `yarn install` to update dependencies
2. Check `tsconfig.app.json` includes all source files
3. Verify no type errors with `yarn lint`

### Local Script Permission Denied

**Symptom:** Cannot execute video_compress.sh

**Solution:**
```bash
chmod +x video_compress.sh
```

---

## File Outputs

### Video Compression
- **Format:** MOV container with H.264 video + AAC audio
- **Suffix:** `_compressed`
- **Video Codec:** libx264
- **Audio Codec:** AAC (128 kbps)
- **Quality:** CRF 28 (balanced quality/size)

### GIF Conversion
- **Format:** Animated GIF
- **Frame Rate:** 10 FPS
- **Width:** 1000px (height auto)
- **Scaling:** Lanczos algorithm

### WebP Conversion
- **Format:** WebP image
- **Quality:** 85%
- **Input Support:** JPG, JPEG, PNG, GIF, BMP

---

## Repository Information

- **Owner:** Vinh Nguyen (glorynguyen)
- **License:** MIT License (2025)
- **Repository:** https://github.com/glorynguyen/video-compressor
- **Live URL:** https://video-compressor.com/
- **Package Manager:** Yarn
- **Node Version:** 22 (for CI/CD)

---

## External Resources

### FFmpeg Documentation
- Website: https://www.ffmpeg.org/
- WASM Project: https://github.com/ffmpegwasm/ffmpeg.wasm

### Related Technologies
- Vite: https://vitejs.dev/
- React: https://react.dev/
- Firebase Hosting: https://firebase.google.com/docs/hosting
- Bootstrap: https://getbootstrap.com/

---

## Changelog (Recent)

- **feat(video_compress.sh):** Add setup alias functionality
- **feat(video_compress.sh):** Add support for converting images to WebP
- **Update README.md:** Documentation improvements

---

## Contributing Guidelines

1. Fork the repository
2. Create a feature branch
3. Make changes with clear commit messages
4. Ensure `yarn lint` passes
5. Test locally with `yarn dev` and `yarn build`
6. Submit pull request to `main` branch

---

## Support & Contact

- **Developer:** Vinh Nguyen
- **LinkedIn:** https://www.linkedin.com/in/vinh-nguyen-479781130/
- **Issues:** GitHub Issues page
- **Email:** (see LinkedIn profile)

---

## Glossary

| Term | Definition |
|------|------------|
| **FFmpeg** | Open-source multimedia framework for video/audio processing |
| **WASM** | WebAssembly - binary instruction format for web browsers |
| **CRF** | Constant Rate Factor - quality setting for x264 encoder |
| **H.264** | Video compression standard (AVC) |
| **AAC** | Advanced Audio Coding - audio compression standard |
| **WebP** | Modern image format with superior compression |
| **COOP** | Cross-Origin Opener Policy - security header |
| **COEP** | Cross-Origin Embedder Policy - security header |
| **SPA** | Single Page Application - web app that loads single HTML page |
| **Vite** | Next-generation frontend build tool |
| **Zenity** | GTK dialog utility for Linux/Unix |
| **Homebrew** | macOS package manager |
| **APT** | Advanced Package Tool - Debian/Ubuntu package manager |
