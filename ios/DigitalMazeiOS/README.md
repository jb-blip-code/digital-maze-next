# DigitalMaze iOS Wrapper

This folder contains a native iOS wrapper for the game using `WKWebView` + `CoreMotion`.

## What it does
- Loads `www/index.html` from app bundle.
- Sends gyroscope tilt to the game via `window.setNativeTilt(x, y)`.

## XcodeGen
This folder includes `project.yml`.

Generate project:
```bash
cd ios/DigitalMazeiOS
xcodegen generate
```

Open in Xcode:
```bash
open DigitalMazeiOS.xcodeproj
```

## Requirements
- Install XcodeGen (for example: `brew install xcodegen`).
- Motion permission is configured in generated Info.plist (`NSMotionUsageDescription`).

## Sync web changes
When you update root `index.html`, copy it to `www/index.html`.
