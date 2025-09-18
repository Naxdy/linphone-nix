{ ... }:
{
  programs.nixfmt.enable = true;

  programs.typos = {
    enable = true;
    includes = [
      "*.nix"
      "*.md"
    ];
  };

  programs.prettier = {
    enable = true;
    settings = {
      singleQuote = true;
      trailingComma = "all";
      semi = true;
      printWidth = 120;
      proseWrap = "always";
    };
  };
}
