# Viknjana Deepam

A Flutter digital archive and ebook reader for the annual Viknjana Deepam
magazine.

## Features

- Browse magazine volumes by year
- Search the archive
- Read volumes in a vertically scrolling reader
- Reading progress, bookmarks, contents navigation, and font-size controls
- A common St. Mary's Cathedral, Morrakkala sketch cover with data-driven
  titles, years, and volume numbers
- A private `/admin/` page for editing Malayalam magazine content
- A simple JSON catalogue bundled directly with the public reader

## Administration

The administration page is available at:

`https://albin-kp.github.io/viknjanadeepam/admin/`

It supports a static password login, structured Malayalam chapter editing,
deleting, backups, and publishing. Public readers never see administration or
update controls.

### Publishing from the admin

1. Sign in with the admin password.
2. Add or edit volumes and chapters.
3. Enter a fine-grained GitHub token with `Contents: Read and write` access to
   this repository.
4. Select **Publish to app**.

The editor commits [`assets/data/catalog.json`](assets/data/catalog.json) to
the repository. GitHub Pages then rebuilds the reader automatically. The token
is kept only in the current browser tab.

The default admin password is `VijnanaDeepam@2026`. Set the GitHub Actions
repository secret `ADMIN_PASSWORD` to replace it. Because the admin page is a
static site, this password is a convenience lock rather than strong security;
the GitHub token remains the actual publishing authorization.

## Run locally

```sh
flutter pub get
flutter run
```

The web app is automatically deployed to GitHub Pages when changes are pushed
to the `main` branch.

## Netlify

The repository includes [`netlify.toml`](netlify.toml). For a Netlify site
connected to this repository, leave the Netlify base directory empty. Netlify
will run `tool/netlify-build.sh` and publish `build/web` with the correct `/`
base path for a root domain.
