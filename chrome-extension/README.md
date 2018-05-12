# README

The extension depends heavly on the [backend](https://github.com/tbartercom/tat.me_backend), please make sure the backend is running and listening to `localhost:3000` before using this extension.

To watch for file changes and recompile
`project-dir $ gulp`

(node version 8.11.1)

visit `chrome://extensions/`
ensure developer mode is on, click `LOAD UNPACKED` and select the extension directory

(tip: https://chrome.google.com/webstore/detail/extensions-reloader/fimgfedafeadlieiabdeeaodndnlbhid)

## Creating a release

`gulp release` create a directory `/release` with a chrome store ready version.

(last backend version must be deployed to `tatme-backend.herokuapp.com`)
