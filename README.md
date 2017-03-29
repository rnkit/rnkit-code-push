[![npm][npm-badge]][npm]
[![react-native][rn-badge]][rn]
[![MIT][license-badge]][license]
[![bitHound Score][bithound-badge]][bithound]
[![Downloads](https://img.shields.io/npm/dm/rnkit-code-push.svg)](https://www.npmjs.com/package/rnkit-code-push)

Push code updates to your react-native apps. [React Native][rn].

[**Support me with a Follow**](https://github.com/simman/followers)

[npm-badge]: https://img.shields.io/npm/v/rnkit-code-push.svg
[npm]: https://www.npmjs.com/package/rnkit-code-push
[rn-badge]: https://img.shields.io/badge/react--native-v0.28-05A5D1.svg
[rn]: https://facebook.github.io/react-native
[license-badge]: https://img.shields.io/dub/l/vibe-d.svg
[license]: https://raw.githubusercontent.com/rnkit/rnkit-code-push/master/LICENSE
[bithound-badge]: https://www.bithound.io/github/rnkit/rnkit-code-push/badges/score.svg
[bithound]: https://www.bithound.io/github/rnkit/rnkit-code-push

## Getting Started

First, `cd` to your RN project directory, and install RNMK through [rnpm](https://github.com/rnpm/rnpm) . If you don't have rnpm, you can install RNMK from npm with the command `npm i -S rnkit-code-push` and link it manually (see below).

### iOS

* #### React Native < 0.29 (Using rnpm)

  `rnpm install rnkit-code-push`

* #### React Native >= 0.29
  `$npm install -S rnkit-code-push`

  `$react-native link rnkit-code-push`



#### Manually
1. Add `node_modules/rnkit-code-push/ios/RNKitCodePush.xcodeproj` to your xcode project, usually under the `Libraries` group
1. Add `libRNKitASPickerView.a` (from `Products` under `RNKitCodePush.xcodeproj`) to build target's `Linked Frameworks and Libraries` list



### Android

* #### React Native < 0.29 (Using rnpm)

  `rnpm install rnkit-code-push`

* #### React Native >= 0.29
  `$npm install -S rnkit-code-push`

  `$react-native link rnkit-code-push`

#### Manually
1. JDK 7+ is required
1. Android NDK is required
1. Add the following snippet to your `android/settings.gradle`:
  ```gradle
include ':rnkit-code-push'
project(':rnkit-code-push').projectDir = new File(rootProject.projectDir, '../node_modules/rnkit-code-push/android')

  ```
1. Declare the dependency in your `android/build.gradle`
  ```gradle
  dependencies {
      ...
      compile project(':rnkit-code-push')
  }

  ```
1. Import `import io.rnkit.codepush.UpdatePackage;` and register it in your `MainActivity` (or equivalent, RN >= 0.32 MainApplication.java):

  ```java
  @Override
  protected List<ReactPackage> getPackages() {
      return Arrays.asList(
              new MainReactPackage(),
              new UpdatePackage()
      );
  }
  ```

Finally, you're good to go, feel free to require `rnkit-code-push` in your JS files.

Have fun! :metal:

## Documentation

- [Document](https://update.rnkit.io/docs/)

## Contribution

- [@simamn](mailto:liwei0990@gmail.com) The main author.

## Thanks

[@reactnativecn](https://github.com/reactnativecn) - [react-native-pushy](https://github.com/reactnativecn/react-native-pushy) ReactNative中文网推出的代码热更新服务

**此项目代码fork自 react-native-pushy**

## Questions

Feel free to [contact me](mailto:liwei0990@gmail.com) or [create an issue](https://github.com/rnkit/rnkit-code-push/issues/new)

> made with ♥
