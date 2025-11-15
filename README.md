# Build

```bash
$ docker build -t nodeprof .
```

You might encounter a build failure due to insufficient RAM:
```
g++: fatal error: Killed signal terminated program cc1plus
compilation terminated.
make[1]: *** [tools/v8_gypfiles/v8_base_without_compiler.target.mk:194: /works/graaljs/graal-nodejs/out/Release/obj.target/v8_base_without_compiler/deps/v8/src/graal/callbacks.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:139: node] Error 2
```