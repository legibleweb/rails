# Legible Web

Tired of how much crap is on the Internet? Let's fix it and build an internet that disincentivizes "influencers" and advertisers to the max, but delivers a fast, amazing reading experience.

Legible Web is built on top of existing standards, like HTTP 1.1, and passes on features that have become too complex, like "modern" HTML, JavaScript, and CSS.

## How it works

It's pretty simple really. Request a resource with the `Accept: text/markdown` header and a markdown file gets served up for the client to render. That's it! That's the technology.

Ok ok ... there's one more thing: navigation. It's a JSON file, which you can read more about at [Navigation](/navigation) or request the file via `Accept: application/json`.