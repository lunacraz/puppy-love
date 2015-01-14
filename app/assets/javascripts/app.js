var puppyCards = angular.module('puppyCards',['ngRoute']);

puppyCards.controller('PuppyCardCtrl', function ($scope, dogsBackend){
	debugger
	console.log('Promise is now resolved: '+dogsBackend.doStuff().data)
  	$scope.data = dogsBackend.doStuff();
})

// puppyCards.factory('dogsBackend', function($http){
// 	debugger;
// 	var service = {
// 			getDogs : function(){
// 			return $http.get('/dogs').then(function(response){
// 				return response;
// 			});
// 		}
// 	}
// 	return service; 
// });

puppyCards.service('dogsBackend', function($http) {
    var myData = null;

    var promise = $http.get('/dogs').success(function (data) {
      myData = data;
    });

    return {
      promise: promise,
      setData: function (data) {
          myData = data;
      },
      doStuff: function () {
          return myData;
      }
    };
});

puppyCards.config(function($routeProvider){
  $routeProvider
    .when('/dogs',{controller:'PuppyCardCtrl',
    template:'../../views/dogs/index.html.erb',
    resolve:{
      'MyServiceData':function(MyService){
        // MyServiceData will also be injectable in your controller, if you don't want this you could create a new promise with the $q service
        return MyService.promise;
      }
    }})
  });