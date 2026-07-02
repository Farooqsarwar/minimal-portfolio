// Server-side EmailJS proxy.
// Keeps EmailJS service/template/key credentials out of the client bundle.
// Configure these in Vercel Project Settings -> Environment Variables:
//   EMAILJS_SERVICE_ID, EMAILJS_TEMPLATE_ID, EMAILJS_PUBLIC_KEY,
//   EMAILJS_PRIVATE_KEY (optional, needed if EmailJS "strict mode" is on),
//   TO_EMAIL

const MAX_LEN = 5000;

// Basic anti-abuse: only requests whose Origin/Referer looks like our own
// Vercel deployments (production, previews, git-branch aliases) are served.
// Headers are trivially spoofable via curl, so this isn't a hard boundary —
// it just stops casual scraping of the endpoint from other sites.
function isAllowedOrigin(req) {
  const header = req.headers.origin || req.headers.referer;
  if (!header) return false;
  try {
    const { hostname } = new URL(header);
    return hostname === 'localhost'
      || (hostname.endsWith('.vercel.app') && hostname.includes('minimal-portfolio'));
  } catch {
    return false;
  }
}

// Best-effort in-memory rate limit. Resets whenever the serverless instance
// is recycled and isn't shared across instances, but still blunts a single
// script hammering one warm function.
const RATE_LIMIT_WINDOW_MS = 60_000;
const RATE_LIMIT_MAX = 5;
const hitsByIp = new Map();

function isRateLimited(ip) {
  const now = Date.now();
  const hits = (hitsByIp.get(ip) || []).filter(t => now - t < RATE_LIMIT_WINDOW_MS);
  hits.push(now);
  hitsByIp.set(ip, hits);
  return hits.length > RATE_LIMIT_MAX;
}

function truncate(value, max = MAX_LEN) {
  return typeof value === 'string' ? value.slice(0, max) : '';
}

module.exports = async (req, res) => {
  if (req.method !== 'POST') {
    res.setHeader('Allow', 'POST');
    return res.status(405).json({ error: 'Method not allowed' });
  }

  if (!isAllowedOrigin(req)) {
    return res.status(403).json({ error: 'Forbidden' });
  }

  const ip = req.headers['x-forwarded-for']?.split(',')[0]?.trim() || req.socket?.remoteAddress || 'unknown';
  if (isRateLimited(ip)) {
    return res.status(429).json({ error: 'Too many requests' });
  }

  const {
    EMAILJS_SERVICE_ID,
    EMAILJS_TEMPLATE_ID,
    EMAILJS_PUBLIC_KEY,
    EMAILJS_PRIVATE_KEY,
    TO_EMAIL,
  } = process.env;

  if (!EMAILJS_SERVICE_ID || !EMAILJS_TEMPLATE_ID || !EMAILJS_PUBLIC_KEY || !TO_EMAIL) {
    return res.status(500).json({ error: 'Email service not configured' });
  }

  let body = req.body;
  if (typeof body === 'string') {
    try { body = JSON.parse(body); } catch { body = {}; }
  }
  body = body || {};

  const type = body.type === 'contact' ? 'contact' : body.type === 'analytics' ? 'analytics' : null;
  if (!type) {
    return res.status(400).json({ error: 'Invalid type' });
  }

  const message = truncate(body.message);
  if (!message) {
    return res.status(400).json({ error: 'Message is required' });
  }

  let templateParams;
  if (type === 'contact') {
    const fromName = truncate(body.from_name, 200);
    const fromEmail = truncate(body.from_email, 320);
    if (!fromName || !fromEmail) {
      return res.status(400).json({ error: 'from_name and from_email are required' });
    }
    templateParams = {
      from_name: fromName,
      from_email: fromEmail,
      message,
      to_email: TO_EMAIL,
      reply_to: fromEmail,
    };
  } else {
    templateParams = {
      from_name: 'Portfolio Analytics',
      message,
      to_email: TO_EMAIL,
      reply_to: TO_EMAIL,
    };
  }

  try {
    const emailJsRes = await fetch('https://api.emailjs.com/api/v1.0/email/send', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        service_id: EMAILJS_SERVICE_ID,
        template_id: EMAILJS_TEMPLATE_ID,
        user_id: EMAILJS_PUBLIC_KEY,
        accessToken: EMAILJS_PRIVATE_KEY || undefined,
        template_params: templateParams,
      }),
    });

    if (!emailJsRes.ok) {
      const text = await emailJsRes.text();
      return res.status(502).json({ error: 'Email send failed', detail: text });
    }

    return res.status(200).json({ ok: true });
  } catch (err) {
    return res.status(502).json({ error: 'Email send failed' });
  }
};
