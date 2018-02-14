# Marathon
quick benchmark testing for medium to large chunks of code

## Setup
```shell
$ bundle install
```

## Usage
Copy and paste the code you want to benchmark the 'runner' files—put the setup code (class, module, method definitions, etc) above the indicated line and the the actual bit of code you want to benchmark below. Then run
```shell
$ rake marathon
```
or 
```shell
$ rake m
```
Optionally you can run the code in any number of loops by passing an integer as an argument
```shell
$ rake marathon 1000 # will run the code 1000 times
```
To cleanup the files afterwards, simply run
```shell
$ rake marathon clean
```
