{
  pkgs, ...
}:
let
  drjit = import ./../drjit { inherit pkgs; };
in

with pkgs.python313Packages;
buildPythonPackage rec {
  pname = "mitsuba";
  version = "3.7.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = pkgs.fetchFromGitHub {
    owner = "mitsuba-renderer";
    repo = "mitsuba3";
    rev = "02459c44067bb7c5d1ab253f635a14d071beee99";
    hash = "sha256-/2WmnjDrIT+0nZDhqO0mYPAqH88kVyK5zXGFokS3NUw=";
    fetchSubmodules = true;
  };

  dependencies = [
    numpy
    drjit
  ];

  nativeBuildInputs = [
    pkgs.llvmPackages_latest.llvm
    setuptools
    wheel
    cython
    pkgs.ninja
    pkgs.cmake
    pkgs.libgccjit
    pkgs.gcc
    pkgs.clang
    pkgs.sphinx
  ];

  preBuild = ''
    cp ../pyproject.toml .
    cp ../README.md .
    cp -r ../include .
    cp -r ../resources .
    cp ../CMakeLists.txt .
    cp -r ../ext .
    cp -r ../src .
    substituteInPlace ../build/ext/nanogui/resources/bin2c.cmake \
        --replace-fail "cmake_minimum_required (VERSION 2.8.12)" "cmake_minimum_required(VERSION 3.15...3.28)"
    export HOME=$(mktemp -d)
  '';

  propagatedBuildInputs = [
    numpy
    drjit
    pkgs.zlib
  ];

  doCheck = true;

  pythonImportsCheck = [ "mitsuba" ];

  meta = {
    description = "Mitsuba 3 is a research-oriented retargetable rendering system, written in portable C++17 on top of the Dr.Jit Just-In-Time compiler. It is developed by the Realistic Graphics Lab at EPFL. ";
    homepage = "https://mitsuba-renderer.org/";
    changelog = "https://mitsuba.readthedocs.io/en/stable/release_notes.html";
    license = lib.licenses.bsd3;
  };
}
