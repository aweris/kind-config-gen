# KinD Config Generate

!!! Experimental repo for generating local KinD config using CUE. !!!

## How to use

Using default config:
```shell
cue export --out yaml
```

Using with custom values: 
```shell
`cue export --out yaml -t image=kindest/node:v1.21.2 \
                      -t dockerUsername=docker-user \
                      -t dockerPassword=1234 \
                      -t dockerMirror=http://localhost:5000`
```