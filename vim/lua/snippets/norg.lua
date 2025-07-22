-- ~/.config/nvim/lua/snippets/norg.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local f = ls.function_node

local date = function()
  return os.date("%Y-%m-%d")
end

ls.add_snippets("norg", {
  s("daily", {
    t({ "* Journal — " }), f(date), t({ "", "" }),

    t({ "** 🌇 Evening Wrap", "" }),
    t({ "- 🛠 What did I actually work on?", "  • " }), i(1), t({ "", "" }),
    t({ "- ⚡ What had momentum or felt satisfying?", "  • " }), i(2), t({ "", "" }),
    t({ "- 🧱 What pulled energy, frustrated, or felt heavy?", "  • " }), i(3), t({ "", "" }),
    t({ "- 🧠 What thought or question is still lingering?", "  • " }), i(4), t({ "", "" }),
    t({ "- 🔎 Did anything stand out today — technically or emotionally?", "  • " }), i(5), t({ "", "" }),
    t({ "- 🔄 Do I want to change how I show up tomorrow?", "  • " }), i(6), t({ "", "" }),

    t({ "", "**** 🛠 Work Debug", "" }),
    t({ "- 🔧 What am I working on?", "  • " }), i(7), t({ "", "" }),
    t({ "- 🔍 What's not clear or causing friction?", "  • " }), i(8), t({ "", "" }),
    t({ "- 🧠 Any ideas or hunches?", "  • " }), i(9), t({ "", "" }),
    t({ "- 📓 What have I tried?", "  • " }), i(10), t({ "", "" }),
    t({ "- 🚩 Any assumptions to challenge?", "  • " }), i(11), t({ "", "" }),
    t({ "- ⏭️ Next step or experiment:", "  • " }), i(12), t({ "", "" }),

    t({ "", "*** 💡 Interesting Things", "- " }), i(13), t({ "", "- " }), i(14), t({ "", "- " }), i(15), t({ "", "" }),

    t({ "*** 📍 One-liner Insight of the Day", "- " }), i(16),
  }),
  s("morning", {
    t({ "** 🌞 Morning Kickstart", "" }),
    t({ "- 🧠 How do I want to *feel* today?", "  • " }), i(1), t({ "", "" }),
    t({ "- 🎯 What’s my *one key intention* or focus?", "  • " }), i(2), t({ "", "" }),
    t({ "- 🌱 One habit I want to keep or shift today:", "  • " }), i(3), t({ "", "" }),
    t({ "- 🚧 Anything that might get in the way?", "  • " }), i(4), t({ "", "" }),
    t({ "- ✅ What will make today feel like a win?", "  • " }), i(5),
  }),
  s("evening", {
    t({ "** 🌇 Evening Wrap", "" }),
    t({ "- 🛠 What did I actually work on?", "  • " }), i(1), t({ "", "" }),
    t({ "- ⚡ What had momentum or felt satisfying?", "  • " }), i(2), t({ "", "" }),
    t({ "- 🧱 What pulled energy, frustrated, or felt heavy?", "  • " }), i(3), t({ "", "" }),
    t({ "- 🧠 What thought or question is still lingering?", "  • " }), i(4), t({ "", "" }),
    t({ "- 🔎 Did anything stand out today — technically or emotionally?", "  • " }), i(5), t({ "", "" }),
    t({ "- 🔄 Do I want to change how I show up tomorrow?", "  • " }), i(6), t({ "", "" }),
  }),
  s("work", {
    t({ "", "** 🛠 Work Debug", "" }),
    t({ "- 🔧 What am I working on?", "  • " }), i(7), t({ "", "" }),
    t({ "- 🔍 What's not clear or causing friction?", "  • " }), i(8), t({ "", "" }),
    t({ "- 🧠 Any ideas or hunches?", "  • " }), i(9), t({ "", "" }),
    t({ "- 📓 What have I tried?", "  • " }), i(10), t({ "", "" }),
    t({ "- 🚩 Any assumptions to challenge?", "  • " }), i(11), t({ "", "" }),
    t({ "- ⏭️ Next step or experiment:", "  • " }), i(12), t({ "", "" }),
  }),
  s("mindset", {
    t({ "* Mindset Reframe + Future Self — " }), f(date), t({ "", "" }),

    t({ "** 😟 Default Thought Pattern (name the vibe)", "- " }), i(1, "Insecure, doubtful, hesitant"), t({ "", "" }),
    t({ "** 🧠 What thoughts or beliefs are showing up?", "- " }), i(2), t({ "", "" }),
    t({ "** 🌱 What mindset do I *want* to shift into?", "- " }), i(3, "Confident, grounded, clear"), t({ "", "" }),
    t({ "** 💬 Reframed thoughts (say them boldly)", "- " }), i(4), t({ "", "" }),
    t({ "** 🎭 Identity Role Play — Imagine it’s already true", "- " }), i(5,
    "I log on with clarity. I own my updates. I debug calmly. I trust myself."), t({ "", "" }),
    t({ "** 🧘‍♂️ Embodied shift (what it feels like in the body)", "- " }), i(6, "Steady. Clear. Energized."), t({ "",
    "" }),
    t({ "** 📛 Anchor mantra for the day", "- " }), i(7, "I bring order to chaos."), t({ "", "" }),
  }),
})
