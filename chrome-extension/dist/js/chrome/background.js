(function() {
  var Actions;

  chrome.runtime.onInstalled.addListener(function() {
    return chrome.declarativeContent.onPageChanged.removeRules(void 0, function() {
      return chrome.declarativeContent.onPageChanged.addRules([
        {
          conditions: [],
          actions: [new chrome.declarativeContent.ShowPageAction]
        }
      ]);
    });
  });

  chrome.tabs.onUpdated.addListener(function(tabId, changeInfo, tab) {
    if (changeInfo && changeInfo.status === 'complete') {
      return chrome.tabs.sendMessage(tabId, {
        event_name: 'tab-updated'
      });
    }
  });

  chrome.runtime.onMessage.addListener(function(data, event, sendResponse) {
    if (!Actions[data.action]) {
      return;
    }
    return Actions[data.action](data.data, event);
  });

  Actions = {
    ga_event: function(data, event) {
      return window.ga('send', 'event', data.name, JSON.stringify(data.data));
    },
    ga_set_user_id: function(data, event) {
      if (!data.user_id) {
        return;
      }
      return window.ga('set', 'userId', data.user_id);
    },
    set_uninstall_url: function(data) {
      return chrome.runtime.setUninstallURL(data.url);
    }
  };

  // Google Analytics
  (function(i, s, o, g, r, a, m) {
    i['GoogleAnalyticsObject'] = r;
    i[r] = i[r] || function() {
      (i[r].q = i[r].q || []).push(arguments);
    };
    i[r].l = 1 * new Date;
    a = s.createElement(o);
    m = s.getElementsByTagName(o)[0];
    a.async = 1;
    a.src = g;
    m.parentNode.insertBefore(a, m);
  })(window, document, 'script', 'https://www.google-analytics.com/analytics.js', 'ga');

  ga('create', 'UA-118712071-1', 'auto'); //TODO: Put this somewhere else

  ga('set', 'checkProtocolTask', function() {});

  ga('require', 'displayfeatures');

  ga('send', 'pageview', '/_generated_background_page.html');

}).call(this);
