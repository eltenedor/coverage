# Code Coverage Example Directory

Please check out the info on HedgeDoc: https://demo.hedgedoc.org/De7UVq0aSUmHEswaf0i-vw?both

Build the docker file
```bash
docker build -t coverage-perl .
```

Run the script in order to just run the test:
```bash
docker run --rm -it  -v `pwd`:/usr/src/app coverage-perl prove -v -Ilib t/hello.t
```

If you also want a coverage analysis you first need to build the project as described [here](https://stackoverflow.com/questions/533553/perl-build-unit-testing-code-coverage-a-complete-working-example):

```
perl -Ilib Build.PL
./Build test
cover -test
```

output of the coverage analysis will reside in `./cover_db/coverage.html` and look similar to this one:

![image](https://user-images.githubusercontent.com/3385756/126485732-2ccafde9-0b14-47d9-9ad0-7566b5c62dc8.png)

If you have a codecov token in your environment, you can run
```
cover -report codecov
```    
and the results will be pushed to codecov. The badge will be updated accordingly, see below.

# Badges

![main workflow](https://github.com/eltenedor/coverage/actions/workflows/main.yml/badge.svg)
[![codecov](https://codecov.io/gh/eltenedor/coverage/branch/main/graph/badge.svg?token=Y37BJJW9R8)](https://codecov.io/gh/eltenedor/coverage)
![GitHub last commit](https://img.shields.io/github/last-commit/eltenedor/coverage)

