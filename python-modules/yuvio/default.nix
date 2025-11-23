{
  pkgs, ...
}:

with pkgs.python313Packages;
buildPythonPackage rec {
  pname = "yuvio";
  version = "1.6";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = pkgs.fetchFromGitHub {
    owner = "labradon";
    repo = "yuvio";
    rev = "570d35c33a7ee1e16a63d51bd166ce14d27de858";
    hash = "sha256-FLVMDxa6lfQFA+cQpTseY9TnLPcEhHv7svMRQ1J9dC0=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
    cython
  ];

  propagatedBuildInputs = [
    numpy
    psutil
  ];

  doCheck = true;

  pythonImportsCheck = [ "yuvio" ];

  meta = {
    description = "";
    homepage = "https://github.com/labradon/yuvio";
    changelog = "https://github.com/labradon/yuvio/releases";
    license = lib.licenses.mit;
  };
}
