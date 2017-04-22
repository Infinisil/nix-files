{ stdenv, fetchFromGitHub, fetchpatch, pythonPackages }:

pythonPackages.buildPythonApplication rec
{
  pname = "simp_le-client";
  version = "0.2.0";
  name = "${pname}-${version}";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "18y8mg0s0i2bs57pi6mbkwgjlr5mmivchiyvrpcbdmkg9qlbfwaa";
  };

  checkPhase = ''
    $out/bin/simp_le --test
  '';

  propagatedBuildInputs = with pythonPackages; [ acme setuptools_scm ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/zenhack/simp_le";
    description = "Simple Let's Encrypt client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner nckx ];
    platforms = platforms.all;
  };
}
