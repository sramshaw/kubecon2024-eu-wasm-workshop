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

Wasmtime:  by Fastly, with Luke Wagner
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

WAMR
- [used by Sony for Aitrios products as per WASM IO 2024](https://www.youtube.com/watch?v=ff9KSGsxmiQ&t=755s),
  -  on very small 32bit controllers it seems, and even Risc V
  -  OS: Nuttx and maybe Zephyr in future BUT NO opensource contrib :sad:
  -  [architecture](https://youtu.be/ff9KSGsxmiQ?list=TLPQMTEwMTIwMjWueaNYl_IHcg&t=432)
  -  used WASI-Sensor and WASI-NN
  -  not db or blob or telemetry or sockets
  -  use of nodered ?!?! 
     -  https://github.com/phyunsj/node-red-native-addon?tab=readme-ov-file

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
