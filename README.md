# GESTA daily pipeline

A GitHub Actions workflow that has Claude build one new catalogue entry every
day at 10:00 AM and open a pull request. Merging the PR publishes it.

## One-time setup (about 15 minutes)

1. Create a GitHub repository (private is fine) and push this folder's contents  to it as the repo root. Keep the layout: site/, pipeline/, .github/, netlify.toml.
2. Netlify: New site -> Import from GitHub -> pick the repo. Build command: none.
   Publish directory: site (netlify.toml already sets this). Every merge to main
   now deploys automatically. Set your site name under Site settings.
3. Get an Anthropic API key at console.anthropic.com (needs billing enabled).
   In the GitHub repo: Settings -> Secrets and variables -> Actions ->
   New repository secret -> name ANTHROPIC_API_KEY, value your key (sk-ant-...).
4. Test it: repo -> Actions -> "GESTA daily battle" -> Run workflow. In ~10-25
   minutes a pull request appears titled "GESTA daily: <Battle>". Review the
   preview, merge, and Netlify ships it.
5. Done. It now runs itself every day at 14:00 UTC.

## Daily routine
One notification, one skim of the PR (Netlify can give deploy previews per PR),
one tap on Merge. That 60-second review is the editorial gate; keep it.

## Notes
- Schedule is UTC. 14:00 UTC = 10 AM New York in summer; change the cron to
  "0 15 * * *" for winter, or leave it and accept 9 AM.
- GitHub disables schedules on public repos after 60 days without commits;
  daily merges count as activity, so this never triggers.
- Cost: one entry is typically a few dollars of Sonnet API usage per day.
- The queue is pipeline/queue.yaml. Reorder or add entries freely; the
  workflow always builds the first pending one. Roughly three weeks are loaded.
- Quality rules live in pipeline/FORMAT.md. Edit that file to change the house style.
- Full auto (no review): change the last prompt step in
  .github/workflows/daily-gesta.yml to commit and push to main directly.
  Not recommended until you have watched a few PRs come through clean.
