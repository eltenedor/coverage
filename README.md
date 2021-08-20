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

## Prerequesites

You can either start from a fork or copy the necessary files. Either way, you will not have access to the secret `CODECOV_TOKEN` used by your repository. Instead, head over to  [codecov.io](https://about.codecov.io/) and login via GitHub, connect the repo and look for the `Repository Upload Token` in the `Settings` section. Save this token to your repositorys `Secrets` on GitHub.

In case of the repository `coverage` in the namespace `eltenedor` the token is to be found at 

[`https://app.codecov.io/gh/eltenedor/coverage/settings`](https://app.codecov.io/gh/eltenedor/coverage/settings)

![image](https://user-images.githubusercontent.com/3385756/130256016-c9587ce0-e48a-4e92-aa2e-0e1a89b29e01.png)

**Copy** the token and head over to your repository `Secrets`, in the case of this repository visit

[`https://github.com/eltenedor/coverage/settings/secrets/actions`](https://github.com/eltenedor/coverage/settings/secrets/actions)

and **add** a secret

![image](https://user-images.githubusercontent.com/3385756/130256785-6a7f9f4b-577f-4e95-a5eb-8536ef1c5b2c.png)

Name the secret `CODECOV_TOKEN` and copy+paste the token from codecov

![image](https://user-images.githubusercontent.com/3385756/130256928-62301c6d-686c-4692-b94f-b3a57d1b98de.png)

Finish by click **Add secret**. Your newly added secret should now show up on the secrets page of your repo:

![image](https://user-images.githubusercontent.com/3385756/130257083-e64a1017-0e7f-4444-819c-99874f2b39f5.png)


## Defining the GitHub Action

The workflow is specified by the file `.github/workflows/main.yml` which can be defided into multiple sections.

### Header

Here, we specify a name for the workflow and `on` which ocasions it should respond to a trigger event: 

```yaml
name: Unit Tests

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
```

In this case, the action runs only on the `main` branch when someone pushes to it or makes a pull_request.

### Job

Specify the Docker image `eltenedor/coverage-perl:latest`

```yaml
  coverage:
    runs-on: ubuntu-latest
    container: eltenedor/coverage-perl:latest
    steps:
```

Runs the different steps:

#### Build the project, run the test
```yaml
      - uses: actions/checkout@v2
      - name: Build project and run tests
        run: |
          perl Build.PL 
          cover -test
```

#### Push the coverage report to codecov

This step uses products from the previous steps, namely the `cover_db` folder. The token stems from the the codecov app that has been linked to the repository and saved to the repository secrets.

```yaml
      - name: push coverage analysis
        env:
          CODECOV_TOKEN: ${{ secrets.CODECOV_TOKEN }}
        run: cover -report codecov
```

## Inspecting the Action

* Got to the `actions` tab on the repository main page. 
* Choose one of the workflow runs.
* Explore the output of the job `coverage` or donwload the artifacts.



# Badges

The badges are (dynamic) `.svg`-files that can be put on any webpage and that may change their look depending on further parameters. For example, this is the badge to output whether the tests went through without any problems. 

`![main workflow](https://github.com/eltenedor/coverage/actions/workflows/main.yml/badge.svg)`

# Further Links and References

* Post on Stackoverflow https://stackoverflow.com/questions/533553/
* codecov, the third party tool used for postprocessing: https://about.codecov.io/ (free for open source)
* A large variety of useful repository badges: https://shields.io/
