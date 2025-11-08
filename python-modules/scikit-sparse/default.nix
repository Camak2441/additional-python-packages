{
  pkgs, ...
}:

with pkgs.python313Packages;
buildPythonPackage rec {
  pname = "scikit-sparse";
  version = "0.4.16";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = pkgs.fetchFromGitHub {
    owner = "scikit-sparse";
    repo = "scikit-sparse";
    rev = "14fd45a8078a5b3b7eb2e817c07852dada809882";
    hash = "sha256-OE/TPJUgY9U7oT+mw0dHoblPRLtn95Al4bx3mjxiQG8=";
  };

  nativeBuildInputs = [
    cython
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    pkgs.suitesparse
  ];

  doCheck = true;

  pythonImportsCheck = [ "sksparse" ];

  meta = {
    description = "A companion to the scipy.sparse library for sparse matrix manipulation in Python.";
    homepage = "https://github.com/scikit-sparse/scikit-sparse";
    changelog = "https://github.com/scikit-sparse/scikit-sparse/releases/tag/${version}";
    license = lib.licenses.bsd2;
  };
}
