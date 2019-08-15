load("//bazel:api_build_system.bzl", "udpa_proto_library")

licenses(["notice"])  # Apache 2

udpa_proto_library(
    name = "orca",
    srcs = ["orca.proto"],
    has_services = 1,
    deps = ["//udpa/data/orca/v1:orca_load_report"],
)
