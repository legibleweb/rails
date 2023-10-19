---
title: Navigation
---

# Navigation

Since Markdown doesn't have navigation, its provided via a sideband navigation format that looks like this:

```json
{
    "title": null,
    "url": "/",
    "children":
    [
        {
            "title": "history",
            "url": "/history",
            "children": []
        }
    ]
}
```

[View an example](/?format=json)

## Request Headers

Navigation can be requested at a URI with the `Accept: application/json+navigation` header.
