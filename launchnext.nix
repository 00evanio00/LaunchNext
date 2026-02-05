{ lib
, stdenvNoCC
, fetchurl
, fetchFromGitHub
, unzip
, _7zz
}:

stdenvNoCC.mkDerivation rec {
  pname = "LaunchNext";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "RoversX";
    repo = "LaunchNext";
    rev = version;
    hash = "sha256-Yml2OGajVXYDgk0av24miL1bEisIxfvmDDq4JAHCEtA=";
  };

  launchNextZip = fetchurl {
    url = "https://github.com/RoversX/LaunchNext/releases/download/${version}/LaunchNext${version}.zip";
    hash = "sha256-6IfesquZ7jfb4VTfjIHgMKWBRuaNH8EhcJoIt0NfUl0=";
  };

  nativeBuildInputs = [ unzip _7zz ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    unzip -q "$launchNextZip" -d $out/Applications \
      || 7zz x -o"$out/Applications" "$launchNextZip"

    test -d "$out/Applications/LaunchNext.app" \
      || { echo "ERROR: LaunchNext.app not found after extraction"; exit 1; }

    runHook postInstall
  '';

  meta = with lib; {
    description = "Bring your Launchpad back in macOS 26+ — highly customizable, powerful, free";
    homepage = "https://github.com/RoversX/LaunchNext";
    license = licenses.gpl3Only;
    platforms = platforms.darwin;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    maintainers = [ ]; # add yourself here
  };
}
