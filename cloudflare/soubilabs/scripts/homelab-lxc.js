const respHeaders = {
  "content-type": "text/html;charset=UTF-8",
}

const url = "https://us-west-2.cdn.hygraph.com/content/clt9ua1uu25rb07uzgwllv5zu/master";
const body = {
  query: `
    query MyQuery {
      applications(orderBy: name_ASC) {
        name
        builds(orderBy: publishedAt_DESC, first: 5) {
          distribution
          distRelease
          architecture
          version
          buildId
          size
          createdAt
        }
      }
    }
    `,
}

const req = {
  body: JSON.stringify(body),
  method: "POST",
  headers: {
    "content-type": "application/json;charset=UTF-8",
    "Accept": "application/json",
  }
  ,
};

async function gatherResponse(response) {
  const { headers } = response;
  const contentType = headers.get("content-type") || "";
  if (contentType.includes("application/json")) {
    return (await response.json());
  }
}

function toTitleCase(s) {
  return s.charAt(0).toUpperCase() + s.slice(1);
}

async function handleRequest(request) {
  const response = await fetch(url, req);
  const jsonData = await gatherResponse(response);

  let rows = ``

  jsonData.data.applications.forEach(app => {
    app.builds.forEach((build) => {
      const dateObj = new Date(build.createdAt);
      const isoDate = dateObj.toISOString();
      const formattedDate = isoDate.substring(0, 10);
      const formattedTime = isoDate.substring(11, 16);
      const buildIdMeta = (build.buildId).replace(".tar.xz", "-meta.tar.xz");

      rows = rows + `
      <tr>
      <td>${toTitleCase(app.name)}</td>
      <td>${toTitleCase(build.distribution)} ${toTitleCase(build.distRelease)}</td>
      <td>${build.architecture}</td>
      <td>${build.version}</td>
      <td><a href="https://download-lxc-images.soubilabs.xyz/${build.buildId}">${build.buildId}</a>&nbsp;and&nbsp;<a href="https://download-lxc-images.soubilabs.xyz/${buildIdMeta}">metadata</a></td>
      <td>~${build.size}B</td>
      <td>${formattedDate}_${formattedTime}</td>
      </tr>
      `;
    });
  })

  const htmlContent = `<!DOCTYPE html>
  <html>
  <head>
    <title>My Custom LXC images</title>

    <link rel="icon" href="https://linuxcontainers.org/static/img/containers.svg" type="image/x-icon">
    
    <link href="https://cdn.datatables.net/2.0.1/css/dataTables.dataTables.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/v/bs5/jq-3.7.0/dt-2.0.1/fh-4.0.0/r-3.0.0/rg-1.5.0/datatables.min.css" rel="stylesheet">
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/v/bs5/jq-3.7.0/dt-2.0.1/fh-4.0.0/r-3.0.0/rg-1.5.0/datatables.min.js"></script>
    

    <style>
      body {
        color: #2c2c2c;
        background-color: #F7EEDD;
        padding: 1em;
        padding-left: 5em;
        padding-right: 5em;
      }
      h1, h2, thead {
        color: #8f1e00
      }
      a {
        color: #8B4513;
      }
      i {
        margin-top: 15px;
        margin-bottom: 25px;
      }
      p {
        box-sizing: border-box;
      }
      p, img {
        margin-right: 15px;
      }
      #intro {
        display: flex;
        align-items: center;
      }
      #container {
        width: 80em;
        margin: auto;
      }
      footer {
        margin-top: 50px;
      }
    </style>
  </head>

  <body>
  <div id="container">
    <h1>The HomeLab's Custom Linux Containers Inventory</h1>
    <p>Like TurnKey's images but open and <i>shamelessly inspired by <a href="https://images.linuxcontainers.org">images.linuxcontainers.org</a></i></p>
    <article id="intro">
      <p>
      This domain lists many LXC images built for use on Proxmox based Homelabs (or any other environments supporting LXCs).<br>
      Lets avoid <strong>over-containerization</strong> (Docker/Postman in LXC) and <strong>over-virtualization</strong> (Docker/Postman on vms) and simply use native LXCs instead.<br>
      All images available here are generated using <a href="https://linuxcontainers.org/distrobuilder/docs/latest" target="blank">distrobuilder</a> along with dedicated <a target="blank" href="https://github.com/soubinan/homelab-lxc/tree/dev/templates">YAML definitions files</a>.<br>
      The build themselves can be seen in the <a target="blank" href="https://github.com/soubinan/homelab-lxc/actions">repo's Github actions</a>.<br>
      Images are generated as builds artifacts and the related links shared on this page.<br>
      This is first of all a personal project built for my own needs, then shared because it could help someone else (hopefully..).<br>
      <br>
      <i>At most 3 last versions are listed for each application.</i>
      </p>
      <img src="https://linuxcontainers.org/static/img/containers.svg" alt="Linux Container Logo" width="300" height="300" style="border: none;">
    </article>
    <p>
    Unfortunately public storage is not free, so if you found those images useful, please consider donate (your simply give a star to the project)
    </p>
    <h2>Available images</h2>
    <table id="buildsTable" class="display compact" style="width:100%">
      <thead>
        <tr>
          <th>Application</th>
          <th>Distribution</th>
          <th>Architecture</th>
          <th>Version</th>
          <th>Download</th>
          <th>Size</th>
          <th>Build Date</th>
        </tr>
      </thead>
      <tbody>
      ${rows}
      </tbody>
    </table>
    <footer>
    Shared by <a href="https://github.com/soubinan">Soubinan</a>
    </footer>
  </div>

  <script>
    $(document).ready( function () {
      $('#buildsTable').DataTable(
        {
          responsive: true,
          fixedHeader: true,
          paging: false,
          rowGroup: true
        }
      );
    });
  </script>
  </body>
  </html>
  `;

  return new Response(htmlContent, {
    headers: {
      "content-type": "text/html;charset=UTF-8",
    },
  });
}

addEventListener("fetch", event => {
  event.respondWith(handleRequest(event.request))
})
