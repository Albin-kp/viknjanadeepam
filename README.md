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
- A private `/admin/` page for editing Malayalam magazine content
- Silent synchronization of published volumes in the public reader

## Administration

The administration page is available at:

`https://albin-kp.github.io/viknjanadeepam/admin/`

It supports secure sign-in, drafts, publishing, deleting, and structured
Malayalam chapter content. Public readers never see administration or update
controls.

### Supabase setup

1. Create a Supabase project.
2. Run [`supabase/schema.sql`](supabase/schema.sql) in the SQL editor.
3. Create the administrator under Authentication → Users.
4. Insert that user's UUID into `public.admin_users` using the final statement
   documented in the schema.
5. Add `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY` as GitHub Actions
   repository secrets.

## Run locally

```sh
flutter pub get
flutter run
```

The web app is automatically deployed to GitHub Pages when changes are pushed
to the `main` branch.
