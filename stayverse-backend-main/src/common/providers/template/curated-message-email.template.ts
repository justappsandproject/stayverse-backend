function escapeHtml(value: string): string {
  return value
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

export function curatedMessageEmailTemplate(message: {
  recipientName?: string;
  title: string;
  body: string;
  imageUrl?: string;
  imagePosition?: 'before' | 'after';
}): string {
  const title = escapeHtml(message.title);
  const body = escapeHtml(message.body).replace(/\n/g, '<br />');
  const greeting = message.recipientName
    ? `Hi ${escapeHtml(message.recipientName)},`
    : 'Hi there,';

  const imageTag = message.imageUrl
    ? `<img src="${escapeHtml(message.imageUrl)}" alt="Stayverse update" style="max-width:100%;border-radius:8px;margin:16px 0;display:block;" />`
    : '';

  const contentBlock =
    message.imagePosition === 'before'
      ? `${imageTag}<p style="margin:0 0 16px 0;color:#4B5563;font-size:16px;line-height:1.6;">${body}</p>`
      : `<p style="margin:0 0 16px 0;color:#4B5563;font-size:16px;line-height:1.6;">${body}</p>${imageTag}`;

  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>${title}</title>
</head>
<body style="margin:0;padding:24px;background:#f5f5f5;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;">
  <div style="max-width:600px;margin:0 auto;background:#ffffff;border-radius:12px;overflow:hidden;box-shadow:0 2px 10px rgba(0,0,0,0.08);">
    <div style="background:#111827;color:#ffffff;padding:24px 32px;">
      <p style="margin:0;font-size:12px;letter-spacing:0.08em;text-transform:uppercase;opacity:0.8;">Stayverse Update</p>
      <h1 style="margin:8px 0 0 0;font-size:24px;line-height:1.3;">${title}</h1>
    </div>
    <div style="padding:32px;">
      <p style="margin:0 0 16px 0;color:#111827;font-size:16px;font-weight:600;">${greeting}</p>
      ${contentBlock}
      <p style="margin:24px 0 0 0;color:#9CA3AF;font-size:13px;line-height:1.5;">
        You are receiving this because you have a Stayverse account. Open the Stayverse app to view this message in your inbox.
      </p>
    </div>
  </div>
</body>
</html>`;
}
