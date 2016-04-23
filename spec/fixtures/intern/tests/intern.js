define({
  capabilities: {
  },
  reporters: [
    'Console'
  ],
  environments: [
  ],
  maxConcurrency: 1,
  loaderOptions: {
    packages: []
  },
  suites: [
    'tests/unit/*'
  ],
  functionalSuites: [
    'tests/functional/*'
  ],
  excludeInstrumentation: /^(?:tests|node_modules)\//
});
