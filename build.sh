#!/bin/bash
flutter build web
[ -d site ] && rm -r site/*
[ -d site ] || mkdir site
cp -r build/web/* site/