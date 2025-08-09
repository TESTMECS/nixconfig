(import jwno/auto-layout)
(import jwno/indicator)
(import jwno/ui-hint)
(import jwno/layout-history) #
(import jwno/util) #
(import jwno/log) # 
(use jw32/_uiautomation) # For UIA_* constants
# Mod Key
(def mod-key "alt")
(unless (find |(= $ (string/ascii-lower mod-key)) ["win" "alt"])
  (errorf "unsupported mod key: %n" mod-key))
# Hint Key
(def hint-key
  (case (string/ascii-lower mod-key)
    "win" "RAlt"
    "alt" "RAlt"))
# Keyboard -------
(def keyboard-layout :qwerty)
(def dir-keys
  (case keyboard-layout
    :qwerty
    (case (string/ascii-lower mod-key)
      "alt"
      {:left  "H"
       :down  "J"
       :up    "K"
       :right "L"})))
(def hint-key-list (case keyboard-layout :qwerty "fjdksleiwocmxz"))
# Most of Jwno's APIs are exported as methods in these "manager" objects.
# You can inspect them in the Jwno REPL by looking into their prototypes.
# For example, to see all methods available in the window manager object:
#     (keys (table/proto-flatten (table/getproto (in jwno/context :window-manager))))
(def {:key-manager key-man
      :command-manager command-man
      :window-manager window-man
      :ui-manager ui-man
      :hook-manager hook-man
      :repl-manager repl-man}
  jwno/context)
# Replace the key placeholders with the actual key names
(defmacro $ [str]
  ~(->> ,str
        (peg/replace-all "${MOD}"  ,mod-key)
        (peg/replace-all "${HINT}" ,hint-key)
        (string)))
# A macro to simplify key map definitions. Of course you can call
(defmacro k [key-seq cmd &opt doc]
  ~(:define-key keymap ($ ,key-seq) ,cmd ,doc))
(def current-frame-area
  (indicator/current-frame-area jwno/context))
(put current-frame-area :margin 2)
(:enable current-frame-area)
(def ui-hint (ui-hint/ui-hint jwno/context))
(:enable ui-hint)
(def layout-history (layout-history/layout-history jwno/context))
(:enable layout-history true true)
#==========================#
#                          #
#  Key Bindings (Keymaps)  #
#                          #
#==========================#
(def resize-mode-keymap
  (let [keymap (:new-keymap key-man)]
    (k (in dir-keys :down)  [:resize-frame 0 -100])
    (k (in dir-keys :up)    [:resize-frame 0 100])
    (k (in dir-keys :left)  [:resize-frame -100 0])
    (k (in dir-keys :right) [:resize-frame 100 0])
    (k "="         :balance-frames)
    (k ";"         [:zoom-in 0.7])
    (k "Shift + ;" [:zoom-in 0.3])
    (k "Enter" :pop-keymap)
    (k "Esc"   :pop-keymap)
    keymap))

(def yank-mode-keymap
  (let [keymap (:new-keymap key-man)]
    (each dir [:down :up :left :right]
      (k (in dir-keys dir) [:move-window dir]))

    (k "Enter" :pop-keymap)
    (k "Esc"   :pop-keymap)

    keymap))

(def alpha-mode-keymap
  (let [keymap (:new-keymap key-man)]
    (k (in dir-keys :down) [:change-window-alpha -25])
    (k (in dir-keys :up)   [:change-window-alpha 25])
    (k "Enter" :pop-keymap)
    (k "Esc"   :pop-keymap)
    keymap))

# Jwno commands can accept closures/functions as arguments.
# For example, the :split-frame command accepts a function
# to adjust windows/frames after the splitting is done. Below
# is such a function to move the activated window into the
# new empty frame, and activate (move focus to) that frame.
# See the definitions for `${MOD} + ,` and `${MOD} + .` key bindings
# below.
(defn move-window-after-split [frame]
  (def all-sub-frames (in frame :children))
  (def all-wins (in (first all-sub-frames) :children))
  (def move-to-frame (in all-sub-frames 1))
  (when (>= (length all-wins) 2)
    (:add-child move-to-frame (:get-current-window frame)))
  (:activate move-to-frame))
# Here's another function to automatically move the focused
# window to a new frame, after :insert-frame command. See the
# definitions for `${MOD} + Q  I` and `${MOD} + Q  Shift + I` key
# bindings below.
(defn move-window-after-insert [dir frame]
  (def sibling
    (case dir
      :before (:get-next-sibling frame)
      :after  (:get-prev-sibling frame)))
  (def all-wins (in sibling :children))
  (when (>= (length all-wins) 2)
    (:add-child frame (:get-current-window sibling)))
  (:activate frame))
(defn match-exe-name [exe-name]
  (fn [win]
    (if-let [win-exe (:get-exe-path win)]
      (string/has-suffix? (string "\\" (string/ascii-lower exe-name))
                          (string/ascii-lower win-exe))
      false)))

(defn build-keymap [key-man]
  (let [keymap (:new-keymap key-man)]
    #-----------------#
    #  Basic Commands #
    #-----------------#
    (k "${MOD} + Shift + /" :show-root-keymap)
    (k "${MOD} + Shift + Q" :quit)
    (k "${MOD} + R"         :retile)
    #-------------------------------#
    #  Window And Frame Operations  #
    #-------------------------------#
    (k "${MOD} + Shift + C" :close-window-or-frame)
    (k "${MOD} + Shift + F" :close-frame)
    (k "${MOD} + ," [:split-frame :horizontal 2 [0.5] move-window-after-split]
       "Split current frame horizontally")
    (k "${MOD} + ." [:split-frame :vertical   2 [0.5] move-window-after-split]
       "Split current frame vertically")
    (k "${MOD} + =" :balance-frames)
    (k "${MOD} + ;"         [:zoom-in 0.7])
    (k "${MOD} + Shift + ;" [:zoom-in 0.3])
    (k "${MOD} + F" :fill-monitor)
    (k "${MOD} + P" :cascade-windows-in-frame)
    (k (string "${MOD} + " (in dir-keys :down))  [:enum-frame :next])
    (k (string "${MOD} + " (in dir-keys :up))    [:enum-frame :prev])
    (k (string "${MOD} + " (in dir-keys :left))  [:enum-window-in-frame :prev])
    (k (string "${MOD} + " (in dir-keys :right)) [:enum-window-in-frame :next])
    (each dir [:down :up :left :right]
      (k (string "${MOD} + Ctrl + "  (in dir-keys dir)) [:adjacent-frame dir])
      (k (string "${MOD} + Shift + " (in dir-keys dir)) [:move-window dir]))
    (k "${MOD} + S" [:push-keymap resize-mode-keymap]
       "Resize mode")
    (k "${MOD} + C" [:push-keymap yank-mode-keymap]
       "Yank mode")
    (k "${MOD} + Shift + S" :frame-to-window-size)
    (k "${MOD} + A" [:push-keymap alpha-mode-keymap]
       "Alpha mode")
    (k "${MOD} + W  Esc"   :nop "Cancel")
    (k "${MOD} + W  Enter" :nop "Cancel")
    (k "${MOD} + W  D" :describe-window)
    (k "${MOD} + W  M" :manage-window)
    (k "${MOD} + W  I" :ignore-window)
    (k "${MOD} + Q  Esc"   :nop "Cancel")
    (k "${MOD} + Q  Enter" :nop "Cancel")
    (k "${MOD} + Q  C"     :close-frame)
    (k "${MOD} + Q  F"     :flatten-parent)
    (k "${MOD} + Q  I"         [:insert-frame :after  (fn [fr] (move-window-after-insert :after fr))]
       "Insert a new frame after the current frame")
    (k "${MOD} + Q  Shift + I" [:insert-frame :before (fn [fr] (move-window-after-insert :before fr))]
       "Insert a new frame before the current frame")
    (k "${MOD} + Q  R"         :rotate-sibling-frames
       "Rotate sibling frames")
    (k "${MOD} + Q  Shift + R" [:rotate-sibling-frames nil nil 0]
       "Rotate monitors")
    (k "${MOD} + Q  V"         :reverse-sibling-frames
       "Reverse sibling frames")
    (k "${MOD} + Q  Shift + V" [:reverse-sibling-frames 0]
       "Reverse monitors")
    (k "${MOD} + Q  D"         :toggle-parent-direction
       "Toggle parent direction")
    (k "${MOD} + Q  Shift + D" [:toggle-parent-direction true 1]
       "Toggle monitor direction (flip layout)")
    (k "${MOD} + Enter  Esc" :nop
       "Cancel")
    (k "${MOD} + Enter  Enter" :nop
       "Cancel")
    (k "${MOD} + Enter  1" [:summon
                            (match-exe-name "zen.exe")
                            true
                            "C:\\Program Files\\Zen Browser\\zen.exe"]
       "Summon Zen Browser")
    (k "${MOD} + Enter  T" [:exec
                            true
                            "wezterm.exe"]
       "Launch WezTerm")
    (k "${MOD} + Enter  R" [:repl true "127.0.0.1" 9999]
       "Launch Jwno REPL")
    (let [win-enter-key (first (:parse-key keymap ($ "${MOD} + Enter")))
          win-enter-map (:get-key-binding keymap win-enter-key)]
      (:define-key win-enter-map
                   "Up Up Down Down Left Right Left Right B A"
                   :grant-lives))
    #----------------#
    #  UI Hint Keys  #
    #----------------#
    (k "${HINT}  ${HINT}"
       [:ui-hint hint-key-list]
       "Show all interactable elements")
    (k "${HINT}  B"
       [:ui-hint
        hint-key-list
        (ui-hint/uia-hinter
         :condition [:or
                     [:property UIA_ControlTypePropertyId UIA_ButtonControlTypeId]
                     [:property UIA_ControlTypePropertyId UIA_CheckBoxControlTypeId]])]
       "Show all buttons")
    (k "${HINT}  C"
       [:ui-hint
        hint-key-list
        (ui-hint/uia-hinter
         :action :click)]
       "Show all interactable elements, and click on the selected one")
    (k "${HINT}  D"
       [:ui-hint
        hint-key-list
        (ui-hint/uia-hinter
         :action :double-click)]
       "Show all interactable elements, and double-click on the selected one")
    (k "${HINT}  E"
       [:ui-hint
        hint-key-list
        (ui-hint/uia-hinter
         :condition [:and
                     [:or
                      [:property UIA_ControlTypePropertyId UIA_EditControlTypeId]
                      [:property UIA_ControlTypePropertyId UIA_ComboBoxControlTypeId]]
                     [:property UIA_IsKeyboardFocusablePropertyId true]])]
       "Show all editable fields")
    (k "${HINT}  F"
       [:ui-hint
        hint-key-list
        (ui-hint/uia-hinter
         :condition [:property UIA_IsKeyboardFocusablePropertyId true]
         :action :focus)]
       "Show all focusable elements, and set input focus to the selected one")
    (k "${HINT}  I"
       [:ui-hint
        hint-key-list
        (ui-hint/uia-hinter
         :condition [:property UIA_ControlTypePropertyId UIA_ListItemControlTypeId])]
       "Show all list item elements")
    (k "${HINT}  L"
       [:ui-hint
        hint-key-list
        (ui-hint/uia-hinter
         :condition [:property UIA_ControlTypePropertyId UIA_HyperlinkControlTypeId])]
       "Show all hyperlinks")
    (k "${HINT}  M"
       [:ui-hint
        hint-key-list
        (ui-hint/uia-hinter
         :action :middle-click)]
       "Show all interactable elements, and middle-click on the selected one")
    (k "${HINT}  Shift + M"
       [:ui-hint
        hint-key-list
        (ui-hint/uia-hinter
         :action :move-cursor)]
       "Show all interactable elements, and move cursor to the selected one")
    (k "${HINT}  R"
       [:ui-hint
        hint-key-list
        (ui-hint/uia-hinter
         :action :right-click)]
       "Show all interactable elements, and right-click on the selected one")
    (k "${HINT}  T"
       [:ui-hint
        hint-key-list
        (ui-hint/uia-hinter
         :condition [:property UIA_ControlTypePropertyId UIA_TreeItemControlTypeId])]
       "Show all tree item elements")
    (k "${HINT}  N"
       [:ui-hint
        hint-key-list
        (ui-hint/frame-hinter)]
       "Show all frames")
    (k "${HINT}  Shift + N"
       [:ui-hint
        hint-key-list
        (ui-hint/frame-hinter
         :action-fn (fn [fr]
                      (def wm (:get-window-manager fr))
                      (each w (in fr :children)
                        (:close w))
                      (:close fr)
                      (:retile wm (in fr :parent)))
         # The label color, 0xBBGGRR
         :color 0x00a1ff)]
       "Show all frames, and close the selected one")
    (k "${HINT}  G"
       [:ui-hint
        hint-key-list
        (ui-hint/gradual-uia-hinter
         :show-highlights true)]
       "Gradually walk the UI tree")
    (k "${HINT}  Esc"   :nop "Cancel")
    (k "${HINT}  Enter" :nop "Cancel")
    (k "${MOD} + Z  U" :undo-layout-history)
    (k "${MOD} + Z  R" :redo-layout-history)
    (k "${MOD} + Z  P" :push-layout-history)
    (k "${MOD} + Z  Esc"   :nop "Cancel")
    (k "${MOD} + Z  Enter" :nop "Cancel")
    keymap))
(def root-keymap (build-keymap key-man))
(:set-keymap key-man root-keymap)

(:add-hook hook-man :filter-forced-window
   (fn user-forced-window-filter [_hwnd uia-win _exe-path _desktop-info]
     (or
       (= "Ubisoft Connect" (:get_CachedName uia-win))
       # Add your own rules here
       )))
(:add-hook hook-man :filter-window
   (fn user-window-filter [_hwnd uia-win exe-path desktop-info]
     (def desktop-name (in desktop-info :name))
     # Excluded windows
     (not (or
            (= "Desktop 2" desktop-name)
            # Add your own rules here
            ))))

(:add-hook hook-man :filter-window
  (fn [_hwnd uia-win exe-path desktop-info]
    (not= "cs2.exe" (:get_CachedName uia-win))))

(:add-hook hook-man :window-created
   (fn [win uia-win _exe-path _desktop-info]
     (put (in win :tags) :anchor :center)
     (put (in win :tags) :margin 10)
     (def class-name (:get_CachedClassName uia-win))
     (cond
        (find |(= $ class-name)
             [
              "ConsoleWindowClass"
              "CASCADIA_HOSTING_WINDOW_CLASS"])
       (:set-alpha win (math/floor (* 256 0.9)))
       (= "#32770" class-name) # Dialog window class
       (put (in win :tags) :no-expand true))))
(:add-hook hook-man :monitor-updated
   (fn [frame]
     (put (in frame :tags) :padding 10)))

(:add-command command-man :fill-monitor
   (fn []
     (def cur-win (:get-current-window (in window-man :root)))
     (when cur-win
       (def cur-frame (in cur-win :parent))
       (def mon-frame (:get-top-frame cur-frame))
       (def rect (:get-padded-rect mon-frame))
       (:transform cur-win rect)))
   ```
   (:fill-monitor)

   Resizes the focused window, so that it fills the whole work
   area of the current monitor.
   ```)

(:add-command command-man :show-root-keymap
   (fn []
     (:show-tooltip
        ui-man
        :show-root-keymap
        (:format root-keymap)
        nil
        nil
        10000
        :center))
   ```
   (:show-root-keymap)

   Shows the root keymap defined in the config file.
   ```)
(:add-command command-man :grant-lives
   (fn []
     (:show-tooltip
        ui-man
        :grant-lives
        "Congratulations! You've been granted infinite lives ;)"
        nil
        nil
        5000
        :center)))
