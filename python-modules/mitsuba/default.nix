{
  pkgs
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
    cp ../pyproject.toml ../build
    cp ../README.md ../build
    cp -r ../include ../build
    cp -r ../resources ../build
    cp ../CMakeLists.txt ../build
    cp -r ../ext ../build
    cp -r ../src ../build
    substituteInPlace ../build/ext/nanogui/resources/bin2c.cmake \
        --replace "cmake_minimum_required (VERSION 2.8.12)" "cmake_minimum_required(VERSION 3.15...3.28)"
    mkdir ../build/build/temp
    export HOME=temp
  '';

  propagatedBuildInputs = [
    numpy
    drjit
    pkgs.zlib
  ];

  doCheck = true;

  pythonImportsCheck = [ "mitsuba" ];

  meta = {
    description = "";
    homepage = "https://mitsuba-renderer.org/";
    changelog = "";
    license = lib.licenses.bsd2;
  };
}
