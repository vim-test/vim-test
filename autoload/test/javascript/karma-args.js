'use strict';

var karma = require('karma');
var argv = process.argv;
var path = require('path');

var Server = karma.Server;

// filter out the first 2 arguments, which are node & this file
argv = argv.slice(2);

var karmaConf = {};

// default karma options
var karmaArgs = {
  // default to single-run mode & disable watching to reduce output clutter
  singleRun: true,
  autoWatch: false,

  // log almost nothing to reduce output to just the tests
  // NOTE: This value is a constant given directly by karma, but I do not know
  // of a way to programmatically get at it, so we are hard-coding it.
  logLevel: 'OFF',

  // use the karma configuration file in the current folder by default
  configFile: path.resolve('karma.conf'),
};

argv.forEach(function(karmaArg, karmaArgIndex) {
  // ignore non-options (those without a dash) - these will have been handled by
  // a dash-option beforehand
  if(karmaArg.charAt(0) !== '-') {
    return;
  }

  // handle special options that karma can't, mostly arrays
  if(karmaArg === '-b' || karmaArg === '--browsers') {
    if(!Array.isArray(karmaArgs.browsers)) {
      karmaArgs.browsers = [];
    }

    var browserArg = argv[karmaArgIndex + 1];
    karmaArgs.browsers.push(browserArg);
  }
  else if(karmaArg === '--files') {
    if(!Array.isArray(karmaArgs.files)) {
      karmaArgs.files = [];
    }

    var fileArg = argv[karmaArgIndex + 1];
    karmaArgs.files.push(fileArg);
  }
  else if(karmaArg === '--exclude') {
    if(!Array.isArray(karmaArgs.exclude)) {
      karmaArgs.exclude = [];
    }

    var excludeArg = argv[karmaArgIndex + 1];
    karmaArgs.exclude.push(excludeArg);
  }
  else if(karmaArg === '--frameworks') {
    if(!Array.isArray(karmaArgs.frameworks)) {
      karmaArgs.frameworks = [];
    }

    var excludeArg = argv[karmaArgIndex + 1];
    karmaArgs.frameworks.push(excludeArg);
  }
  else if(karmaArg === '--config-file') {
    var confFileArg = path.resolve(argv[karmaArgIndex + 1]);
    karmaArgs.configFile = confFileArg;
  }
  // otherwise, treat it as just any other option
  else {
    var currentArg = toCamelCase(karmaArg.replace(/^-+/, ''));

    // if there is no non-dash option after this, treat it as a boolean
    if(karmaArgIndex === argv.length - 1 || argv[karmaArgIndex + 1].charAt(0) === '-') {
      // if the argument is negative (starts with no), set the normal option
      // (without the no) to false
      if(currentArg.match('no')) {
        currentArg = currentArg.replace(/^no/, '');
        currentArg = currentArg.charAt(0).toLocaleLowerCase() + currentArg.slice(1);
        karmaArgs[currentArg] = false;
      } else {
        karmaArgs[currentArg] = true;
      }
    } else {
      karmaArgs[currentArg] = argv[karmaArgIndex + 1];
    }
  }
});

var server = new Server(karmaArgs).start();

function toCamelCase(str) {
  // make extra-sure we are dealing with a string
  if(str == null || str.toLocaleString !== 'function') {
    str = '' + str;
  }
  str = str.toLocaleString();

  return str.replace(/(-+|\s+)\w/g, function(snakeCase) {
    return snakeCase[snakeCase.length - 1].toLocaleUpperCase();
  });
}
