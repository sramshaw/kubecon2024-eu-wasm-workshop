[Kubecon 2024](https://www.cncf.io/wp-content/uploads/2024/12/kubecon-na-2024-transparency-report.pdf)

WasmCloud:
- components model for composition, as opposed to modules (.wasm)
- capability providers
- distributed deployment - underlying use of NATS
- based on Wasmex , which used to wrap WASMR but [moved to Wasmtime](https://wasmcloud.com/blog/wasmtime-a-standardized-runtime-for-wasmcloud)
- may offer WasmEdge later?
- kubernetes like? (multiple instance per host?), infrastructure hot swapping ?
- logging, metrics, tracing
- OCI? Open Container Interface
  - OCI registry 

[NATS](https://nats.io/):
- m:n tolopolgy as opposed to 1:1
- pub sub, query response
- persistence with Jetstream
- QoS:  at most once, at least once, exactly once
- [dotnet impl](https://nats-io.github.io/nats.net/index.html)

Wasmtime: runtime written in Rust,  by Fastly, with Luke Wagner
- wasi standard: wasi-common, wasi-config, wasi-http, wasi-keyvalue, wasi-nn, wasi-threads
- wit-bindgen
- examples
  - tokio-wasi , [small example?](https://github.com/bytecodealliance/wasmtime/blob/main/examples/tokio/main.rs)
  - wasp1-async
  - wasp2-async
- some involvment from Intel, Microsoft, Amazon
- JIT and AOT compilation
- Cranelift compiler => polyglot
- merge of [Lucet and Wasmtime](https://youtu.be/jPDMYpVUA04?t=3892)

WAMR, based on wasm-micro-runtime by [Bytecode Alliance](https://bytecodealliance.org/), written in C/C++
- [used by Sony for Aitrios products as per WASM IO 2024](https://www.youtube.com/watch?v=ff9KSGsxmiQ&t=755s),
  -  on very small 32bit controllers it seems, and even Risc V
  -  OS: Nuttx and maybe Zephyr in future BUT NO opensource contrib :sad:
  -  [architecture](https://youtu.be/ff9KSGsxmiQ?list=TLPQMTEwMTIwMjWueaNYl_IHcg&t=432)
  -  used WASI-Sensor and WASI-NN
  -  not db or blob or telemetry or sockets
  -  use of nodered ?!?! 
     -  https://github.com/phyunsj/node-red-native-addon?tab=readme-ov-file
- IDE [plugin for vscode: WAMRIDE](https://github.com/bytecodealliance/wasm-micro-runtime/tree/main/test-tools/wamr-ide)
  - does not require Docker Desktop on Windows, can be done via WSL
  - lldb for interpreter debugging [is not enabled by default](https://marketplace.visualstudio.com/items?itemName=wamr-ide.wamride) , ?!?!?!
    - the link to the instructions to rebuild it **broken**
    - note: [releases](https://github.com/bytecodealliance/wasm-micro-runtime/releases) (still not the one for interpreter debug)
  - 

rust->[tokio](https://docs.rs/tokio/latest/tokio/#wasm-support)
- stable: sync, macros, io-util,rt,time (requires timers from platform wasm32-wasi)
- unstable: net (not all methods , sue to no socket creation within WASM) (creation via From RawFd trait)


[WasmEdge](https://wasmedge.org/):
- modular host , lightweight
- C++ implementation
- extensible via plugins
- secure exec (WASM)
- cross platform (small platforms, IoT)
- [Podman + WASM + GPU](https://wasmedge.org/docs/develop/deploy/gpu/podman_wasm_gpu) : container = crun + wasmedge + plugin
- [AI](https://wasmedge.org/docs/category/ai-inference)

Extism: plugin approach for embedding WASM in code
- https://extism.org/docs/concepts/plug-in/
- embedded wasm [inside C#](https://github.com/extism/dotnet-sdk)

Elixir/OTP (Open telecom Platform):
- functional programming language
- elixir runs on Erlang VM

WASI
- change from WebAssembly System Interface to Standard Interface
  - focus on virtualization and modularity
  - people watching [this talk](https://www.youtube.com/watch?v=k3HDivg3xyc) [mention a form of](https://github.com/WebAssembly/wasi-io/issues/11) Dependency Injection or Inversion of Control
- wasi-nn backends correspond to existing ML frameworks, e.g., Tensorflow, ONNX, OpenVINO (similar to ONNX.js)
- [wasi-serial?](https://github.com/WebAssembly/WASI/issues/350)  
- wasi-keyvalue : [redis used here](https://wasmcloud.com/docs/0.82/examples/cruddy) , [noname memory keystore here](https://docs.wasmtime.dev/api/src/wasmtime_wasi_keyvalue/lib.rs.html)
- preview1
  - [monolith subset of POSIX  based on CloudABI](https://www.youtube.com/watch?v=y3x4-nQeXxc)
- preview2
  - already delivered component model via WIT
  - 2024 plan
    - improve concurrency (mainly for http?)
      - existing solution for concurrency of multiple incoming and outgoing requests in proxy is possible, but polling is O(n) , pb if heavy
        - not [epoll](https://copyconstruct.medium.com/the-method-to-epolls-madness-d9d2d6378642) addition to wasi?
      - concurrency not yet composable with 2 components that can block each other and virtualization of async interface consequences ~ like IDisposable 
    - streaming perf, async not easily usable, 
- preview 2.x?
  - http composable (stackable)
  - proxy component as a compound component : [path based router example](https://youtu.be/y3x4-nQeXxc?t=330) 
- preview3
  - add future and stream to WIT (components definition language)
  - io_uring-friendly ABI

[leverage old code](https://youtu.be/tAACYA1Mwv4?t=902):
- wasi-sdk to compile a C file to a component
- wasi-filesystem can be virtualized with wasi-virt 
- warg to publish to registry
- grab and deduce another component for a web api via componentize-js
  - add a wasi-httphandler to make request , add wasi:keyvalue/cacache to cache the results of calling thumbify the first time 
- wasm-compose to compose initial component with deduced one into an deployment ready component
  - used in prod

[cloud deployment story](https://youtu.be/tAACYA1Mwv4?t=1407)
- execution platform
  - AOT
    - fuse multi-component component until single multi-memory wasm file
    - compile wasm file into binary for the architecture
  - runtime
    - runtime instantiates several instances of a given component
  - cache of compiled 

[component deployed in the braowser](https://youtu.be/tAACYA1Mwv4?t=1516)
- jco transpile, component gives a WebAssembly core module, and js glue logic 
  - uses WASI polyfills (browser web apis and javascript implementations)

W3C WASM
- WebAssembly Core
  - a successor to asm.js [as explained by Bailey Hayes](https://www.youtube.com/watch?v=6_BRLqxiZPU), 
    - demo: Unreal engine demo (only [article on it](https://acko.net/blog/on-asmjs/)
    - and [video of it](https://www.youtube.com/watch?v=BV32Cs_CMqo&t=5s))
  - its own game demo: [Unity WebGL angrybots](https://files.unity3d.com/jonas/AngryBots/)
- component model explained , [with illustrated interaction of 2 components](https://www.youtube.com/watch?v=MTs2tdnEbT0)
  - [What is a component and why?](https://www.youtube.com/watch?v=MTs2tdnEbT0), by Luke Wagner at Fastly

WASIX:
- tried to build the [grpc example](https://github.com/wasix-org/wasix-rust-examples/tree/main/wasix-grpc), not successful in build, broken 
  - see start.WASIX.sh

Envoy

spin

security [from the wasmcloud cofounder](https://www.youtube.com/watch?v=70Ud9kc8J7w)
- JWT with capabilities
- wash is the wasmclooud cli

Atym
- [2months ago interview](https://www.youtube.com/watch?v=gMllGGVecjc)
- details of using OCRE and WAMR on [this blog entry by Knox Lively](https://www.atym.io/post/why-i-joined-atym-bringing-devops-to-embedded-development)
  - is it using iwasm ? see [benchmark C on iwasm compared to native C](https://00f.net/2023/01/04/webassembly-benchmark-2023/) : 2.32x execution times, not bad!
- OCRE is the ~ mini docker format [(is open source)](https://lfedge.org/projects/ocre/)
  - true containers in your choice of language, cloud native like
- 1MB of memory to 1GB
- comparable to WindRiver trying virtualization
- Zephyr as RTOS, from Linux Foundation
  - 
- too heavy for M0 - M3

w2c2:
- compile wasm to file. [Great for running wasm faster than some interpreters like wasm3](https://00f.net/2023/12/11/webassembly-compilation-to-c/).
  - 2min05s / 1min 13s  = 1.7 x copmared to wasmtime
- great for security C => wasm => C => compile
- fastest is iwasm anyway , also ~ 1.7x faster than wasmtime ...




grpc:
- rust has tonic
  - [tonic-web-wasm-client](https://github.com/devashishdxt/tonic-web-wasm-client) can run in a browser, not sure about runtime
  - https://www.reddit.com/r/rust/comments/16r05ui/working_example_for_grpc_and_wasm/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  - https://github.com/devashishdxt/tonic-web-wasm-client
- try to make it work?
  - https://github.com/sramshaw/wasix-rust-examples.git , from
  - https://github.com/wasix-org/wasix-rust-examples.git

[wrpc](https://github.com/bytecodealliance/wrpc):
- alternative to grpc, can run on NATS
- but never C#, seems focused in inter component comms

[nrpc](https://github.com/nats-rpc/nrpc):
- nats RPC
- uses proto files
- https://github.com/nats-rpc/nrpc

ONNX.js:
- SqueezeNet
  - webGL backend
  - WASM CPU backend
  - 

Higress + Envoy?: Chinese platform, Alibaba

news 2025:
- [wasm to be used in existing gaps](https://thenewstack.io/see-what-webassembly-can-do-in-2025/) where containers are too big or slow

languages
- Dart to WASM: requires gcc, Dart is ~ C# for class, tuple looking record, AOT to 10MB exe, for flutter
- Grain to WASM: lots of immutable by default types, tuples, matching joy, no rx or threads , 
- C# rxs: Rx.NEt, UniRx , R3
- 
