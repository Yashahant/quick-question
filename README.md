# Quick Question

A small Windows desktop tool for screenshot-based practice questions. It captures one selected monitor, sends a prompt and image to your existing ChatGPT Windows conversation, reads the answer, and optionally selects the answer and advances in the practice window.

No browser extension or API key is required. This is an independent community project, not affiliated with OpenAI or an assessment provider.

## Download and run

Download the Windows ZIP from [Releases](https://github.com/Yashahant/quick-question/releases). Extract it into a writable folder and run `QuickQuestion.exe`. The ZIP includes the executable, README, and MIT license, with no personal logs or settings. Follow the requirements and preview setup below. Developers can build from source instead.
## Current requirements

- 64-bit Windows with .NET Framework 4.7.2 or later and Windows OCR support. Development and local testing used Windows 11; other versions and layouts are not certified.
- Two monitors: a maximized practice window on one and ChatGPT on the other. Single-monitor support is not implemented.
- A signed-in ChatGPT desktop window that exposes readable accessibility text, or a visible response readable by Windows OCR.
- An installed OCR language appropriate for the response. The prompts use English.
- Internet access for ChatGPT. Responses and service limits depend on your account.

## Build from source

Install the .NET Framework 4.7.2 Developer Pack from Microsoft's official download site, then open PowerShell in this repository:

```powershell
./build.ps1 -Test
./bin/QuickQuestion.exe
```

The build script uses the Windows Framework C# compiler, reference assemblies from the Developer Pack, and Windows WinMetadata files. No third-party packages are required. It resolves paths from the local installation rather than a developer's username. If scripts are blocked, follow your system's script policy; do not disable organizational protections.

A CS1701 reference-version warning can occur with Windows metadata. It also occurs on the locally tested build; compilation and self-tests must still succeed.

The self-test covers response parsing, five-option questions, stale/incomplete replies, invalid coordinates, missing Next, negative monitor origins, and an actual Windows OCR round-trip. It does not send a prompt or click another app.

## Use

1. Close older copies of Quick Question so hotkeys do not conflict.
2. Keep your practice page maximized on the question monitor. Put ChatGPT fully on the other monitor.
3. Launch the app. Select the question monitor and the ChatGPT window; use Refresh if necessary.
4. Uncheck automatic clicking for your first preview. Set Questions to 1.
5. Click ChatGPT's empty message box once. Return to Quick Question and press Start, or use Ctrl+Shift+Q.
6. The app pastes its prompt and screenshot, waits for the attachment, and presses Enter. It reads a response tagged with the current request code.
7. In preview mode, check the red answer marker and green Next marker. Close the preview to return to setup.
8. Enable automatic clicking only after checking the positions. Start with a small question limit.
9. Press Ctrl+Shift+S or the visible Stop button to stop. An answer already clicked remains selected.

At the question limit, the last answer is selected but Next is not clicked. Final Finish/Submit actions are not automated. Use only with practice material where assistance and window switching are allowed.

## Customize for your computer

- Choose your monitor and ChatGPT window through the interface; there is no hard-coded quiz URL or account.
- Set Upload wait to allow sufficient time for the screenshot attachment (default 2 seconds).
- Set Questions for each run (default 1).
- Button coordinates are requested again for every screenshot; no button calibration is required.
- Keep resolution, zoom, window positions, and the question unchanged during a run.

See [Customization and code guide](CUSTOMIZATION.md) for prompts, keyboard shortcuts, supported layouts, timing, and code changes.

## Privacy

The entire selected monitor is captured, including any visible personal information. That image and the generated prompt are sent to the ChatGPT conversation you selected, subject to that service's data settings. Close unrelated content before capture.

Accessibility text is read locally from the selected window; Windows OCR runs locally as a fallback. This app has no separate telemetry or API key. It does not save screenshot files. Screenshot data is held in memory and placed on the Windows clipboard, where clipboard history or synchronization settings may retain it.

Runtime files are currently written beside the executable: `settings-v3.json` (monitor index and upload delay), `activity.log` (status messages and sometimes request IDs/coordinates), and `self-test.txt` when tests run. They are excluded from Git. Logs are not automatically rotated. Do not publish them without reviewing their contents. The executable needs a writable folder.

## Troubleshooting and limitations

- **Keeps waiting:** check that the complete reply is loaded in ChatGPT. For OCR, keep it visible. The app accepts only its current request code and a complete structured result.
- **Image did not upload:** increase Upload wait. The current app uses a fixed delay rather than attachment-readiness detection.
- **Nothing pasted or sent:** click the empty ChatGPT message box before starting; focus must remain there during paste/send.
- **Shortcut is in use:** close older copies or change the hotkeys in source. The app currently warns about registration failure; the Stop button remains available.
- **OCR unavailable:** install a matching Windows OCR language. Accessibility reading is tried first, but OCR is still used to check Next.
- **No click:** the target can be covered, moved, outside the accepted area, or changed while waiting. Read the status message.
- **Next not recognized:** supported controls must visibly contain an English Next label. Missing or final-action labels pause the run.
- **Wrong markers:** stop and use preview. Vision answers and coordinates are estimates and can be wrong.

The automatic option region is currently between 25% and 85% of monitor height. Navigation detection uses image differences, not a verified question identifier. Mixed DPI settings, different editors, popups, and browser layouts can affect operation. This release does not implement coding-editor insertion or local execution of generated code.

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md). For bug reports, include the app version, Windows version, monitor arrangement/scaling, steps, and the status message. Use a synthetic example; omit personal screenshots, credentials, and complete conversations.

## License

[MIT](LICENSE).


