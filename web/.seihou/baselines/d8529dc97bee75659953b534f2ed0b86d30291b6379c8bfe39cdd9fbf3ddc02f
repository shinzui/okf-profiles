# seihou-managed. Only approved files and their parent directories enter this input.
{ lib, runCommand, python3 }:
{ sourceRoot, configPath, commit, date }:
let
  valid = p: builtins.isString p && p != "" && !(lib.hasPrefix "/" p) && !(lib.hasInfix "\\" p) && !(lib.hasInfix ":" p) && lib.all (part: part != "" && part != "." && part != "..") (lib.splitString "/" p);
  manifest = if valid configPath then builtins.fromJSON (builtins.readFile (sourceRoot + "/${configPath}")) else throw "Invalid contentConfig path";
  selected = manifest.documents ++ manifest.assets;
  files = [ configPath ] ++ selected;
  source = assert manifest.schemaVersion == 1; assert lib.all valid files;
    builtins.path { path = sourceRoot; name = "docs-publication-source"; filter = path: type:
      let relative = lib.removePrefix (toString sourceRoot + "/") (toString path);
      in if builtins.elem relative files then
        if type == "symlink" then throw "Publication snapshots require regular files: ${relative}" else true
      else lib.any (f: lib.hasPrefix (relative + "/") f) files;
    };
in runCommand "docs-content" { nativeBuildInputs = [ python3 ]; } ''
  python3 ${./docs-microapp-snapshot.py} ${source} ${lib.escapeShellArg configPath} "$out" ${lib.escapeShellArg commit} ${lib.escapeShellArg date}
''
