# Emacs w/ melpa/elpa packages

self: super:
let
  # Use emacs-macport on Darwin systems
  package = (if super.stdenv.isDarwin then super.emacsMacport else super.emacs).override {
    imagemagick = super.imagemagickBig;
  };
  customEmacsPackages =
    super.emacsPackages.overrideScope' (self: super: { emacs = package; });
in {
  myEmacs = customEmacsPackages.emacsWithPackages (epkgs:
    with epkgs; [
      auctex
      bash-completion
      bbcode-mode
      company
      counsel
      doct
      eglot
      ess
      evil
      evil-collection
      # evil-magit
      evil-org
      elfeed
      # elpy
      # eyebrowse
      flymake
      flyspell-correct-ivy
      highlight-numbers
      nix-mode
      # org-gcal
      oauth2 # needed for org-caldav
      org-caldav
      direnv
      vterm
      ledger-mode
      lispy
      magit
      magit-annex
      matlab-mode
      htmlize
      org
      org-bullets
      org-pdftools
      org-ql
      org-ref
      ox-gfm
      pdf-tools
      polymode
      poly-markdown
      # poly-org
      poly-R
      projectile
      rainbow-delimiters
      slime
      spacemacs-theme
      spaceline
      stan-mode
      undo-tree
      which-key
      yasnippet
    ]);
}
