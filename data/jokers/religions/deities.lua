-- Atlas

SMODS.Atlas({
    key = "DeityJokers", 
    path = "CustomJokers.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
})

-- Hooks

-- Limits Izanagi/Izanami's swap
local can_sell_izana = Card.can_sell_card 
function Card:can_sell_card(silent) -- gets called instead of the original function
    if self.config.center.key == "j_uv_iza_no_mikoto" then -- }|
        if self.ability.extra.swapped == false then        --  |
            return true                                    --  |
        else                                               --  | -- all of this comes before the original function
            return false                                   --  |
        end                                                --  |
    else                                                   -- }|
        return can_sell_izana(self, silent) -- original function
    end                                                    -- comes after the original function
end

-- Makes it so that the sell button swaps Izanagi/Izanami
local selling_izina = Card.sell_card
function Card:sell_card(silent)
    if self.config.center.key == "j_uv_iza_no_mikoto" then
        G.CONTROLLER.locks.selling_card = true
        stop_use()
        local area = self.area
        G.CONTROLLER:save_cardarea_focus(area == G.jokers and 'jokers' or 'consumeables')
        
        self:calculate_joker{selling_self = true}

        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function()
            self:flip()
            self:juice_up(0.3, 0.4)
            self.config.colour = G.C.UI.BACKGROUND_INACTIVE
            self.config.button = nil
            self:flip()
            return true
        end}))
        delay(0.2)
        G.E_MANAGER:add_event(Event({trigger = 'immediate',func = function()
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3, blocking = false,
            func = function()
                G.E_MANAGER:add_event(Event({trigger = 'immediate',
                func = function()
                    G.E_MANAGER:add_event(Event({trigger = 'immediate',
                    func = function()
                        G.CONTROLLER.locks.selling_card = nil
                        G.CONTROLLER:recall_cardarea_focus(area == G.jokers and 'jokers' or 'consumeables')
                    return true
                    end}))
                return true
                end}))
            return true
            end}))
            return true
        end}))
    else
        return selling_izina(self, silent)
    end
end

-- Jokers

SMODS.Joker{
    key = "okuninushi",
    loc_txt = {
        name = "Ōkuninushi",
        text = {
            'Scores x#1# Mult.',
            'Retriggers once for every',
            'Joker and Consumable held.'
        }
    },
    atlas = 'DeityJokers',
    rarity = 4,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
            xmult = 1.5
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xmult} }
    end,
    set_card_type_badge = function(self, card, badges)
 		badges[1] = create_badge("Deity", HEX("e34234"), G.C.JOKER_GREY, 1.2 )
 	end,
    add_to_deck = function(self, card, from_debuff)
        SMODS.Stickers.eternal:apply(card, true)
    end,
    calculate = function(self, card, context)
        if context.retrigger_joker_check and not context.retrigger_joker and context.other_card == card then
            return {
                repetitions = ((#G.jokers.cards + #G.consumeables.cards) or 0)
            }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function(self, args)
        return false
    end
}

SMODS.Joker{
    key = "tsukuyomi_no_mikoto",
    loc_txt = {
        name = "Tsukuyomi-no-Mikoto",
        text = {
            'Upon selecting a blind, grant',
            'a random editionless joker held',
            'a random edition (excluding self).',
            'Retrigger every joker with an edition once.'
        }
    },
    atlas = 'DeityJokers',
    rarity = 4,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    set_card_type_badge = function(self, card, badges)
 		badges[1] = create_badge("Deity", HEX("e34234"), G.C.JOKER_GREY, 1.2 )
 	end,
    add_to_deck = function(self, card, from_debuff)
        SMODS.Stickers.eternal:apply(card, true)
    end,
    calculate = function(self, card, context)
        
        if context.setting_blind then
            local editionless_jokers_held = {}
            for k, v in ipairs(G.jokers.cards) do
                if not v.edition and G.jokers.cards[k] ~= card then -- card.edition.[key] exists btw!!
                    table.insert(editionless_jokers_held, v)
                end 
            end
            if editionless_jokers_held and editionless_jokers_held[1] ~= nil then
                local CArd = pseudorandom_element(editionless_jokers_held, pseudoseed("uv_editioning_editionless_jokers_held"))
                CArd:set_edition(poll_edition(pseudoseed("poll_edition_random_seed_1"), 1, false, true))
                
            end
        end
        if context.retrigger_joker_check and not context.retrigger_joker and context.other_card.edition then
            return {
                repetitions = 1
            }
        end
    end,
    in_pool = function(self, args)
        return false
    end
}

SMODS.Joker{
    key = "yomi",
    loc_txt = {
        name = "Yomi",
        text = {
            'Creates a random card',
            'when a card is destroyed',
            'and moves it to the discard.',
            'Discarded cards are destroyed.'
        }
    },
    atlas = 'DeityJokers',
    rarity = 3,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    set_card_type_badge = function(self, card, badges)
 		badges[1] = create_badge("Location", HEX("e34234"), G.C.JOKER_GREY, 1.2 )
 	end,
    add_to_deck = function(self, card, from_debuff)
        SMODS.Stickers.eternal:apply(card, true)
    end,
    calculate = function(self, card, context)
        if context.discard then
            return {remove = true}
        end
        if context.remove_playing_cards then
            for i = 1, #context.removed do
                G.E_MANAGER:add_event(Event({
                    trigger = "immediate", 
                    func = function() 
                        local uv_yomi_edition = nil
                        local uv_yomi_seal = nil
                        if pseudorandom("uv_yomi_edition_grab", 1, 50) == 25 then
                            uv_yomi_edition = poll_edition(pseudoseed("poll_edition_random_seed_2"), 1, true, false)
                        end
                        if pseudorandom("uv_yomi_seal_grab", 1, 10) == 5 then
                            uv_yomi_seal = SMODS.poll_seal({type_key = "yomi_poll_seaL_random_seed",  guaranteed = true})
                        end
                        SMODS.add_card({
                            set = "Playing Card",
                            seal = uv_yomi_seal,
                            edition = uv_yomi_edition,
                            area = G.discard, 
                            rank = pseudorandom_element(SMODS.Ranks, pseudoseed('uv_yomi_rank')).key,
                            suit = pseudorandom_element(SMODS.Suits, pseudoseed('uv_yomi_suit')).key,
                            enhanced_poll = 0.2
                        })
                        return true
                    end
                }))
            end
        end
    end,
    in_pool = function(self, args)
        return false
    end
}

SMODS.Joker{
    key = "iza_no_mikoto",
    atlas = 'DeityJokers',
    rarity = 4,
    cost = -2000,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
            names = {"Izanagi", "Izanami"},
            mulchi = {"mult", "chips"},
            credes = {"created", "destroyed"},
            bousol = {"bought", "sold"},
            invnames = {"Izanami", "Izanagi"},
            type = 1,
            increase = 0.05,
            swapped = false,
            xmult = 1,
            xchips = 1

        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {
            card.ability.extra.names[card.ability.extra.type],
            card.ability.extra.mulchi[card.ability.extra.type],
            card.ability.extra.credes[card.ability.extra.type],
            card.ability.extra.bousol[card.ability.extra.type],
            card.ability.extra.invnames[card.ability.extra.type],
            card.ability.extra.increase,
            card.ability.extra.xmult,
            card.ability.extra.xchips
        }}
    end,
    set_card_type_badge = function(self, card, badges)
 		badges[1] = create_badge("Deity", HEX("e34234"), G.C.JOKER_GREY, 1.2 )
 	end,
    add_to_deck = function(self, card, from_debuff)
        card.sell_cost = 0
        card.sell_cost_label = 0
        SMODS.Stickers.eternal:apply(card, true)
    end,
    calculate = function(self, card, context)
        card.sell_cost = 0
        card.sell_cost_label = 0
        if context.setting_blind then
            SMODS.add_card({set = "Joker"})
        end
        if context.selling_self == true then
            card.ability.extra.swapped = true
            if card.ability.extra.type == 1 then
                card.ability.extra.type = 2
            elseif card.ability.extra.type == 2 then
                card.ability.extra.type = 1
                if not SMODS.find_card("ame_no_nuboko", true) then
                    SMODS.add_card({set = "Joker", key = "j_uv_ame_no_nuboko"})
                end
            end
        end
        if card.ability.extra.type == 1 then
            if context.buying_card or context.card_added then
                -- [if that one consumable is held then add the same bonus to chips]
                card.ability.extra.xmult = card.ability.extra.xmult + (card.ability.extra.increase * (context.card.sell_cost or 0))
            end
        elseif card.ability.extra.type == 2 then
            if context.selling_card or context.joker_type_destroyed then
                -- [if that one consumable is held then add the same bonus to mult]
                card.ability.extra.xchips = card.ability.extra.xchips + (card.ability.extra.increase * (context.card.sell_cost or 0))
            end
        end
        if context.joker_main then
            local xmult = nil
            local xchips = nil
            if card.ability.extra.xmult > 1 then xmult = card.ability.extra.xmult end
            if card.ability.extra.xchips > 1 then xchips = card.ability.extra.xchips end
            return {
                xmult = xmult,
                xchips = xchips
            }
        end
        if context.end_of_round and context.main_eval then
            card.ability.extra.swapped = false
        end

    end,
    in_pool = function(self, args)
        return false
    end
}

SMODS.Joker{
    key = "ame_no_nuboko",
    loc_txt = {
        name = "Ame-no-Nuboko",
        text = {
            'Before scoring, debuffed cards in hand',
            'are randomly enhanced and gain +20 chips.',
        }
    },
    atlas = 'DeityJokers',
    rarity = 3,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    set_card_type_badge = function(self, card, badges)
 		badges[1] = create_badge("Weapon", HEX("e34234"), G.C.JOKER_GREY, 1.2 )
 	end,
    add_to_deck = function(self, card, from_debuff)
        SMODS.Stickers.eternal:apply(card, true)
    end,
    calculate = function(self, card, context)
        if context.before then
            for i, j in ipairs(G.hand.cards) do
                if j.debuff or j.debuffed_by_blind then
                    j:flip()
                    j:set_ability(SMODS.poll_enhancement({guaranteed = true, type_key = "nuboko_enhancement"}))
                    j.perma_bonus = (j.perma_bonus or 0) + 20
                    j:flip()
                end
            end
        end
    end,
    in_pool = function(self, args)
        return false
    end
}

SMODS.Joker{
    key = "toyotama_hime",
    loc_txt = {
        name = "Toyotama-hime",
        text = {
            'Prevents death. Upon preventing death',
            'self-destructs and creates 2 random Jokers' --,
            -- 'jokers and a random Shinto Record.'
        }
    },
    atlas = 'DeityJokers',
    rarity = 4,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    set_card_type_badge = function(self, card, badges)
 		badges[1] = create_badge("Deity", HEX("e34234"), G.C.JOKER_GREY, 1.2 )
 	end,
    add_to_deck = function(self, card, from_debuff)
        SMODS.Stickers.eternal:apply(card, true)
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over and context.main_eval then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    play_sound('tarot1')
                    card:juice_up(0.4, 0.45)
                    SMODS.add_card({set = "Joker"})
                    SMODS.add_card({set = "Joker"})
                    card:start_dissolve()
                    return true
                end
            }))
            return {
                message = "Divine Intervention!",
                saved = 'saved_by_toyotama',
                colour = G.C.GOLD
            }
        end
    end,
    in_pool = function(self, args)
        return false
    end
}