return {
    {
        "kylechui/nvim-surround",
        event = { "BufReadPre", "BufNewFile" },
        version = "*", -- Stable release
        config = true, -- Automatically calls require("nvim-surround").setup()

        -- Reference for keybindings:
        -- NORMAL MODE ----------------------------------------------------------
        -- Add surrounding      -> ysa{motion}{char}     (e.g. ysiw" => "word")
        -- Surround whole line  -> yss{char}             (e.g. yss" => "whole line")
        -- Change surrounding   -> cs{old}{new}          (e.g. cs"' => 'text' to "text")
        -- Delete surrounding   -> ds{char}              (e.g. ds" => remove quotes)
        --
        -- VISUAL MODE ----------------------------------------------------------
        -- Surround selection   -> S{char}               (e.g. select word, then S" => "word")
        --
        -- Surrounding characters:
        --   "   →  "text"
        --   '   →  'text'
        --   )   →  (text)
        --   ]   →  [text]
        --   }   →  {text}
        --   >   →  <text>
        --   t   →  <tag>text</tag>
        --
        -- Python Examples:
        --   ysiw"   → "word"
        --   cs"'    → 'change quotes'
        --   ds(     → remove parentheses
        --   S'      → surround visual selection with single quotes
    },
}
