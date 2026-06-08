type AdminImageProps = {
  src?: string | null;
  alt: string;
  className?: string;
  width?: number;
  height?: number;
};

export function AdminImage({
  src,
  alt,
  className,
  width,
  height,
}: AdminImageProps) {
  if (!src) {
    return (
      <div
        className={className}
        style={{ width, height }}
        aria-label={alt}
      />
    );
  }

  return (
    <img
      src={src}
      alt={alt}
      className={className}
      width={width}
      height={height}
      loading="lazy"
      decoding="async"
    />
  );
}
