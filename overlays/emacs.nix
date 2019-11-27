# Emacs w/ melpa/elpa packages

self: super:
let
  package = if super.stdenv.isDarwin then super.emacsMacport else super.emacs;
  customEmacsPackages = super.emacsPackages.overrideScope' (self: super: {
    # use a custom version of emacs
    emacs = package;
  });
in {
  my-emacs = customEmacsPackages.emacsWithPackages (epkgs:
    with epkgs; [
      auctex
      counsel
      ess
      evil
      evil-collection
      evil-magit
      evil-org
      elfeed
      elpy
      eyebrowse
      flycheck
      highlight-numbers
      nix-mode
      magit
      magit-annex
      matlab-mode
      org
      org-bullets
      pdf-tools
      polymode
      poly-markdown
      poly-R
      rainbow-delimiters
      slime
      spacemacs-theme
      spaceline
      which-key
    ]);
}
