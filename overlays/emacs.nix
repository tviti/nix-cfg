self: super:
let
  # customEmacsPackages = super.emacsPackagesNgGen
  #   (if super.hostPlatform.isDarwin then super.emacsMacport else super.emacs);
  emacsMacport = super.emacsMacport;
  customEmacsPackages = super.emacsPackages.overrideScope' (self: super: {
    # use a custom version of emacs
    emacs = emacsMacport;
    # use the unstable MELPA version of magit
    slime = self.melpaPackages.slime;
    nix-mode = self.melpaPackages.nix-mode;
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
