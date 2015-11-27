/*
 * FizzBuzz.js
 *
 * @author: Alisue <lambdalisue@hashnote.net>
 *
 */
(function() {
  "use strict";

  function FizzBuzz(n) {
    let fizzbuzz = function (n) {
	let mod3 = n % 3 == 0;
	let mod5 = n % 5 == 0;

	if (mod3 && mod5) {
	  return 'FizzBuzz';
	} else if (mod3) {
	  return 'Fizz';
	} else if (mod5) {
	  return 'Buzz';
	} else {
	  return n;
	}
    };
    for (let i=0; i<n; i++) {
	console.log(fizzbuzz(i + 1));
    }
  }

  FizzBuzz(30);
})();
