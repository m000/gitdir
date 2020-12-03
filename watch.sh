#!/bin/bash

while true; do
    find . -not -path './.git*' | entr -ad ./handler.sh /_;
done
