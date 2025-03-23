import { FC } from "react";
import { FFmpeg } from "@ffmpeg/ffmpeg";

declare module "@cheryx2020/core" {
  interface CompressProps {
    FFmpeg: typeof FFmpeg;
    fetchFile: (file: File) => Promise<Uint8Array>;
    coreURL: string;
    wasmURL: string;
  }

  const Compress: FC<CompressProps>;

  export { Compress };
}