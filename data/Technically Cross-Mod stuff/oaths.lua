local sobriety_skips = 0
local sobriety_goal = 1
local localization = {
    b_oaths_cap = "Oaths",
    m_secrecy = "Oath of Secrecy",
    m_fiscality = "Oath of Fiscality",
    m_finality = "Oath of Finality",
    m_vitality = "Oath of Vitality",
    m_sobriety = "Oath of Sobriety",
    m_enmity = "Oath of Emnity",
    m_assiduity = "Oath of Assiduity",
    m_sagacity = "Oath of Sagacity",
    gald_oaths = "Oaths"
}

local all_oaths = {
    "secrecy",
    "fiscality",
    "finality",
    "vitality",
    "sobriety",
    "enmity",
    "assiduity",
    "sagacity", 
    "", 
    "", 
    "", 
}

-- localization
function SMODS.current_mod.process_loc_text()
    for k, v in pairs(localization) do
        SMODS.process_loc_text(G.localization.misc.dictionary, k, v)
    end
end

-- default values
G.Oaths_oaths = {}
for _, v in ipairs(all_oaths) do 
    if v ~= "" then G.Oaths_oaths[v] = false end 
end

sendDebugMessage("Loaded Oaths~")

---- Oaths UI

-- Add "oaths" button
local run_setup_optionref = G.UIDEF.run_setup_option
function G.UIDEF.run_setup_option(type)
    local t = run_setup_optionref(type)
    if Galdur then return t end
    local button = 
    { n = G.UIT.R, config = { align = "cm", padding = 0 }, nodes = {
        { n = G.UIT.C, config = { align = "cm", minw = 2.4 }, nodes = {} },
        { n = G.UIT.C,
            config = { align = "cm", minw = 2.6, minh = 0.6, padding = 0.2, r = 0.1, hover = true, colour = G.C.RED, button = "oaths", shadow = true },
            nodes = {{
                n = G.UIT.R, config = { align = "cm", padding = 0 },
                nodes = {
                    { n = G.UIT.T, config = { text = localize('b_oaths_cap'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true, func = 'set_button_pip', focus_args = { button = 'x', set_button_pip = true } } }
                }
            }}
        },
        { n = G.UIT.C, config = { align = "cm", minw = 2.5 }, nodes = {} }
    }}
    table.insert(t.nodes, 3, button)
    return t
end

-- Create a oaths row
function add_oaths_node(oaths_name, run_info)
    if not oaths_name or oaths_name == "" then
        if Galdur then return end
        return
        { n = G.UIT.R, config = {align = "c", minw = 8, padding = 0, colour = G.C.CLEAR}, nodes = {
            {n = G.UIT.C, config = { align = "cr", padding = 0.1 }, nodes = {}},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = "", scale = 0.9175, colour = G.C.UI.TEXT_LIGHT, shadow = true }},
            }},
        }}
    end
    return 
    { n = G.UIT.R, config = {align = "c", minw = 8, padding = 0, colour = G.C.CLEAR}, nodes = {
        {n = G.UIT.C, config = { align = Galdur and "cl" or "cr", padding = not Galdur and 0.1 }, nodes = {
            run_info and nil or create_toggle{ col = true, label = "", w = 0, scale = Galdur and 0.5 or 0.6, shadow = true, ref_table = G.Oaths_oaths, ref_value = oaths_name },
        }},
        {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
            { n = G.UIT.T, config = { text = localize('m_'..oaths_name), scale = Galdur and 0.27 or 0.3, colour = G.C.UI.TEXT_LIGHT, shadow = true }},
        }},
    }}
end

-- UIBox for oaths
function create_UIBox_oaths()
    local page_options = {
        "Oaths"
    }

    G.E_MANAGER:add_event(Event({func = (function()
        G.FUNCS.oaths_change_page{cycle_config = {current_option = 1}}
    return true end)}))

    local t = create_UIBox_generic_options({ back_id = G.STATE == G.STATES.GAME_OVER and 'from_game_over', back_func = 'setup_run', contents = {
        { n = G.UIT.R, config = { align = "cm", padding = 0.1, minh = Galdur and 6 or 9, minw = 4.2 }, nodes = {
            { n = G.UIT.O, config = { id = 'oaths_list', object = Moveable() }},
        }},
        { n = G.UIT.R, config = { align = "cm" }, nodes = {
            create_option_cycle({options = page_options, w = 4.5, cycle_shoulders = true, opt_callback = 'oaths_change_page', current_option = 1, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
        }},
    }})
    return t
end

G.FUNCS.oaths = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_oaths(),
    }
end

-- Page buttons
G.FUNCS.oaths_change_page = function(args)
    if not args or not args.cycle_config then return end
    if G.OVERLAY_MENU then
        local m_list = G.OVERLAY_MENU:get_UIE_by_ID('oaths_list')
        if m_list then
            if m_list.config.object then
                m_list.config.object:remove()
            end
            m_list.config.object = UIBox {
                definition = oaths_page(args.cycle_config.current_option - 1),
                config = { offset = { x = 0, y = 0 }, align = 'cm', parent = m_list }
            }
        end
    end
end

function oaths_page(_page)
    local oaths_list = {}
    for k, v in ipairs(all_oaths) do
        if k > 12 * (_page or 0) and k <= 12 * ((_page or 0) + 1) then
            oaths_list[#oaths_list + 1] = add_oaths_node(v)
        end
    end

    for _ = #oaths_list+1, 12 do
        oaths_list[#oaths_list + 1] = add_oaths_node(nil)
    end
  
    return {n=G.UIT.ROOT, config={align = Galdur and "tl" or "c", padding = 0, colour = G.C.CLEAR}, nodes = oaths_list}
end

---- Apply oaths to run
local start_runref = Game.start_run
function Game.start_run(self, args)
    if args.savetext then
        start_runref(self, args)
        return
    end

    args.challenge = args.challenge or {
        rules = {
            custom = {},
            modifiers = {},
        }
    }

    
    for k, v in pairs(args.challenge.rules.custom) do
        sendDebugMessage(v.id)
    end

    start_runref(self, args)

    -- hmst
    for _, v in ipairs(all_oaths) do 
        if v ~= "" then self.GAME.modifiers[v] = false end 
    end
    for k, v in pairs(G.Oaths_oaths) do
        if v then
            self.GAME.modifiers[k] = true 
        end
    end

    sobriety_skips = 0
    sobriety_goal = 1
    if self.GAME.modifiers.sobriety then
        self.jokers.config.card_limit = 1
    end
    if self.GAME.modifiers.enmity then
        self.consumeables.config.card_limit = self.consumeables.config.card_limit - 1
        self.GAME.win_ante = G.GAME.win_ante + 3
    end
    if self.GAME.modifiers.sagacity then
        self.GAME.modifiers.no_blind_reward = self.GAME.modifiers.no_blind_reward or {}
        self.GAME.modifiers.no_blind_reward.Big = true
        self.GAME.modifiers.no_blind_reward.Boss = true
        self.GAME.modifiers.no_blind_reward.Small = true
        self.GAME.modifiers.no_interest = true
        self.GAME.modifiers.money_per_discard = 0
        self.GAME.modifiers.money_per_hand = 0
        self.GAME.dollars = 50 
        
    end
    if self.GAME.modifiers.vitality then
        self.GAME.starting_params.ante_scaling = (self.GAME.starting_params.ante_scaling or 1) * 2
    end
    self.GAME.modifiers.oath_start = true
end

-- joker mods
local create_cardref = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    local card = create_cardref(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if _type == "Joker" or _type == "Abnormality" then
        if G.GAME.modifiers.assiduity then
            card.ability.perishable = true
            card.ability.perish_tally = G.GAME.perishable_rounds
        end
    end
    return card
end

local heheheiwonttell = get_blind_amount
function get_blind_amount(ante)
    local ret = heheheiwonttell(math.floor(ante))
    local scale = (G.GAME.modifiers.scaling or 1)
    local amounts = {
        300,
        700 + 100*scale,
        1400 + 600*scale,
        2100 + 2900*scale,
        15000 + 5000*scale*math.log(scale),
        12000 + 8000*(scale+1)*(0.4*scale),
        10000 + 25000*(scale+1)*((scale/4)^2),
        50000 * (scale+1)^2 * (scale/7)^2
    }
    if math.floor(ante) ~= ante or ante < 1 then
        local a, b, c, d, e
        e = ante
        if ante < 0 then
            e = -ante
        else 
            a, b, c, d = 100, 1.6, e, 1 + (0.2*e)
        end
        if e < -9 then
            a, b, c, d = 100,1.6,-(e-8), 1 + -(0.2*(e-8))
        end
        if e <= 8 and e >= 1 then
            a, b, c, d = amounts[math.floor(e)],1.6,e, 1 + 0.2*(e)
        end
        if e >= 9 then
            a, b, c, d = amounts[math.floor(e)],1.6,e-8, 1 + 0.2*(e-8)
        end
        local amount = math.floor(a*(b+(0.75*c)^d)^c)
        if e < 1 then
            return math.floor((ret + (math.floor(amount * (e - math.floor(e)))))/2)
        else
            return math.floor(0.1 * (ret + (math.floor(amount * (e - math.floor(e)))))) 
        end
    else
        return ret
    end
end

SMODS.current_mod.calculate = function(self, context)
    if context.game_over then
        G.GAME.modifiers.oath_start = false
    end
    if G.GAME.modifiers.oath_start then
        if G.GAME.modifiers.sagacity and not G.GAME.modifiers.sagacity_lock then
            if context.blind_defeated then
                G.GAME.shop.joker_max = 10
            end
            if context.setting_blind and context.blind.name == "Big Blind" then
                G.GAME.modifiers.sagacity_lock = true
                G.GAME.shop.joker_max = -99999
            end
        end
        if G.GAME.modifiers.assiduity then
                if context.destroying_card then
                    context.destroying_card.assiduityCounter = (context.destroying_card.assiduityCounter or 0) + 1
                    if context.destroying_card.assiduityCounter >= 2 then
                        return {
                            remove = true,
                             card = context.destroying_card
                        }
                    end
                end
            if context.beat_boss and context.blind_defeated then
                for k, v in ipairs(G.hand.cards) do
                    v.assiduityCounter = 0
                end
                for k, v in ipairs(G.discard.cards) do
                    v.assiduityCounter = 0
                end
                for k, v in ipairs(G.deck.cards) do
                    if v and v.assiduityCounter then
                        v.assiduityCounter = 0
                    end
                end
                for k, v in ipairs(G.play.cards) do
                    if v and v.assiduityCounter then
                        v.assiduityCounter = 0
                    end
                end
            end
        end
        if G.GAME.modifiers.enmity then
            if context.setting_blind then
                G.GAME.modifiers.enmity_increment = false
            end
            if context.beat_boss and not G.GAME.modifiers.enmity_increment then
                G.GAME.modifiers.enmity_increment = true
                ease_ante(0.5)
            end
        end
        if G.GAME.modifiers.sobriety then
            if context.skip_blind then
                sobriety_skips = sobriety_skips + 1
                if sobriety_skips >= sobriety_goal and sobriety_goal <= 3 then
                    G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                    sobriety_skips = 0
                    sobriety_goal = sobriety_goal + 1
                end
            end
        end
        if G.GAME.modifiers.finality then
            if context.selling_card or context.joker_type_destroyed then
                G.GAME.banned_keys[#G.GAME.banned_keys + 1] = context.card
                if #G.GAME.banned_keys % 6 == 0 and G.jokers.config.card_limit > 1 then
                    G.jokers.config.card_limit = G.jokers.config.card_limit - 1
                end
            end
            if context.ending_shop then
                for k, v in ipairs(G.shop_jokers.cards) do
                    if v then
                        G.GAME.banned_keys[#G.GAME.banned_keys + 1] = v
                        if #G.GAME.banned_keys % 6 == 0 and G.jokers.config.card_limit > 1 then
                            G.jokers.config.card_limit = G.jokers.config.card_limit - 1
                        end
                    end
                    
                end
            end
        end
        if G.GAME.modifiers.fiscality then
            if context.buying_card then
                G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling + (0.1 * (context.card.cost or 0))
            end
        end
    end
end

-- secrecy
local cardarea_emplaceref = CardArea.emplace
function CardArea.emplace(self, card, location, stay_flipped)
    cardarea_emplaceref(self, card, location, stay_flipped)
    if G.GAME.modifiers.secrecy and (card.config.center.set == "Joker" or card.config.center.set == "Consumables" or card.config.center.set == "Default") then
        card.facing = 'back' 
        card.sprite_facing = 'back'
        card.pinch.x = false
    end
end

local function galdur_page()
    Galdur.include_deck_preview()
    Galdur.include_chip_tower()

    local page_options = {
        "Oaths"
    }
    G.E_MANAGER:add_event(Event({func = (function()
        G.FUNCS.oaths_change_page{cycle_config = {current_option = 1}}
    return true end)}))

    return 
    {n=G.UIT.ROOT, config={align = "tm", minh = 3.8, colour = G.C.CLEAR, padding=0.1}, nodes={
        {n=G.UIT.C, config = {padding = 0.15}, nodes ={   
            {n=G.UIT.R, config={align = "cm", minh = 0.45+G.CARD_H+G.CARD_H, minw = 10.7, colour = G.C.BLACK, padding = 0.15, r = 0.1, emboss = 0.05}, nodes = {
                    { n = G.UIT.O, config = { id = 'oaths_list', object = Moveable() }},
            }},
            create_option_cycle({options = page_options, w = 4.5, cycle_shoulders = true, opt_callback = 'oaths_change_page', current_option = 1, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
        }},
        Galdur.display_chip_tower(),
        Galdur.display_deck_preview()
    }}
end

if Galdur then
    Galdur.add_new_page({
        definition = galdur_page,
        name = 'gald_oaths',
        -- pre_start = pre_game_start,
        -- post_start = post_game_start
    })
end
