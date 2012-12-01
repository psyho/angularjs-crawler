var args = phantom.args;

if (args.length !== 1) {
  console.log("Usage: phantomjs script.js <url>");
} else {
  var page = require('webpage').create();
  page.open(args[0], function() {
    console.log(page.content);
    phantom.exit();
  });
}

