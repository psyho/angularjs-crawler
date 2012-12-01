var args = phantom.args;

if (args.length !== 1) {
  console.log("Usage: phantomjs script.js <url>");
} else {
  var page = require('webpage').create();

  page.onConsoleMessage = function(msg) {
    if(msg === 'PHANTOM_JS_CAN_DUMP_CONTENT_NOW') {
      console.log(page.content);
      phantom.exit();
    }
  };

  page.open(args[0], function() {
    page.evaluate(function() {
      var $injector = angular.element(document.getElementsByTagName('body')).injector();
      $injector.invoke(function($browser) {
        $browser.notifyWhenNoOutstandingRequests(function() {
          console.log('PHANTOM_JS_CAN_DUMP_CONTENT_NOW');
        });
      });
    });
  });
}

