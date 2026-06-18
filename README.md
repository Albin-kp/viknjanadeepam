# Vijnana Deepam

A Flutter digital archive and ebook reader for the annual Vijnana Deepam
magazine.

## Features

- Browse magazine volumes by year
- Search the archive
- Read volumes in a vertically scrolling reader
- Reading progress, bookmarks, contents navigation, and font-size controls
- A common St. Mary's Cathedral, Morrakkala sketch cover with data-driven
  titles, years, and volume numbers
- External JSON catalog updates from the app's Menu

## External catalog

Open **Menu → Update Library** and provide a public JSON URL. The endpoint must
allow cross-origin browser requests (CORS). A complete example is available at
[`docs/catalog.sample.json`](docs/catalog.sample.json).

## Run locally

```sh
flutter pub get
flutter run
```

The web app is automatically deployed to GitHub Pages when changes are pushed
to the `main` branch.
