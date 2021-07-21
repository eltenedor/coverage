# coverage

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
./Build testcover
```

output of the coverage analysis will reside in `./cover_db/coverage.html` and look similar to this one:

![image](https://user-images.githubusercontent.com/3385756/126485732-2ccafde9-0b14-47d9-9ad0-7566b5c62dc8.png)

# Badges

![main workflow](https://github.com/eltenedor/coverage/actions/workflows/main.yml/badge.svg)

