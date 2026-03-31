/**
 * Digiflazz CORS Proxy Worker
 * 
 * Cara Pakai:
 * 1. Buat akun gratis di workers.cloudflare.com
 * 2. Klik "Create Application" -> "Create Worker"
 * 3. Hapus semua kode default dan tempel kode ini.
 * 4. Klik "Save and Deploy".
 */

export default {
  async fetch(request, env, ctx) {
    // 1. Handling CORS (Preflight Request)
    if (request.method === "OPTIONS") {
      return new Response(null, {
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "POST, OPTIONS",
          "Access-Control-Allow-Headers": "Content-Type",
        },
      });
    }

    if (request.method !== "POST") {
      return new Response("Method Not Allowed", { status: 405 });
    }

    try {
      const body = await request.json();
      const endpoint = new URL(request.url).searchParams.get("url") || "https://api.digiflazz.com/v1/cek-saldo";

      // 2. Meneruskan Request ke Digiflazz
      // Note: Di produksi, sebaiknya API KEY & USERNAME ditaruh di Environment Variables Cloudflare
      const response = await fetch(endpoint, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body),
      });

      const data = await response.json();

      // 3. Kembalikan Hasil dengan Header CORS agar Flutter Web Bahagia
      return new Response(JSON.stringify(data), {
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
      });
    } catch (err) {
      return new Response(JSON.stringify({ error: err.message }), {
        status: 500,
        headers: { "Access-Control-Allow-Origin": "*" },
      });
    }
  },
};
