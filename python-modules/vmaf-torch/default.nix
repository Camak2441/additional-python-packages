{
  pkgs, ...
}:
let
  yuvio = import ./../yuvio { inherit pkgs; };
in

with pkgs.python313Packages;
buildPythonPackage rec {
  pname = "vmaf-torch";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = pkgs.fetchFromGitHub {
    owner = "alvitrioliks";
    repo = "VMAF-torch";
    rev = "a14135ec6b35912990e1c834d8998bd5d2e234c3";
    hash = "";
  };

  nativeBuildInputs = [
    setuptools
    wheel
    cython
  ];

  propagatedBuildInputs = [
    numpy
    pandas
    torch
    yuvio
  ];

  doCheck = true;

  pythonImportsCheck = [ "vmaf_torch" ];

  meta = {
    description = "";
    homepage = "https://github.com/alvitrioliks/VMAF-torch";
    changelog = "";
    license = lib.licenses.bsd3;
  };
}
