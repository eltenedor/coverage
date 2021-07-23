![main workflow](https://github.com/eltenedor/coverage/actions/workflows/main.yml/badge.svg)
[![codecov](https://codecov.io/gh/eltenedor/coverage/branch/main/graph/badge.svg?token=Y37BJJW9R8)](https://codecov.io/gh/eltenedor/coverage)
![GitHub last commit](https://img.shields.io/github/last-commit/eltenedor/coverage)

# Code Coverage Example Directory

Please check out the info on HedgeDoc: https://demo.hedgedoc.org/De7UVq0aSUmHEswaf0i-vw?both

We will first explain on how tu use this repo locally and outline the autmatization that runs entirely on GitHub servers.

# Directory structure

* `/lib` contains the module `Hello.pm`
* `/t` contains the test
* `.github/workflow` contains the yaml file for the workflow

# How to run the test suite locally in 3 Steps

1.  Clone the repository to your machine
2.  Pull and run the docker-container to `build` the project
```bash
docker run -it --rm --name coverage-example  -v `pwd`:`pwd` -w `pwd` eltenedor/coverage-perl:latest perl Build.PL
```
3. Run `cover` in order to produce the coverage summary
```bash
docker run -it --rm --name coverage-example  -v `pwd`:`pwd` -w `pwd` eltenedor/coverage-perl:latest cover -test
```
If everything runs fine, you should get the output message:
```
HTML output written to /your-working-directory/coverage/cover_db/coverage.html
done.
```

You can take a look at the output by opening the file `cover_db/coverage.html`

![image](https://user-images.githubusercontent.com/3385756/126485732-2ccafde9-0b14-47d9-9ad0-7566b5c62dc8.png)

# How this Repository Works

This GitHub repository is using GitHub actions in order to mimic the above procedure in order to
* run the tests automatically on each push
* save the coverage report as an *artifact* on GitHub
* push the coverage report to the service `codecov` in order to
    * to make the report accessible without downloading the *arfifact*
    * generate a Badge for the repository, with the overall coverage. 

## Defining the GitHub Action

The workflow is specified by the file `.github/workflows/main.yml` which can be defided into multiple sections.

### Header

Here we specify a name for the workflow and `on` which ocasions it should respond to a trigger event: 

```yaml
name: Unit Tests

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
```

In this case the action runs only on the `main` branch when someone pushes to it or makes a pull_request.

### Job

After the the first specified job uses the Docker image `eltenedor/coverage-perl:latest`

```yaml
  coverage:
    runs-on: ubuntu-latest
    container: eltenedor/coverage-perl:latest
    steps:
```

and then runs the different steps:

#### Build the project and run the test
```yaml
      - uses: actions/checkout@v2
      - name: Build project and run tests
        run: |
          perl Build.PL 
          cover -test
```

#### Upload the artifact

```yaml
      - uses: actions/upload-artifact@v2
        with:
          name: coverage-report
          path: cover_db/
```

#### Push the coverage report to codecov

This step uses products from the previous steps, namely the `cover_db` folder. The Token stems from the the codecov app that has been linked to the repository and saved to the repository secrets.

```yaml
      - name: push coverage analysis
        env:
          CODECOV_TOKEN: ${{ secrets.CODECOV_TOKEN }}
        run: cover -report codecov
```

## Inspecting the Action

* Got tho the `actions` tab on the repository main page. 
* Choose one of the workflow runs
* explore the output of the job `coverage` or donwload the artifacts

## Setting the automatization

You can either start from a fork or copy the necessary files. Either way, you will not have access to the secret `CODECOV_TOKEN` used by this repository. Instead, head over to  [codecov.io](https://about.codecov.io/) and login via GitHub, connect the repo and look for the `Repository Upload Token` in the `Settings` section. Save this token to your repositorys `Secrets` on GitHub.

# Badges

The badges are (dynamic) `.svg`-files that can be put on any webpage and that may change their look depending on further parameters. For example, this is the badge to output whether the tests went through without any problems. 

`![main workflow](https://github.com/eltenedor/coverage/actions/workflows/main.yml/badge.svg)`

# Further Links and References

* Post on Stackoverflow https://stackoverflow.com/questions/533553/
* codecov, the third party tool used for postprocessing: https://about.codecov.io/ (free for open source)
* A large variety of useful repository badges: https://shields.io/
