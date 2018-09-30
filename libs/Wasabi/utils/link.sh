#!/bin/bash

cd "$(dirname "$0")/.."

[[ ! -L LibStub ]] && ln -s ../LibStub LibStub
