#!/bin/bash
[ -d site ] && rm -r site/*
[ -d site ] || mkdir site
cp -r build/web/* site/