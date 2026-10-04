# Customization and code guide

The implementation is in `QuickQuestionAuto.cs`. Rebuild with `./build.ps1 -Test` after changing it. The public source contains generic test fixtures, not a captured assessment or conversation.

## User settings

Select the monitor and ChatGPT window in the app. Upload wait is saved with the monitor selection in `settings-v3.json` beside the executable. The question limit and automatic/preview selection are chosen in the interface each run. Monitor indexing can change when displays are disconnected; recheck the dropdown.

## Prompt and response format

The prompt is constructed in `Run()`. Keep the randomly generated current request code and the exact response fields when changing the wording:

```text
RESULT 234567
OPTION 2
CLICK 569 438
NEXT 621 707
```

`OPTION` accepts 1 through 99. `NEXT NONE` represents a missing Next button; `RESULT 234567` followed by `UNKNOWN` pauses the run. `ParseResult()` validates the response. Changing the protocol requires matching parser changes and regression tests.

Screen coordinates are normalized across the whole captured image, 0 through 1000. `ToScreen()` adds the monitor origin and scales to actual pixels. If you introduce a cropped capture, use the crop's bounds for conversion; reusing full-monitor bounds would misplace clicks.

## Different layouts

In `Run()`, `watch` defines the middle question/answer region. It currently starts at one quarter of screen height and covers three fifths of screen height. It is also used to reject clicks outside that region. Adjust this only after checking a synthetic preview at your resolution.

The Next-label crop is centered on the proposed coordinate. `Recognize()` reads it, and a regular expression requires Next and rejects Finish/Submit/Complete. For localization, update both the prompt and label checks consistently. Preserve rejection of final actions.

Do not remove the same-monitor overlap check alone to claim single-monitor support. That feature requires explicit window activation before capture and verification that the selected quiz is visible. It is not implemented in this release.

## Timing and keyboard shortcuts

Upload wait is exposed in the interface. Reply polling, the three-minute deadline, confirmation reads, and navigation settling are in `Run()`. Profile these stages before reducing delays; a shorter delay can lead to an incomplete upload or stale capture.

Hotkeys are registered in the constructor's `Shown` handler: Ctrl+Shift+Q starts, Ctrl+Shift+S stops. The matching IDs are handled in `WndProc()`. Preserve cancellation checks before mouse actions.

## Readers and input

- `AccessibleText()` and `ReadAccessibleText()`: Windows UI Automation reading.
- `Recognize()` and `ReadAnswer()`: Windows OCR fallback.
- `CaptureArea()`: monitor capture.
- `ClickAt()` and `ValidatePoint()`: focus and target-window checks before native mouse input.
- `Signature()` and `Difference()`: image-change heuristics.

Changing the chat provider requires matching the paste behavior, response protocol, and readable window. A matching title alone does not establish compatibility. API integration would be a separate feature.

## Validation

Run `./build.ps1 -Test`, then preview on a dummy practice page before enabling mouse actions. Test negative monitor origins, display scaling, variable option counts, cancellation, missing Next, moved windows, and stale/incomplete responses. Automated self-tests do not prove real-world answer correctness.

