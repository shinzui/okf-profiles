#!/usr/bin/env python3
"""Accept the product-research fixture bundle and reject each focused invalid case."""
from profile_fixture_cases import run

run("product-research", "profiles/documentation/product-research.dhall",
    "fixtures/product-research", "fixtures/product-research-invalid")
