{ lib, buildPythonPackage, fetchPypi,
  jinja2
}:
buildPythonPackage rec {
  pname = "edalize";
  version = "0.3.3";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1734aprwzm0z2l60xapqrfxxw747n9h9fflv3n0x4iaradf75abj";
  };
  SETUPTOOLS_SCM_PRETEND_VERSION = "${version}";
  propagatedBuildInputs = [ jinja2 ];
  doCheck = false;
}
