# TODO: Deploy MkDocs to Strato Webspace

## Status: Pending

## What's ready

- [x] MkDocs Material configured (`mkdocs.yml`)
- [x] All 18 lessons in `docs/lessons/`
- [x] Landing page (`docs/index.md`)
- [x] Lab Setup page with download links (`docs/setup.md`)
- [x] Downloadable Docker files (`docs/downloads/`)
- [x] Local build works (`mkdocs build`)
- [x] Local preview works (`mkdocs serve`)
- [x] GitHub Actions workflow (`.github/workflows/deploy.yml`) — optional, for GitHub Pages

## What's left to do

### 1. Decide on the URL

Pick where the tutorial will live, e.g.:

- `https://christianfrenz.de/linux-tutorial/`
- `https://learn.christianfrenz.de/`
- Or a subdirectory of your existing site

### 2. Update `site_url` in `mkdocs.yml`

Change this line to match your chosen URL:

```yaml
site_url: https://your-domain.de/your-path/
```

### 3. Build the site

```bash
.venv/bin/mkdocs build
```

This generates the `site/` folder with all static HTML/CSS/JS files.

### 4. Upload to Strato

**Option A — FTP client (FileZilla / Cyberduck):**

1. Connect to your Strato FTP server
2. Navigate to the target directory
3. Upload everything inside `site/` (not the folder itself — the contents)

**Option B — Command line (rsync over SSH, if Strato supports it):**

```bash
rsync -avz --delete site/ user@your-strato-server:/path/to/webspace/
```

**Option C — lftp (works with plain FTP):**

```bash
lftp -e "mirror -R --delete site/ /your-path/ ; quit" \
  -u username,password ftp.your-strato-server.de
```

### 5. Verify

Open the URL in a browser and check:

- [ ] Home page loads
- [ ] Navigation works (all 18 lessons)
- [ ] Mermaid diagrams render
- [ ] Code blocks have copy buttons
- [ ] Download links on Lab Setup page work
- [ ] Dark/light mode toggle works

### 6. Optional: Automate deploys

Create a `deploy.sh` script to build + upload in one step.

## Notes

- GitHub Pages requires a **public repo** on GitHub Free — not usable with private repo unless you upgrade to Pro ($4/month)
- Strato webspace has no such restriction — just upload static files
- The GitHub Actions workflow is still useful if you later make the repo public
- Remember to re-upload after every change (build → upload)
