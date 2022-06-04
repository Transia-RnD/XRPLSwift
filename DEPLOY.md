
## DEPLOY

## Change version in podspec

set the new version to 0.0.1
set the new tag to 0.0.1

## Lint

`pod lib lint`

## Commit/Tag

`git add -A && git commit -m "Release 0.0.1."`
`git tag '0.0.1'`
`git push --tags`

## Trunk

`pod trunk push XRPLSwift.podspec`

### Trunk PreReq

Signup @:

`pod trunk register dangell@transia.co 'Denis Angell' --description='macbook pro'`

List Sessions:

`pod trunk me`