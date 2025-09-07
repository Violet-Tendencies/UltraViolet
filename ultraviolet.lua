----------------------------------------------
-------------- Files -------------------------


assert(SMODS.load_file("data/jokers/rivals.lua"))()
assert(SMODS.load_file("data/jokers/stupendium.lua"))()
assert(SMODS.load_file("data/jokers/religions/sins.lua"))()
assert(SMODS.load_file("data/consumables/stupendium.lua"))()
assert(SMODS.load_file("data/blinds/religions/virtues.lua"))()
assert(SMODS.load_file("data/stakes/insanity.lua"))()
assert(SMODS.load_file("data/Technically Cross-Mod stuff/oaths.lua"))()
SMODS.load_file("data/jokers/misc.lua")()
SMODS.load_file("data/decks/religions/magics.lua")()
SMODS.load_file("data/editions/emotions.lua")()


----------------------------------------------
------------Other stuff-----------------------

-- CREDIT TO SROCKW FOR THIS HOLY SHIT TYSM
function parse_description_box_line(line, vars)
  return {
    n = G.UIT.R,
    config = { align = 'cm' },
    nodes = SMODS.localize_box(loc_parse_string(line), { scale = 1, vars = vars })
  }
end

function parse_description_box(lines, vars)
  local element = {
    n = G.UIT.R,
    config = { align = 'cm', colour = G.C.UI.BACKGROUND_WHITE, r = 0.1, padding = 0.04, minw = 2, minh = 0.8, emboss = 0.05, filler = true },
    nodes = {}
  }

  for _, v in ipairs(lines or {}) do
    table.insert(element.nodes, parse_description_box_line(v, vars))
  end

  return element
end

function parse_card_hover_box(data, vars)
  local background_color = adjust_alpha(darken(G.C.BLACK, 0.1), 0.8)

  local lines = {}

  if data.text and data.text[1] then
    local t = type(data.text[1])

    if t == "string" then
      lines[#lines + 1] = parse_description_box(data.text, data.vars)
    elseif t == "table" then
      for _, v in ipairs(data.text) do
        lines[#lines + 1] = parse_description_box(v, data.vars)
      end
    end
  end

  local element = {
    n = G.UIT.ROOT,
    config = { align = "cm", colour = G.C.CLEAR },
    nodes = {
      {
        n = G.UIT.R,
        config = { padding = 0.05, r = 0.12, colour = lighten(G.C.JOKER_GREY, 0.5), emboss = 0.07 },
        nodes = {
          {
            n = G.UIT.C,
            config = { align = 'cm', padding = 0.07, r = 0.1, colour = background_color },
            nodes = {
              {
                n = G.UIT.R,
                config = { align = 'cm' },
                nodes = {
                  {
                    n = G.UIT.O,
                    config = {
                      object = DynaText {
                        string = data.name,
                        colours = { G.C.UI.TEXT_LIGHT },
                        shadow = true,
                        spacing = 0,
                        bump = true,
                        scale = 0.5,
                        padding = 0.03,
                      }
                    }
                  }
                }
              },
              unpack(lines)
            }
          }
        }
      }
    }
  }

  return element
end