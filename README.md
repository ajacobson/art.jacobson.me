# art.jacobson.me

Personal site. [Zola](https://www.getzola.org) for the static build, Nix for a
reproducible one, GitHub Pages for hosting.

## Develop

```sh
nix develop      # zola + alejandra on PATH
zola serve       # http://127.0.0.1:1111, live reload
```

## Build

```sh
nix build        # -> ./result, byte-identical to what CI publishes
```

## Layout

| Path | Purpose |
| --- | --- |
| `config.toml` | Site config, plus the tagline, focus list, and links as `[extra]` data |
| `content/_index.md` | The prose on the landing page |
| `templates/index.html` | The only template |
| `sass/main.scss` | Styles; Base16 colors mirroring `nix-config`'s Dracula palette |
| `static/banner.jpg` | Full-bleed header image, also used as the `og:image` |
| `static/avatar.jpg` | Profile image straddling the banner's lower edge |

Both images were resized, re-encoded, and had their metadata stripped before
being committed. Replacements should get the same treatment — `magick in.jpg
-strip -resize 1500x -quality 82 out.jpg` — since `static/` is copied verbatim
and nothing optimizes it at build time.

Editing the tagline, the focus list, or the links means editing `config.toml` —
the template iterates over whatever is there. Focus numbers are a CSS counter,
so they renumber themselves.

Each link carries an `icon` key. The SVGs are inlined in
`templates/index.html`, so adding a link with a new `icon` value means adding a
matching branch there too — otherwise the link renders without a mark.

## Deploy

Pushing to `main` triggers `.github/workflows/pages.yml`, which builds with Nix
and publishes via GitHub Pages. Pages must be set to **build from GitHub
Actions** rather than from a branch. The custom domain (`art.jacobson.me`)
lives in the repo's Pages settings, not in the tree.

## Colors

The palette is copied from `modules/programs/palette/_dracula.nix` in
`nix-config` so the site matches the terminal and editor. It is a copy, not a
live reference — if those values change, update `sass/main.scss` too.
