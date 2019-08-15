load("@com_google_protobuf//:protobuf.bzl", _py_proto_library = "py_proto_library")
load("@com_envoyproxy_protoc_gen_validate//bazel:pgv_proto_library.bzl", "pgv_cc_proto_library")

_PY_SUFFIX = "_py"
_CC_SUFFIX = "_cc"

def _Suffix(d, suffix):
    return d + suffix

def _LibrarySuffix(library_name, suffix):
    # Transform //a/b/c to //a/b/c:c in preparation for suffix operation below.
    if library_name.startswith("//") and ":" not in library_name:
        library_name += ":" + Label(library_name).name
    return _Suffix(library_name, suffix)

# TODO(htuch): has_services is currently ignored but will in future support
# gRPC stub generation.
# TODO(htuch): Add support for Go based on envoy_api as needed.
def udpa_proto_library(
        name,
        visibility = ["//visibility:private"],
        srcs = [],
        deps = [],
        has_services = None):
    native.proto_library(
        name = name,
        srcs = srcs,
        deps = deps + [
            "@com_google_protobuf//:any_proto",
            "@com_google_protobuf//:descriptor_proto",
            "@com_google_protobuf//:duration_proto",
            "@com_google_protobuf//:empty_proto",
            "@com_google_protobuf//:struct_proto",
            "@com_google_protobuf//:timestamp_proto",
            "@com_google_protobuf//:wrappers_proto",
            "@com_google_googleapis//google/api:http_proto",
            "@com_google_googleapis//google/api:annotations_proto",
            "@com_google_googleapis//google/rpc:status_proto",
            "@com_envoyproxy_protoc_gen_validate//validate:validate_proto",
        ],
        visibility = visibility,
    )
    pgv_cc_proto_library(
        name = _Suffix(name, _CC_SUFFIX),
        cc_deps = [_LibrarySuffix(d, _CC_SUFFIX) for d in deps] + [
            "@com_google_googleapis//google/api:http_cc_proto",
            "@com_google_googleapis//google/api:annotations_cc_proto",
            "@com_google_googleapis//google/rpc:status_cc_proto",
        ],
        deps = [":" + name],
        visibility = visibility,
    )
    py_export_suffixes = []
    _py_proto_library(
        name = _Suffix(name, _PY_SUFFIX),
        srcs = srcs,
        default_runtime = "@com_google_protobuf//:protobuf_python",
        protoc = "@com_google_protobuf//:protoc",
        deps = [_LibrarySuffix(d, _PY_SUFFIX) for d in deps] + [
            "@com_envoyproxy_protoc_gen_validate//validate:validate_py",
            "@com_google_googleapis//google/rpc:status_py_proto",
            "@com_google_googleapis//google/api:annotations_py_proto",
            "@com_google_googleapis//google/api:http_py_proto",
            "@com_google_googleapis//google/api:httpbody_py_proto",
        ],
        visibility = visibility,
    )
    py_export_suffixes = ["_py", "_py_genproto"]

    # Allow unlimited visibility for consumers
    export_suffixes = ["", "_cc", "_cc_validate"] + py_export_suffixes
    for s in export_suffixes:
        native.alias(
            name = name + "_export" + s,
            actual = name + s,
            visibility = ["//visibility:public"],
        )

def udpa_cc_test(name, srcs, proto_deps):
    native.cc_test(
        name = name,
        srcs = srcs,
        deps = [_LibrarySuffix(d + "_export", _CC_SUFFIX) for d in proto_deps],
    )

# This defines googleapis py_proto_library. The repository does not provide its definition and requires
# overriding it in the consuming project (see https://github.com/grpc/grpc/issues/19255 for more details).
def py_proto_library(name, deps = []):
    srcs = [dep[:-6] + ".proto" if dep.endswith("_proto") else dep for dep in deps]
    proto_deps = []

    # py_proto_library in googleapis specifies *_proto rules in dependencies.
    # By rewriting *_proto to *.proto above, the dependencies in *_proto rules are not preserved.
    # As a workaround, manually specify the proto dependencies for the imported python rules.
    if name == "annotations_py_proto":
        proto_deps = proto_deps + [":http_py_proto"]
    _py_proto_library(
        name = name,
        srcs = srcs,
        default_runtime = "@com_google_protobuf//:protobuf_python",
        protoc = "@com_google_protobuf//:protoc",
        deps = proto_deps + ["@com_google_protobuf//:protobuf_python"],
        visibility = ["//visibility:public"],
    )
