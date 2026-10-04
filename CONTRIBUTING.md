# Contributing

1. Fork and clone the repository.
2. Install the build prerequisites in README.md.
3. Make a focused change and run `./build.ps1 -Test`.
4. Test UI changes in preview mode with synthetic practice material.
5. Open a pull request describing the problem, resulting behavior, and validation.

Never commit logs, runtime settings, API keys, real assessment screenshots, or personal conversations. Prefer synthetic screenshots and parser fixtures. Preserve current-request validation, cancellation, target-window checks, and explicit handling of final actions.

Useful future work includes a proper project file, single-monitor mode, mixed-DPI testing, attachment-readiness detection, better navigation verification, and log rotation. These are not implemented features.
