-- ─────────────────────────────────────────────────────────────
-- FGCZ report toolbar: header-driven button selection
--
-- Lets a report choose which fgcz-plot-finder.html toolbar buttons appear via a
-- top-level `fgcz-buttons:` key in its YAML header, e.g.
--
--   fgcz-buttons: search              # 🔍 only
--   fgcz-buttons: [search, download]  # both
--
-- This filter reads that key and injects a `window.FGCZ_BUTTONS` global into the
-- <head>, which the toolbar script prefers over its built-in defaults. Without
-- the key the filter is a no-op and the toolbar falls back to its own logic
-- (fgcz_render()'s baked-in list, or all buttons). Only wired into the Quarto
-- extension channel; the R fgcz_render() path selects buttons directly instead.
-- ─────────────────────────────────────────────────────────────

local function names_from(meta_value)
  local names = {}
  if meta_value.t == "MetaList" then
    for _, v in ipairs(meta_value) do
      names[#names + 1] = pandoc.utils.stringify(v)
    end
  else
    -- MetaInlines / MetaString, possibly space-separated ("search download").
    for word in pandoc.utils.stringify(meta_value):gmatch("%S+") do
      names[#names + 1] = word
    end
  end
  return names
end

function Meta(meta)
  local value = meta["fgcz-buttons"]
  if value == nil then
    return nil
  end

  local names = names_from(value)
  if #names == 0 then
    return nil
  end

  local quoted = {}
  for _, name in ipairs(names) do
    quoted[#quoted + 1] = '"' .. name:gsub('"', '\\"') .. '"'
  end
  quarto.doc.include_text(
    "in-header",
    "<script>window.FGCZ_BUTTONS = [" .. table.concat(quoted, ",") .. "];</script>"
  )
  return nil
end
