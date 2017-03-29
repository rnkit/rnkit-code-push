/**
 * <h4>RNKit-Code-Push</h4>
 * <p>rnkit</p>
 * @version 1.0.0
 * @author SimMan <liwei0990@gmail.com>
 * @copyright 2011-2017 RNKit.io, Inc.
 */
const RNKitCodePushModule = require('react-native').NativeModules.RNKitCodePush

let apiHost = 'https://update.rnkit.io/api/v1'

export default class RNKitCodePush {
  constructor (appKey, isDev = false, isReport = true, host = null, args = {}) {
    if (!appKey.length) {
      throw new Error('appKey is required!')
    }
    this.appKey = appKey
    this.isDev = isDev
    this.report = isReport
    this.host = host || apiHost
    this.args = args
  }

  get downloadRootDir () {
    return RNKitCodePushModule.downloadRootDir
  }

  get packageVersion () {
    return RNKitCodePushModule.packageVersion
  }

  get currentVersion () {
    return RNKitCodePushModule.currentVersion
  }

  get isFirstTime () {
    return RNKitCodePushModule.isFirstTime
  }

  get isRolledBack () {
    return RNKitCodePushModule.isRolledBack
  }

  get deviceInfo () {
    return RNKitCodePushModule.deviceInfo
  }

  // check update from service
  async checkUpdate () {
    const resp = await fetch(`${this.host}/update/check`, {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'RNKit-UA': this.report ? this.deviceInfo : ''
      },
      body: JSON.stringify({
        app_key: this.appKey,
        dev: this.isDev,
        args: this.args,
        package_version: this.packageVersion,
        hash: this.currentVersion
      })
    })

    const {
      errno,
      errmsg,
      data
    } = await resp.json()
    if (errno !== 0) {
      throw new Error(errmsg)
    }
    return data
  }

  async downloadUpdate (options) {
    if (!options.update) {
      return
    }

    if (options.diffUrl) {
      await RNKitCodePushModule.downloadPatchFromPpk({
        updateUrl: options.diffUrl,
        hashName: options.hash,
        originHashName: this.currentVersion
      })
    } else if (options.pdiffUrl) {
      await RNKitCodePushModule.downloadPatchFromPackage({
        updateUrl: options.pdiffUrl,
        hashName: options.hash
      })
    } else {
      await RNKitCodePushModule.downloadUpdate({
        updateUrl: options.updateUrl,
        hashName: options.hash
      })
    }
    return options.hash
  }

  async switchVersion (hash) {
    RNKitCodePushModule.reloadUpdate({
      hashName: hash
    })
  }

  async switchVersionLater (hash) {
    RNKitCodePushModule.setNeedUpdate({
      hashName: hash
    })
  }

  async markSuccess () {
    RNKitCodePushModule.markSuccess()
    await fetch(`${this.host}/update/mark_success`, {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'RNKit-UA': this.report ? this.deviceInfo : ''
      },
      body: JSON.stringify({
        app_key: this.appKey,
        dev: this.isDev,
        args: this.args,
        package_version: this.packageVersion,
        hash: this.currentVersion
      })
    })
  }
}
