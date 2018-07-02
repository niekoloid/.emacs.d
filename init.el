;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.1 Elispをインストールしよう                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
        (normal-top-level-add-subdirs-to-load-path))))))
(add-to-load-path "elisp" "conf" "public_repos")

;;(require 'init-loader)
;;(init-loader-load "~/.emacs.d/conf")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 4.1 効率的な設定ファイルの作り方と管理方法             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;;; P61 Elisp配置用のディレクトリを作成
;; ;; load-pathを追加する関数を定義
;; 

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加 
;; 

;;; P63 Emacsが自動的に書き込む設定をcustom.elに保存する
;; カスタムファイルを別ファイルにする
;;(setq custom-file (locate-user-emacs-file "custom.el"))
;; (カスタムファイルが存在しない場合は作成する
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
;; カスタムファイルを読み込む
(load custom-file)

;;; P112-113 ELPAリポジトリを追加する
;; (require 'package) ; package.elを有効化

(package-initialize) 
(add-to-list
 'package-archives
 '("marmalade" . "https://marmalade-repo.org/packages/"))

 (add-to-list
  'package-archives
  '("melpa" . "https://melpa.org/packages/"))

 (add-to-list
 'package-archives
 '("gnu" . "https://elpa.gnu.org/packages/"))

;; 最新のpackageリストを読み込む
(when (not package-archive-contents)
  (package-refresh-contents))

;; install packages (skip if exist)
(package-install 'ace-window)
(package-install 'smex)
(package-install 'swiper)
(package-install 'flycheck)
(package-install 'intero)
(package-install 'haskell-mode)
(package-install 'lsp-rust)
(package-install 'rust-playground)
(package-install 'yasnippet)
(package-install 'company-racer)
(package-install 'ivy-hydra)
(package-install 'exec-path-from-shell)
(package-install 'cargo)
(package-install 'flycheck-rust)
(package-install 'racer)
(package-install 'rust-mode)
(package-install 'git-wip-timemachine)
(package-install 'magithub)
(package-install 'git-timemachine)
(package-install 'browse-at-remote)
(package-install 'use-package)
(package-install 'better-defaults)
(package-install 'which-key)
(package-install 'magit)
(package-install 'counsel)
(package-install 'swiper)
(package-install 'ivy)
(package-install 'zenburn-theme)
(package-install 'auto-complete)
(package-install 'color-moccur)
(package-install 'wgrep)
(package-install 'undohist)
(package-install 'undo-tree)
(package-install 'eldoc)

(package-install 'neotree)
(package-install 'protobuf-mode)
;;(package-install 'point-undo)
;;(package-install 'toml-mode)


;; Apply above installed packages
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

;; '(inhibit-startup-screen t)


;; basic key bindings
(global-set-key (kbd "C-m") 'newline-and-indent)
(keyboard-translate ?\C-h ?\C-?)            
(define-key global-map (kbd "C-t") 'other-window)
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)
(define-key global-map (kbd "C-;") 'comment-dwim)


(global-auto-revert-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.4 入力の効率化                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; P128 補完入力の強化 Auto Complete Mode
;; auto-completeの設定
(when (require 'auto-complete-config nil t)
  (define-key ac-mode-map (kbd "C-M") 'auto-complete)
  (ac-config-default)
  (setq ac-use-menu-map t)
  (setq ac-ignore-case nil))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.5 検索と置換の拡張                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; P129-130 検索結果をリストアップする color-moccur
;; color-moccurの設定
(when (require 'color-moccur nil t)
  ;; M-oにoccur-by-moccurを割り当て
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  ;; スペース区切りでAND検索
  (setq moccur-split-word t)
  ;; ディレクトリ検索のとき除外するファイル
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$"))

;;; P131-132 moccurの結果を直接編集 moccur-edit
;; moccur-editの設定
(require 'moccur-edit nil t)
;; moccur-edit-finish-editと同時にファイルを保存する
(defadvice moccur-edit-change-file
  (after save-after-moccur-edit-buffer activate)
  (save-buffer))

;;; P133 grepの結果を直接編集 wgrep
;; wgrepの設定
(require 'wgrep nil t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.6 さまざまな履歴管理                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; P135 編集履歴の記憶 undohist
;; undohistの設定
(when (require 'undohist nil t)
  (undohist-initialize))

;;; P136 アンドゥの分岐履歴 undo-tree
;; undo-treeの設定
(when (require 'undo-tree nil t)
  ;; C-'にリドゥを割り当てる
  (define-key global-map (kbd "C-'") 'undo-tree-redo)
  (global-undo-tree-mode))

;;; P137 カーソルの移動履歴 point-undo
;; point-undoの設定
;; (when (require 'point-undo nil t)
;;   (define-key global-map (kbd "M-[") 'point-undo)
;;  (define-key global-map (kbd "M-]") 'point-redo))

;;; P85 文字コードを指定する
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; windmove
;; (setq-default windmove-wrap-around t) 
;; (global-set-key (kbd "S-<left>")  'windmove-left)
;; (global-set-key (kbd "S-<right>") 'windmove-right)
;; (global-set-key (kbd "S-<up>")    'windmove-up)
;; (global-set-key (kbd "S-<down>")  'windmove-down)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5.7 ハイライトの設定                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; P98 現在行のハイライト
(defface my-hl-line-face
  ;; 背景がdarkならば背景色を紺に
  '((((class color) (background dark))
     (:background "NavyBlue" t))
    ;; 背景がlightならば背景色を青に
    (((class color) (background light))
     (:background "LightSkyBlue" t))
    (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode t)

;; P99 括弧の対応関係のハイライト
;; paren-mode：対応する括弧を強調して表示する
(setq show-paren-delay 0) ; 表示までの秒数。初期値は0.125
(show-paren-mode t) ; 有効化
;; parenのスタイル: expressionは括弧内も強調表示
;;(setq show-paren-style 'expression)
;; フェイスを変更する
;;(set-face-background 'show-paren-match-face nil)
;;(set-face-underline-p 'show-paren-match-face "darkgreen")
                      
;;; Settings on Mode Line
;; カラム番号も表示
(column-number-mode t)

;; ファイルサイズを表示
(size-indication-mode t)

(setq display-time-day-and-date t) ; 曜日・月・日を表示

;; タイトルバーにファイルのフルパスを表示
(setq frame-title-format "%f")

;; 行番号を常に表示する
(global-linum-mode t)


;; custom.el?
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(compilation-scroll-output (quote first-error))
 '(counsel-mode t)
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(inhibit-startup-screen t)
 '(magit-repository-directories (quote (("~" . 2))))
 '(menu-bar-mode nil)
 '(ns-alternate-modifier (quote none))
 '(ns-command-modifier (quote meta))
 '(package-enable-at-startup nil)
 '(package-selected-packages
   (quote
    (undo-tree undohist wgrep edit-moccur color-moccur moccur-color moccur-edit auto-complete zenburn-theme flycheck ace-window smex intero haskell-mode lsp-rust rust-playground yasnippet company-racer ivy-hydra exec-path-from-shell cargo flycheck-rust racer rust-mode git-wip-timemachine magithub git-timemachine browse-at-remote use-package better-defaults which-key magit counsel swiper ivy))) ;;(point-undo undo-tree undohist wgrep edit-moccur color-moccur moccur-color moccur-edit auto-complete zenburn-theme flycheck ace-window smex intero haskell-mode lsp-rust rust-playground yasnippet company-racer ivy-hydra exec-path-from-shell cargo flycheck-rust racer rust-mode git-wip-timemachine magithub git-timemachine browse-at-remote use-package better-defaults which-key magit counsel swiper ivy)))
 '(rust-rustfmt-bin "rustfmt")
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; pick the exec path from env
(require 'exec-path-from-shell)
(when (string= window-system "ns")
  (exec-path-from-shell-initialize))

;; which-key-mode
(require 'which-key)
(which-key-mode 1)

;; https://github.com/technomancy/better-defaults
(require 'better-defaults)
;; save-place (as used by better-defaults is now replaced by
;; save-place-mode
(if (fboundp #'save-place-mode)
  (save-place-mode +1)
  (setq-default save-place t))

;; magit
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)
(global-magit-file-mode)

;; ivy-counsel-swiper
(require 'ivy)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)        ; switch to buffers of files visited in a previous session
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(require 'swiper)
(global-set-key (kbd "C-s") 'swiper)
(require 'counsel)
(require 'smex)                         ; last/frequent minibuffer commands
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
;; (global-set-key (kbd "C-c k") 'counsel-ag)
;; (global-set-key (kbd "C-x l") 'counsel-locate)


;; irony-mode (c++, libclang)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
;; Windows performance tweaks;;
(when (boundp 'w32-pipe-read-delay)
  (setq w32-pipe-read-delay 0))
;; Set the buffer size to 64K on Windows (from the original 4K)
(when (boundp 'w32-pipe-buffer-size)
  (setq irony-server-w32-pipe-buffer-size (* 64 1024)))

;; intero-mode for haskell
(require 'intero)
(add-hook 'haskell-mode-hook 'intero-mode)

;; enable advanced functions
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; protobuf
(require 'protobuf-mode)

(provide 'init)


;; hook for emacs-lisp-mode
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (when (require 'eldoc nil t)
               (setq eldoc-idle-delay 0.2)
               (setq eldoc-echo-area-use-multiline-p t)
               (turn-on-eldoc-mode))))          


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.2 テーマ                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; P119-121 テーマの変更)
;; zenburnテーマを利用する
(load-theme 'zenburn t)


;; Rust mode
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))

;; cargo.el
(add-hook 'rust-mode-hook 'cargo-minor-mode)

;: rustfmt
(add-hook 'rust-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c <tab>") #'rust-format-buffer)))

(defun indent-buffer ()
  "Indent current buffer according to major mode."
  (interactive)
  (indent-region (point-min) (point-max)))

;; racer
(setq racer-cmd "~/.cargo/bin/racer") ;; Rustup binaries PATH
(setq racer-rust-src-path "~/.cargo/registry/src") ;; Rust source code PATH 

(add-hook 'rust-mode-hook #'racer-mode)
;;(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)

;; flycheck-rust
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
