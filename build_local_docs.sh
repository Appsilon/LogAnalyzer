#!/bin/bash

# This script is used to build the local documentation for the project.

remove_files() {
  if [ -f _quarto.yml ]; then
    echo "Removing _quarto.yml..."
    rm _quarto.yml
  fi

  if [ -f styles.css ]; then
    echo "Removing styles.css..."
    rm styles.css
  fi
}

cleanup() {
  echo "Cleaning up..."
  remove_files
  exit 1
}

trap cleanup SIGINT

if [ "$1" = "preview" ]; then
  echo "Copying _quarto.yml..."
  cp docs/_quarto.yml _quarto.yml
  echo "Copying styles.css..."
  cp docs/styles.css styles.css

  echo "Building local documentation preview..."
  quarto preview
elif [ "$1" = "render" ]; then
  echo "Copying _quarto.yml..."
  cp docs/_quarto.yml _quarto.yml
  echo "Copying styles.css..."
  cp docs/styles.css styles.css

  echo "Rendering local documentation..."
  quarto render
  remove_files
fi
