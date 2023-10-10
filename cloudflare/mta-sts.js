const stsPolicies = {
    "mta-sts.soubilabs.xyz":
        `version: STSv1
mode: testing
mx: route1.mx.cloudflare.net
mx: route2.mx.cloudflare.net
mx: route3.mx.cloudflare.net
max_age: 259200`
}

const respHeaders = {
    "Content-Type": "text/plain;charset=UTF-8",
}

addEventListener("fetch", event => {
    event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {
    let reqUrl = new URL(request.url)

    if (!stsPolicies.hasOwnProperty(reqUrl.hostname)) {
        return new Response(`${reqUrl.hostname} is not defined in the mta-sts worker\n`, { status: 500, headers: respHeaders })
    }

    if (reqUrl.pathname === "/.well-known/mta-sts.txt") {
        if (reqUrl.protocol === "https:") {
            return new Response(stsPolicies[reqUrl.hostname] + "\n", { status: 200, headers: respHeaders })
        } else {
            reqUrl.protocol = "https:"
            reqUrl.pathname = "/.well-known/mta-sts.txt"
            return Response.redirect(reqUrl, 301)
        }
    }
}