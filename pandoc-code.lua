--[[
Filter to force the Markdown writer to use backtick (or fenced) code blocks,
kind of like `pandoc --atx-headers` forces the writer to use `##` for headers.
There is no direct way to disable indented code blocks, but if you add
a non-trivial attribute, the Markdown writer won't use indentation, but
instead will use backticks (or tildes, if backticks won't work).

This is a workaround for https://github.com/jgm/pandoc/issues/5280

It is only a partial workaround, because it requires a sed script to
post-process the adjusted Pandoc output.  Ideally, Pandoc would have
an option like --fenced-code-blocks which would request that the
parser avoid the hardwired indented code block syntax, just like
--atx-headers avoids the hardwired setext headers.  The claimed
problem with those hardwired output notations is they harder for
simple scripts to parse than ## and ``` notations, because they use
column counting on multiple lines, and relative indentation, to
respectively mark headers and code blocks.  It is acknowledged
that Markdown is designed more for human eyes than simple parsers,
and that trying to adjust Markdown output to be "simple to parse",
somehow, is a slippery slope.

]]

local nullAttr = pandoc.Attr()
local almostNullAttr = pandoc.Attr(nil, {"code"})
function CodeBlock(cb)
  if cb.attr == nullAttr then
    cb.attr = almostNullAttr
    return cb
  end
end

--[[ Demonstration commands:

$ echo $'## yada\n\n```\nhello world\n```' > /tmp/F0
$ pandoc < /tmp/F0 --lua-filter ./pandoc-codeblock.lua --atx-headers -t markdown > /tmp/F1
$ diff /tmp/F[01]  # shows addition of ' {.code}'

If you don't want to see the `{.code}` bits, here's another filter for you:

$ sed < /tmp/F1 '/^````* {\.code}$/s/ .*//' > /tmp/F2
$ diff /tmp/F[02]  # empty output

The choice of the class name "code" is arbitrary, but is intended to
have a neutral appearance.  In fact, if you intend to use the sed
filter, replace the class name "code" (in almostNullAttr) with
something really ugly you are sure will never appear in your
documents, so you won't match it by accident.

]]
