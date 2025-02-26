# Local Build

Use this set of commands to perform a local build for tesing.

```bash
SEMVER=v0.0.999; echo ${SEMVER}
BUILD_DATE=$(gdate --utc +%FT%T.%3NZ); echo ${BUILD_DATE}
GIT_COMMIT=$(git rev-parse HEAD); echo ${GIT_COMMIT}

go build -ldflags "-X update-hover-dns/cmd.semVer=${SEMVER} -X update-hover-dns/cmd.buildDate=${BUILD_DATE} -X update-hover-dns/cmd.gitCommit=${GIT_COMMIT} -X update-hover-dns/cmd.gitRef=/refs/tags/${SEMVER}" && \
./update-hover-dns version | jq .
```

