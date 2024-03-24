const respHeaders = {
  "content-type": "text/html;charset=UTF-8",
}

const url = "https://us-west-2.cdn.hygraph.com/content/clt9ua1uu25rb07uzgwllv5zu/master";
const buildsByAppsGQL = {
  query: `
    query BuildsByApps {
      applications(where: {isForTest: false}, orderBy: name_ASC) {
        name
        description
        categories
        source
        builds(orderBy: publishedAt_DESC, first: 3) {
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

const allTagsGQL = {
  query: `
    query AllTags {
      applications(where: {isForTest: false}, orderBy: categories_ASC) {
        categories
      }
    }
    `,
}


const buildsByAppsRequest = {
  body: JSON.stringify(buildsByAppsGQL),
  method: "POST",
  headers: {
    "content-type": "application/json;charset=UTF-8",
    "Accept": "application/json",
  }
  ,
};

const allTagsRequest = {
  body: JSON.stringify(allTagsGQL),
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
  const buildsByAppsResponse = await fetch(url, buildsByAppsRequest);
  const buildsByAppsJsonData = await gatherResponse(buildsByAppsResponse);
  const allTagsResponse = await fetch(url, allTagsRequest)
  const allTagsJsonData = await gatherResponse(allTagsResponse);

  let rows = ``

  buildsByAppsJsonData.data.applications.forEach(app => {
    app.builds.forEach((build) => {
      const dateObj = new Date(build.createdAt);
      const isoDate = dateObj.toISOString();
      const formattedDate = isoDate.substring(0, 10);
      const formattedTime = isoDate.substring(11, 16);
      const buildIdMeta = `${build.buildId}-meta.tar.xz`;
      const buildIdRoot = `${build.buildId}-root.tar.xz`;

      rows = rows + `
      <tr>
      <td><a target="blank" href="${app.source}" data-tooltip="${app.description}" data-position="bottom" class="bottom">${toTitleCase(app.name)}</a></td>
      <td>${build.buildId}</td>
      <td><a href="https://download-lxc-images.soubilabs.xyz/${buildIdRoot}">${buildIdRoot}</a> | <a href="https://download-lxc-images.soubilabs.xyz/${buildIdMeta}">metadata</a></td>
      <td>${toTitleCase(build.distribution)} <i>${build.distRelease}</i> - ${build.architecture}</td>
      <td>${formattedDate}_${formattedTime}</td>
      <td>~${build.size}B</td>
      <td>${app.categories.join(', ')}</td>
      </tr>
      `;
    });
  })

  let categories = []
  allTagsJsonData.data.applications.forEach(app => {
    app.categories.forEach(category => {
      categories.push(category);
    })
  })
  
  let tags = ``
  uniqCategories = [...new Set(categories)];
  uniqCategories.forEach(uniqCategory => {
    tags = tags + `
    <label class="checkbox-button"><input type="checkbox" name="tags" value="${uniqCategory}" class="tag-filter">${toTitleCase(uniqCategory)}</label>
    `;
  })

  const htmlContent = `<!DOCTYPE html>
  <html>
  <head>
    <title>My Custom LXC images</title>

    <link href="https://linuxcontainers.org/static/img/containers.svg" type="image/x-icon" rel="icon">
    <link href="https://cdn.datatables.net/2.0.1/css/dataTables.dataTables.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/v/bs5/jq-3.7.0/dt-2.0.1/fh-4.0.0/r-3.0.0/rg-1.5.0/datatables.min.css" rel="stylesheet">

    <script src="https://kit.fontawesome.com/75a73f799c.js" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/v/bs5/jq-3.7.0/dt-2.0.1/fh-4.0.0/r-3.0.0/rg-1.5.0/datatables.min.js"></script>
    

    <style>
      :root {
        --background: #F7EEDD;
        --text: #000;
        --primary: #8F1E00;
        --secondary: #8B4513;
      }

      * {
        margin: 0px;
        padding: 0px;
        box-sizing: border-box;
      }

      body {
        color: var(--txt);
        background-color: var(--background);
        font-size: 1rem;
        overflow-x: auto;
        overflow-y: scroll;
        padding: 5px;
      }
      #container {
        width: 95%;
        max-width: 1440px;
        min-width: 640px;
        margin: auto;
        padding: 1%;
      }
      footer {
        margin-top: 50px;
      }

      /* WebKit */
      ::-webkit-scrollbar {
          width: 3px;
      }
  
      ::-webkit-scrollbar-track {
          background: var(--background);
      }
  
      ::-webkit-scrollbar-thumb {
          background: var(--secondary);
      }
  
      ::-webkit-scrollbar-thumb:hover {
          background: var(--text);
      }
  
      /* Firefox */
      scrollbar-width: thin;
      scrollbar-color: var(--secondary) var(--primary);
  
      /* Standard */
      body {
        scrollbar-width: thin;
        scrollbar-color: var(--secondary) var(--primary);
      }

      #intro {
        display: flex;
        align-items: center;
      }
      #intro>p {
        width: 80%
      }
      #intro>img {
        width: 20%
      }

      h1, h2, h3 {
        color: var(--primary);
      }
      a {
        color: var(--secondary);
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
      tbody tr {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      input[type="checkbox"] {
        display: none;
      }

      label.checkbox-button {
        display: inline-block;
        padding: 5px 5px;
        background-color: #transparent;
        color: var(--secondary);
        border: 1px solid var(--secondary);
        border-radius: 5px;
        cursor: pointer;
        min-width: 30px;
        text-align: center;
        font-size: .7em;
        vertical-align: middle;
        margin: 1px;
        transition: background-color 200ms cubic-bezier(.4, 0, .23, 1);
        transition: font-size 250ms ease;
      }

      label.checked {
        background-color: var(--secondary);
        color: var(--background);
        font-weight: bold;
        font-size: .9em;
        border-color: var(--secondary);
        transition: background-color 200ms cubic-bezier(.4, 0, .23, 1);
        transition: font-size 250ms cubic-bezier(.4, 0, .23, 1);
      }

      a[data-tooltip].bottom:before, a[data-tooltip].bottom:after {
        transform: translateY(-10px);
      }

      a[data-tooltip].bottom:hover:after, a[data-tooltip].bottom:hover:before {
        transform: translateY(0px);
      }
      
      a[data-tooltip] {
        position: relative;
      }
      
      a[data-tooltip]:after, a[data-tooltip]:before {
        position: absolute;
        visibility: hidden;
        opacity: 0;
        transition: transform 200ms ease, opacity 200ms;
        box-shadow: 0 0 10px rgba(0, 0, 0, .3);
        z-index: 99;
      }
      
      a[data-tooltip]:before {
        content: attr(data-tooltip);
        background: #000;
        color: var(--background);
        font-size: .9rem;
        padding: 10px 15px;
        border-radius: 5px;
        text-decoration: none;
        letter-spacing: 1px;
        width: 480px;
        text-wrap: wrap;
      }
      
      a[data-tooltip]:after {
        width: 0;
        height: 0;
        border: 6px solid transparent;
        content: '';
      }
      
      a[data-tooltip]:hover:after, a[data-tooltip]:hover:before {
        visibility: visible;
        opacity: .75;
        transform: translateY(0px);
      }
      
      a[data-tooltip][data-position="bottom"]:before {
        top: 100%;
        left: -10px;
        margin-top: 10px;
      }
      
      a[data-tooltip][data-position="bottom"]:after {
        border-bottom-color: #000;
        border-top: none;
        top: 100%;
        left: 0px;
        margin-top: 4px;
      }

      #back-to-top {
        // display: inline-block;
        background-color: var(--secondary);
        width: 50px;
        height: 50px;
        text-align: center;
        border-radius: 4px;
        position: fixed;
        bottom: 30px;
        right: 30px;
        transition: background-color .3s, opacity .5s, visibility .5s;
        opacity: 0;
        visibility: hidden;
        z-index: 1000;
      }
      #back-to-top::after {
        display: inline-block;
        text-rendering: auto;
        -webkit-font-smoothing: antialiased;
        font: var(--fa-font-solid);
        content: "\\f106";
        color: var(--background);
        font-size: 2em;
        font-style: normal;
        line-height: 50px;
      }
      #back-to-top:hover {
        cursor: pointer;
        background-color: var(--primary);
      }
      #back-to-top:active {
        background-color: var(--background);
      }
      #back-to-top.show {
        opacity: 1;
        visibility: visible;
      }
    </style>
  </head>

  <body>
  <a id="back-to-top"></a>
  <div id="container">
    <h1>A Customized Linux Containers Inventory</h1>
    <p><i>An actively maintained listing of customized LXC images</i></p>
    <article id="intro">
      <p>
      This domain lists many LXC images built for use on Proxmox Virtual Environments (or any other environments supporting LXCs).<br>
      Lets avoid <strong>over-containerization</strong> (Docker/Postman in LXC) and <strong>over-virtualization</strong> (Docker/Postman on vms) and simply use native LXCs instead.<br>
      All images available here are generated using <a href="https://linuxcontainers.org/distrobuilder/docs/latest" target="blank">distrobuilder</a> along with dedicated <a target="blank" href="https://github.com/soubinan/homelab-lxc/tree/dev/templates">YAML definitions files</a>.<br>
      The build themselves can be seen in <a target="blank" href="https://github.com/soubinan/homelab-lxc/actions">this project repo's actions</a>.<br>
      Images are generated and shared in an object store and the related links shared on this page.<br>
      This started as a personal project built for my own needs, then shared because it could help someone else (hopefully..).<br>
      <br>
      <i>At most the 03 last versions and at least only the latest version are listed for each application's build.</i>
      </p>
      <img src="https://linuxcontainers.org/static/img/containers.svg" alt="Linux Container Logo" max-width="300" max-height="300" style="border: none;">
    </article>
    <p>
    Unfortunately public storage and hosting are not free, If you like this initiative please consider <a target="blank" href="https://github.com/sponsors/soubinan">to be a sponsor</a> to help maintain this project alive or simply give a star to <a href="https://github.com/soubinan/homelab-lxc" target="blank">this project's repo</a>.
    </p>
    <h2>Available images</h2>
    <p>Your favorite application is missing ? <a href="https://github.com/soubinan/homelab-lxc/issues/new?assignees=&labels=&projects=&template=new-application-request.md&title=Add+%3Capplication_name%3E+template">please open an issue</a> with the required details and I will try to add it as soon as possible, or you can simply add it by yourself, it is pretty easy to do.</p>
    <p>Any issue related to an image I packaged ? <a href="https://github.com/soubinan/homelab-lxc/issues/new/choose">Thanks to share it</a>.</p>
    <form>
      <label class="checkbox-button checked"><input type="checkbox" name="tags" value="all-tags" checked id="all-tags" class="tag-filter">All categories</label>
      ${tags}
    </form>
    <table id="buildsTable" class="display compact" style="width:100%">
      <thead>
        <tr>
          <th>Row Group</th>
          <th>Name</th>
          <th>Links</th>
          <th style="max-width:15%">Distribution</th>
          <th style="max-width:15%">Build Date</th>
          <th style="max-width:8%">Size</th>
          <th>Categories</th>
        </tr>
      </thead>
      <tbody>
        ${rows}
      </tbody>
    </table>
    <!--<footer>
    Shared by <a href="https://github.com/soubinan">Soubinan</a>
    </footer>-->
  </div>

  <script>
    const groupColumn = 0;
    const CategoriesCol = 6;

    const table = new DataTable('#buildsTable',
      {
        columnDefs: [
          { visible: false, targets: groupColumn },
          { visible: false, targets: CategoriesCol }
        ],
        order: [
          [groupColumn, 'asc'],
          [1, 'asc']
        ],
        responsive: true,
        fixedHeader: true,
        paging: false,
        rowGroup: true,
        ordering: false
      }
    );

    const allTags = document.querySelector('#all-tags');
    const tagsInputs = document.querySelectorAll('.tag-filter');

    tagsInputs.forEach(tagInput => {
      tagInput.addEventListener('change', function () {

        if (tagInput.value != 'all-tags') {
          allTags.checked = false;
        }

        let tagsInputsSelected = []

        tagsInputs.forEach(tagInput => {
          if (tagInput.checked) {
            tagInput.parentElement.classList.add('checked');
            tagsInputsSelected.push(tagInput.value);
          } else {
            tagInput.parentElement.classList.remove('checked');
          }
        });

        if (tagsInputsSelected.length === 0) {
          allTags.checked = true;
          allTags.parentElement.classList.add('checked');
        }

        table.column(CategoriesCol).search(function (d) {
          if (tagsInputsSelected.length !== 0 && !tagsInputsSelected.includes('all-tags')) {
            return tagsInputsSelected.some(value => d.includes(value))
          } else {
            return true;
          }
        }).draw();
      });
    });

    let btn = $('#back-to-top');

    $(window).scroll(function() {
      if ($(window).scrollTop() > 300) {
        btn.addClass('show');
      } else {
        btn.removeClass('show');
      }
    });
    
    btn.on('click', function(e) {
      e.preventDefault();
      $('html, body').animate({scrollTop:0}, '300');
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
