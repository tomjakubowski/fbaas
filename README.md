# FizzBuzz as a Service (FBaaS)

various implementations of FizzBuzz as a Service.

see the branch list for each implementation.

## specification

a 'natural number' is a member of the set of positive integers {1, 2, 3, …}.

### response

all successful response bodies are in UTF-8 encoded JSON. all errors are
500s with empty body, or 404s as appropriate.

### get FizzBuzz range

```` GET /fizzbuzz/a,b ````

error if ````a > b```` or if either ````a```` or ````b```` is not a natural
number. if ````b > 100000````, behavior is undefined.

otherwise given the natural number interval ````[a,b]````, respond with a
string constructed as follows:

for each ````n```` in ````[a,b]````:

1. if ````n```` is evenly divisible by 3, append the string ````"Fizz"````.
2. if ````n```` is evenly divisible by 5, append the string ````"Buzz"````.
3. if ````n```` is evenly divisible by neither 3 nor 5, append ````n```` as a string.
4. append a line-feed character ````"\n"````

#### example request

```` GET /fizzbuzz/1,20 ````

#### example response

    "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz\n13\n14\nFizzBuzz\n16\n17\nFizz\n19\nBuzz\n"

