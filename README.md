# coverage

Build the docker file
```bash
docker build -t coverage-perl .
```

Run the script
```bash
docker run --rm -it  -v `pwd`:/usr/src/app coverage-perl prove -v -Ilib t/hello.t
```
