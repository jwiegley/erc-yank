# erc-yank

Automagically create a Gist if pasting more than 5 lines

Hook in as follows:

    (add-hook 'erc-mode-hook
              (lambda () (define-key erc-mode-map [(control ?y)] 'erc-yank)))

Or, if you want to use my `use-package' macro:

    (use-package erc
      :commands erc
      :config
      (use-package erc-yank
        :init
        (bind-key "C-y" 'erc-yank erc-mode-map)))

If you want to use github instead of sprunge.us, install gist.el
from https://github.com/defunkt/gist.el and add

    (require 'gist)
    (setq erc-yank-gisting-function 'erc-yank-gh-gist-region)

