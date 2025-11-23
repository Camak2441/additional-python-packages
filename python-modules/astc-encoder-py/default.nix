{
  pkgs, ...
}:

with pkgs.python313Packages;
buildPythonPackage rec {
  pname = "astc-encoder-py";
  version = "0.1.12";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = pkgs.fetchFromGitHub {
    owner = "K0lb3";
    repo = "astc-encoder-py";
    rev = "eb3822f18fda01aae5b7907571383d9cceb37211";
    hash = "sha256-pmrdSQmrk2x6wBTPj0OlubiirYcOosXCaJRioPrDxC4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    setuptools
    wheel
    cython
    pkgs.astc-encoder
  ];

  propagatedBuildInputs = [
    archspec
  ];

  preBuild = ''
    echo PreBuild;
    ls;
    ls ./astc_encoder;
    ls ./src;
    ls ./src/astc-encoder;
    ls ./src/astc-encoder/Source;
    cat pyproject.toml;
    substituteInPlace pyproject.toml \
        --replace "setuptools<72.2.0" "setuptools"
  '';

  doCheck = true;

  pythonImportsCheck = [ "astc_encoder" ];

  meta = {
    description = "";
    homepage = "https://github.com/K0lb3/astc-encoder-py";
    changelog = "";
    license = lib.licenses.mit;
  };
}
