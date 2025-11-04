{
  pkgs
}:

with pkgs.python313Packages;
buildPythonPackage rec {
  pname = "drjit";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = pkgs.fetchFromGitHub {
    owner = "mitsuba-renderer";
    repo = "drjit";
    rev = "77dc20604247b1a2a84fab8cefe4f453a6c6c362";
    hash = "sha256-qn/+VZv0u6hMwe8WDFCwbIzRCIyOQbPL5OqBTvtTKiI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
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

  propagatedBuildInputs = [
    scikit-build-core
    nanobind
    numpy
    typing-extensions
    hatch-fancy-pypi-readme
  ];

  preBuild = ''
    cp ../pyproject.toml .
    cp ../README.rst .
    cp -r ../include .
    cp -r ../resources .
    cp ../CMakeLists.txt .
    cp -r ../ext .
    cp -r ../src .
    cp -r ../drjit .
    mkdir -p build/temp
    export HOME=temp
  '';

  doCheck = true;

  pythonImportsCheck = [ "drjit" ];

  meta = {
    description = "";
    homepage = "https://drjit.readthedocs.io/en/stable/";
    changelog = "https://drjit.readthedocs.io/en/stable/changelog.html";
    license = lib.licenses.bsd2;
  };
}
