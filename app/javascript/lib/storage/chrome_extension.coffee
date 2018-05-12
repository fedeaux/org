class ChromeExtensionStorage
  get: (keys..., done) ->
    chrome.storage.local.get keys, (result) ->
      done(result) if done

  set: (object, done) ->
    chrome.storage.local.set object, ->
      done(object) if done

export default ChromeExtensionStorage
