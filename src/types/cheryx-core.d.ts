import { FC } from "react";
import { FFmpeg } from "@ffmpeg/ffmpeg";

declare module "@cheryx2020/core" {
  interface CompressProps {
    FFmpeg: typeof FFmpeg;
    fetchFile: (file: File) => Promise<Uint8Array>;
    coreURL: string;
    wasmURL: string;
    type: string;
  }

  interface CompressComponent extends FC<CompressProps> {
    CompressType: {
      COMPRESS: string;
      GIF: string;
    };
  }


  const Compress: CompressComponent;

  export { Compress };
}