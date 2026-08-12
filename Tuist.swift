import ProjectDescription

// Project-wide Tuist configuration. The targets themselves live in
// `Project.swift`.
//
// `fullHandle` connects the repo to a tuist.dev account. It is what makes
// selective testing work across CI machines: without it, the hashes of
// previously-tested targets are cached locally and an ephemeral runner starts
// empty every time, so nothing is ever skipped.
//
// It's read from the environment rather than hardcoded, because a project with
// a `fullHandle` refuses to generate at all unless the caller is authenticated
// against that tuist.dev project — and you shouldn't need a tuist.dev account
// to clone this sample and look at how Screenshotbot is wired up. Our CI sets
// TUIST_FULL_HANDLE alongside TUIST_TOKEN; everyone else gets a project that
// generates offline, and simply tests everything on every run.
//
// None of this is a Screenshotbot requirement.
let fullHandle = Environment.fullHandle.getString(default: "")

let tuist = fullHandle.isEmpty ? Tuist() : Tuist(fullHandle: fullHandle)
