WasmCloud:
- components model
- capability providers
- distributed deployment - transparent use of NATS
- polyglot
- based on Wasmex , which used to wrap WASMR but [moved to Wasmtime](https://wasmcloud.com/blog/wasmtime-a-standardized-runtime-for-wasmcloud)
- may offer WasmEdge later?
- kubernetes like? (multiple instance per host?), hot swapping ?


NATS:
- m:n tolopolgy as opposed to 1:1
- pub sub, query response
- persistence with Jetstream
- QoS:  at most once, at least once, exactly once

Wasmtime:
- wasi standard: wasi-common, wasi-config, wasi-http, wasi-keyvalue, wasi-nn, wasi-threads
- wit-bindgen
- examples
  - tokio-wasi
  - wasp1-async
  - wasp2-async

rust->[tokio](https://docs.rs/tokio/latest/tokio/#wasm-support)
- stable: sync, macros, io-util,rt,time (requires timers from platform wasm32-wasi)
- unstable: net (not all methods , sue to no socket creation within WASM) (creation via From RawFd trait)


[WasmEdge](https://wasmedge.org/):
- modular host , lightweight
- C++ implementation
- extensible via plugins
- secure exec (WASM)
- cross platform (small platforms, IoT)
- 

embedded wasm inside C# with 


Elixir/OTP (Open telecom Platform):
- functional programming language
- elixir runs on Erlang VM

