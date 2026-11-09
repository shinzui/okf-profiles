# seihou-managed. Image descriptions are exported with copyTo, not read as archives.
{ runCommand, bun, cacert, nix2container }:
{ app, content, name, tag }:
let
  runtime = nix2container.buildLayer { deps = [ bun cacert ]; };
  application = nix2container.buildLayer { deps = [ app ]; layers = [ runtime ]; };
  publication = nix2container.buildLayer { deps = [ content ]; layers = [ runtime application ]; };
  root = runCommand "docs-image-root" { } ''
    mkdir -p "$out/app" "$out/tmp"
    chmod 1777 "$out/tmp"
    cp -Rs ${app}/share/docs/. "$out/app/"
    ln -s ${content} "$out/content"
  '';
in nix2container.buildImage {
  inherit name tag;
  layers = [ runtime application publication ];
  copyToRoot = root;
  config = {
    User = "65532:65532";
    WorkingDir = "/app";
    Entrypoint = [ "${bun}/bin/bun" ];
    Cmd = [ "/app/server.ts" ];
    ExposedPorts."8080/tcp" = { };
    Env = [ "PORT=8080" "NODE_ENV=production" "DOCS_CONTENT_ROOT=/content" "SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt" ];
  };
}
