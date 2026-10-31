# KRYPT AUDIO iOS build

This branch contains the generated Flutter iOS Runner project for KRYPT AUDIO.

## Build on macOS

1. Install Xcode and CocoaPods.
2. Open Terminal at the repository root.
3. Run:

```bash
flutter pub get
cd ios
pod install
cd ..
open ios/Runner.xcworkspace
```

4. In Xcode, select the `Runner` target, choose your Apple Development Team, and confirm the bundle identifier:

```text
uk.synapselabs.kryptaudio
```

5. For an unsigned/archive workflow, select **Runner > Generic iOS Device**, then use Xcode’s archive/export controls or re-sign the resulting app with your preferred sideloading tool.

The project enables the `audio` background mode for music playback. Apple signing, provisioning, and App Store/TestFlight configuration must be completed on macOS.
