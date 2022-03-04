#!/usr/bin/env bash

poetry update
poetry run pre-commit install
poetry run pre-commit autoupdate
