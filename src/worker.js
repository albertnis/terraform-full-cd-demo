const html = `<!DOCTYPE html>
<body>
  <h1>Hello from this deployment</h1>
  <h2>This is the new version</h2>
  <p>The environment name is ${ENV_NAME}</p>
</body>`;

const handleRequest = (request) =>
  new Response(html, {
    headers: { "content-type": "text/html;charset=UTF-8" },
  });

addEventListener("fetch", (event) =>
  event.respondWith(handleRequest(event.request))
);
