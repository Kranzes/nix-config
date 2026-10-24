{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installAgentSkills,
}:

buildGoModule (finalAttrs: {
  pname = "maiao";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "runetes";
    repo = "maiao";
    tag = "maiao-v${finalAttrs.version}";
    hash = "sha256-DhEFhZ+6gH+O29ge2jefEbvSq62i4bOotLrowJh+W/s=";
  };

  vendorHash = "sha256-ccuTrhRrH+Qe9VwIKSK9rQYcYtrB8YO3pODbMT5/sVc=";

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/maiao" ];

  nativeBuildInputs = [ installAgentSkills ];

  ldflags = [
    "-s"
    "-X github.com/runetes/maiao/pkg/version.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/maiao $out/bin/git-review
    install -Dm755 pkg/gerrit/commit-msg.sh $out/share/git-core/templates/hooks/commit-msg
  '';

  meta = {
    description = "Gerrit-style stacked pull requests for GitHub, GitLab, Gitea and more";
    homepage = "https://github.com/runetes/maiao";
    changelog = "https://github.com/runetes/maiao/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
    mainProgram = "git-review";
  };
})
