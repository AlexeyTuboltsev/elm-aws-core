AWS SDK for elm
===============

[![CircleCI](https://img.shields.io/circleci/project/github/ktonon/aws-sdk-elm.svg)](https://circleci.com/gh/ktonon/aws-sdk-elm)

__Experimental: Work in progress__

This repo contains scripts which read and translate the AWS SDK [apis/*.json][] files into an elm package. Eventually the generated code will be published to the elm package repository.

## Goals

These are the project goals:

* Make this a pure elm implementation of the AWS SDK (no falling back to JavaScript AWS SDK)
* Fully generated. No patching after the generation script is run.

## Preview Docs

* Download <a href="https://raw.githubusercontent.com/ktonon/aws-sdk-elm/master/docs.json" download="download">docs.json</a>
* Use [Elm Packages Doc Preview](http://package.elm-lang.org/help/docs-preview)

## Todo

* [x] parse [apis/*.json][] files to get list of AWS APIs
* [x] generate one elm module per AWS API
  * [x] module documentation
* [ ] means to provide AWS credentials
* [ ] generate AWS operations as elm functions
  * [x] function name
  * [x] function documentation
  * [x] function signature
  * [x] decode response
  * [ ] encode request body
  * [ ] authentication header
* [ ] generate AWS shapes as elm unions and records
  * [x] type name
  * [x] type documentation
  * [x] record type signature
  * [x] union type signature
  * [x] better handling of non-string union types
  * [ ] handle recursive types (like dynamodb `AttributeValue`)
* [ ] misc.
  * [ ] handle blob types
  * [ ] share common shapes as types between modules?
  * [ ] integration tests?

[apis/*.json]:https://github.com/aws/aws-sdk-js/tree/master/apis
[AWS SDK for JavaScript]:https://github.com/aws/aws-sdk-js
