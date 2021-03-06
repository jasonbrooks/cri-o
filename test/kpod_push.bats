#!/usr/bin/env bats

load helpers

IMAGE="alpine:latest"

function teardown() {
    cleanup_test
}

@test "kpod push to containers/storage" {
    run ${KPOD_BINARY} $KPOD_OPTIONS pull "$IMAGE"
    echo "$output"
    [ "$status" -eq 0 ]
    run ${KPOD_BINARY} $KPOD_OPTIONS push "$IMAGE" containers-storage:busybox:test
    echo "$output"
    [ "$status" -eq 0 ]
    run ${KPOD_BINARY} $KPOD_OPTIONS rmi "$IMAGE" busybox:test
    echo "$output"
    [ "$status" -eq 0 ]
}

@test "kpod push to directory" {
    run ${KPOD_BINARY} $KPOD_OPTIONS pull "$IMAGE"
    echo "$output"
    [ "$status" -eq 0 ]
    run mkdir /tmp/busybox
    echo "$output"
    [ "$status" -eq 0 ]
    run ${KPOD_BINARY} $KPOD_OPTIONS push "$IMAGE" dir:/tmp/busybox
    echo "$output"
    [ "$status" -eq 0 ]
    rm -rf /tmp/busybox
    run ${KPOD_BINARY} $KPOD_OPTIONS rmi "$IMAGE"
    echo "$output"
    [ "$status" -eq 0 ]
}

@test "kpod push to docker archive" {
    run ${KPOD_BINARY} $KPOD_OPTIONS pull "$IMAGE"
    echo "$output"
    [ "$status" -eq 0 ]
    run ${KPOD_BINARY} $KPOD_OPTIONS push "$IMAGE" docker-archive:/tmp/busybox-archive:1.26
    echo "$output"
    [ "$status" -eq 0 ]
    rm /tmp/busybox-archive
    run ${KPOD_BINARY} $KPOD_OPTIONS rmi "$IMAGE"
    echo "$output"
    [ "$status" -eq 0 ]
}

@test "kpod push to oci-archive without compression" {
    run ${KPOD_BINARY} $KPOD_OPTIONS pull "$IMAGE"
    echo "$output"
    [ "$status" -eq 0 ]
    run ${KPOD_BINARY} $KPOD_OPTIONS push "$IMAGE" oci-archive:/tmp/oci-busybox.tar:alpine
    echo "$output"
    [ "$status" -eq 0 ]
    rm -f /tmp/oci-busybox.tar
    run ${KPOD_BINARY} $KPOD_OPTIONS rmi "$IMAGE"
    echo "$output"
    [ "$status" -eq 0 ]
}

@test "kpod push without signatures" {
    run ${KPOD_BINARY} $KPOD_OPTIONS pull "$IMAGE"
    echo "$output"
    [ "$status" -eq 0 ]
    run mkdir /tmp/busybox
    echo "$output"
    [ "$status" -eq 0 ]
    run ${KPOD_BINARY} $KPOD_OPTIONS push --remove-signatures "$IMAGE" dir:/tmp/busybox
    echo "$output"
    [ "$status" -eq 0 ]
    rm -rf /tmp/busybox
    run ${KPOD_BINARY} $KPOD_OPTIONS rmi "$IMAGE"
    echo "$output"
    [ "$status" -eq 0 ]
}
