# Portfolio Sample iOS App: MemeMe

- For making & sharing memes.
- Current version will create random memes for demo.
	- It downloads the random images concurrently.
	- It also displays the download counter in the nav bar as displayed in the first image below.
- Adaptive layout. Any orientation at any size.
- Works on any device running iOS 10.


## Output

![Collection View](Output1.png)

![Edit Meme](Output2.png)


## Requirements

- Built with Swift 3.3 and Xcode 9.3.1.
- CocoaPods
- Not required but design assets managed by PaintCode.


## How to build
- Open the .xcworkspace file (not .xcodeproj file)

### For simulator
- Build

### For device
- Open the project settings by clicking on the Project in the Project Navigator on the left side.
- Select the "MemeMe" target.
- In General (tab) -> Identity (section) change the bundle identifier to your own bundle identifier.
- Build