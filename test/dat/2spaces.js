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
      let mod3 = n % 3 == 0 ? 'Fizz' : '';
      let mod5 = n % 5 == 0 ? 'Buzz' : '';
      return (mod3 + mod5) || n;
    };
    for (let i=0; i<n; i++) {
      console.log(fizzbuzz(i + 1));
    }
  }

  FizzBuzz(30);
})();
