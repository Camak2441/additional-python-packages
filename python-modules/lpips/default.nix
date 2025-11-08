{
  pkgs,
}:

with pkgs.python313Packages;
buildPythonPackage rec {
  pname = "lpips";
  version = "0.1.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = pkgs.fetchFromGitHub {
    owner = "richzhang";
    repo = "PerceptualSimilarity";
    rev = "3767a70e437c4020decf5888a83f438d2726a10f";
    hash = "sha256-dIQ9B/HV/2kUnXLXNxAZKHmv/Xv37kl2n6+8IfwIALE=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    torch
    torchvision
    numpy
    scipy
    scikit-image
    opencv-python
    matplotlib
    tqdm
    jupyter-core
    numpy
    scipy
  ];

  doCheck = true;

  pythonImportsCheck = [ "lpips" ];

  meta = {
    description = "";
    homepage = "https://github.com/richzhang/PerceptualSimilarity";
    changelog = "https://github.com/richzhang/PerceptualSimilarity/releases/tag/${version}";
    license = lib.licenses.bsd2;
  };
}
