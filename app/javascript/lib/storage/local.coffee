class LocalStorage
  get: (keys..., done) ->
    ret = {}

    for key in keys
      json_value = localStorage.getItem key

      try
        ret[key] = JSON.parse json_value
      catch
        ret[key] = null

    done(ret) if done

  set: (object, done) ->
    for key, value of object
      localStorage.setItem key, JSON.stringify value

export default LocalStorage
