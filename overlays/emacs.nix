# Emacs w/ melpa/elpa packages

self: super:
let
  # Use emacs-macport on Darwin systems
  package = if super.stdenv.isDarwin then super.emacsMacport else super.emacs;
  customEmacsPackages =
    super.emacsPackages.overrideScope' (self: super: { emacs = package; });
in {
  myEmacs = customEmacsPackages.emacsWithPackages (epkgs:
    with epkgs; [
      auctex
      company
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
      stan-mode
      which-key
    ]);
}
