A Docker wrapper for nodeprof.js, because the repository no longer provides Docker-packaged releases of the latest nodeprof.js.

# Build

```bash
$ docker build -t nodeprof .
```

NOTE: You might encounter a build failure due to insufficient RAM:

```
g++: fatal error: Killed signal terminated program cc1plus
compilation terminated.
make[1]: *** [tools/v8_gypfiles/v8_base_without_compiler.target.mk:194: /works/graaljs/graal-nodejs/out/Release/obj.target/v8_base_without_compiler/deps/v8/src/graal/callbacks.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:139: node] Error 2
```

# Usage

```bash
$ docker run --rm -v $(pwd):/works/nodeprof.js/input nodeprof # args ...
```
If you want a shorter command, create an alias:

```bash
$ alias nodeprof='docker run --rm -v $(pwd):/works/nodeprof.js/input nodeprof' # WARNING use ' instead of " so $(pwd) is evaluated at runtime
```


Check [Haiyang-Sun/nodeprof.js](https://github.com/Haiyang-Sun/nodeprof.js) > [Tutorial.md](https://github.com/Haiyang-Sun/nodeprof.js/blob/master/Tutorial.md) for details.

```
mx jalangi [--analysis pathToAnalsis]* pathToMainProgram [arg]* will run several Jalangi analyses for the program specified with pathToMainProgram with arguments.

You can set a coarse-grained instrumentation scope for your analysis: mx jalangi --scope=[app|module|all].
app: only the application code (without any code in the npm_modules folder or internal libraries);
module: app code plus the node module code;
all: all the code including internal library, node modules and application code.
```