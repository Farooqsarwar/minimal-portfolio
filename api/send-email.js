// Server-side EmailJS proxy.
// Keeps EmailJS service/template/key credentials out of the client bundle.
// Configure these in Vercel Project Settings -> Environment Variables:
//   EMAILJS_SERVICE_ID, EMAILJS_TEMPLATE_ID, EMAILJS_PUBLIC_KEY,
//   EMAILJS_PRIVATE_KEY (optional, needed if EmailJS "strict mode" is on),
//   TO_EMAIL

const MAX_LEN = 5000;

function truncate(value, max = MAX_LEN) {
  return typeof value === 'string' ? value.slice(0, max) : '';
}

module.exports = async (req, res) => {
  if (req.method !== 'POST') {
    res.setHeader('Allow', 'POST');
    return res.status(405).json({ error: 'Method not allowed' });
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
