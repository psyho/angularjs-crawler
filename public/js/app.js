(function(angular) {
  var app = angular.module('pet-surfer', ['ng', 'ngResource']);

  function CatalogController($scope, hosts) {
    $scope.hosts = hosts.all();
  }
  app.controller('CatalogController', CatalogController);

  function HostController($scope, $routeParams, hosts) {
    $scope.host = hosts.find($routeParams.hostId);
  }
  app.controller('HostController', HostController);

  function NavBarController($scope, $timeout) {
    $scope.login = "psyho";
    $scope.lastRefresh = new Date();

    $scope.delayedText = $timeout(function() {
      return "This text appears after 10s.";
    }, 10000);
  }
  app.controller('NavBarController', NavBarController);

  app.service('hosts', function($resource) {
    var hosts = $resource('/api/hosts');
    var host = $resource('/api/host/:id');

    return {
      all: function() {
        return hosts.query();
      },
      find: function(id) {
        return host.get({id: id});
      }
    };
  });

  app.filter('hostPath', function() {
    return function(host) {
      return "/host/"+host.id;
    };
  });


  app.config(function($routeProvider, $locationProvider) {
    $routeProvider.when('/', {
      templateUrl: '/partials/hosts.html',
      controller: CatalogController
    });

    $routeProvider.when('/host/:hostId', {
      templateUrl: '/partials/host.html',
      controller: HostController
    });

    $locationProvider.html5Mode(true);
  });
})(angular);
