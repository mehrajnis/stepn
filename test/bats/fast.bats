#!/usr/bin/env bats

load test_helper

NVM_SRC_DIR="${BATS_TEST_DIRNAME}/../.."
load "${NVM_SRC_DIR}/nvm.sh"

setup() {
    echo 'setup' >&2
    NVM_DIR="${BATS_TMPDIR}"
    cd "${NVM_DIR}"
    rm -Rf src alias v*
    mkdir src alias
}

teardown() {
    echo 'teardown' >&2
    NVM_DIR="${BATS_TMPDIR}"
    cd "${NVM_DIR}"
    rm -Rf src alias v*
}

@test "'nvm' command defined in environment" {
    run nvm
    assert_equal "$status" "0" "nvm command defined"
}

@test "Running 'nvm alias' should create a file in the alias directory." {
    run nvm alias test v0.1.2
    [ "$status" -eq 0 ]
    result=$(cat "alias/test")
    assert_equal "$result" "v0.1.2" "expected new alias"
}

@test './Listing versions/Running "nvm ls 0.0.2" should display only version 0.0.2.' {

    mkdir -p v0.0.2
    mkdir -p v0.0.20

    run nvm ls 0.0.2
    assert_match ${lines[0]} "v0.0.2" "nvm ls 0.0.2 must contain v0.0.2"

    run nvm ls 0.0.2
    assert_nomatch "$output" "v0.0.20"  "nvm ls 0.0.2 must NOT contain v0.0.20"
}

