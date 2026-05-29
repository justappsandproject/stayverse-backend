/**
 * Normalizes listing media URLs for storage and API responses.
 * Handles relative paths, placeholder CDN values, and legacy bucket URLs.
 */
export function normalizeMediaUrl(
  url: string | undefined | null,
  cdnBase: string,
): string | undefined {
  if (!url || typeof url !== 'string') return undefined;

  let normalized = url.trim();
  if (!normalized) return undefined;

  const base = (cdnBase || '').replace(/\/$/, '');

  if (normalized.includes('your_cdn_url')) {
    normalized = normalized.replace(/https?:\/\/your_cdn_url\/?/gi, base);
  }

  // Legacy direct bucket URL → CDN
  if (
    base &&
    normalized.includes('.digitaloceanspaces.com/') &&
    !normalized.includes('.cdn.digitaloceanspaces.com/')
  ) {
    normalized = normalized.replace(
      /\.digitaloceanspaces\.com\//,
      '.cdn.digitaloceanspaces.com/',
    );
  }

  if (!/^https?:\/\//i.test(normalized)) {
    normalized = `${base}/${normalized.replace(/^\//, '')}`;
  }

  return normalized;
}

export function normalizeMediaUrls(
  urls: string[] | undefined | null,
  cdnBase: string,
): string[] {
  if (!urls?.length) return [];
  return urls
    .map((u) => normalizeMediaUrl(u, cdnBase))
    .filter((u): u is string => Boolean(u));
}
