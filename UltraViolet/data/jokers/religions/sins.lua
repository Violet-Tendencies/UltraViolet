-- Atlas

SMODS.Atlas({
    key = "SinJokers", 
    path = "CustomJokers.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
})

SMODS.Rarity({
    key = "sin",
    loc_txt = {
        name = "Sin"
    },
    badge_colour = HEX("800000")
})

-- Jokers

SMODS.Joker{
    key = "pride",
    loc_txt = {
        name = "Pride",
        text = {
            'Winning a blind in one hand',
            'grants this joker x4 mult',
            'Loses x0.25 mult for every card',
            'scored after the first hand.',
            '(Can\'t go lower than x1, currently x#1#)'
        }
    },
    atlas = 'SinJokers',
    rarity = "uv_sin",
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
            xmult = 1,
            xmultIncrement = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xmult} }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.starting_params.ante_scaling = (G.GAME.starting_params.ante_scaling or 1)*2
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.xmultIncrement = false
        end
        if context.individual and context.cardarea == G.play then
            if G.GAME.current_round.hands_played > 0 and card.ability.extra.xmult > 1 then
                juice_card(card)
                card.ability.extra.xmult = card.ability.extra.xmult - 0.25
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.end_of_round then
            if G.GAME.current_round.hands_played <= 1 then
                if not card.ability.extra.xmultIncrement then
                    juice_card(card)
                    card.ability.extra.xmult = card.ability.extra.xmult + 4
                    card.ability.extra.xmultIncrement = true
                end
            end
        end
    end,
    in_pool = function(self, args)
        return false
    end

}



SMODS.Joker{
    key = "greed",
    loc_txt = {
        name = "Greed",
        text = {
            '+1 selection limit',
            'in booster packs',
            'Gain $3 on round end',
            'for each joker held.'
        }
    },
    atlas = 'SinJokers',
    rarity = "uv_sin",
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
            dollars = 3
        }
    },
    add_to_deck = function(self, card, from_debuff)
        G.GAME.starting_params.ante_scaling = (G.GAME.starting_params.ante_scaling or 1)*2
    end,
    calculate = function(self, card, context)
        if context.open_booster then
            G.GAME.pack_choices = G.GAME.pack_choices + 1
        end
        if context.end_of_round then
            for k, v in ipairs(G.jokers.cards) do
                return {
                    dollars = card.ability.extra.dollars * #G.jokers.cards
                }
            end
        end
    end,
    in_pool = function(self, args)
        return false
    end

}

SMODS.Joker{
    key = "wrath",
    loc_txt = {
        name = "Wrath",
        text = {
            'If you use your final hand',
            'gain +1 hand (once per round)',
            'Gains +20 chips and +20 mult each',
            'time this ability is activated',
            '(Currently +#2# and +#1#)'
        }
    },
    atlas = 'SinJokers',
    rarity = "uv_sin",
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
            mult = 0,
            chips = 0,
            helpingHand = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult, card.ability.extra.chips} }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.starting_params.ante_scaling = (G.GAME.starting_params.ante_scaling or 1)*2
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.helpingHand = false
        end
        if context.joker_main then
            if card.ability.extra.mult > 0 and card.ability.extra.chips > 0 then
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult
                }
            end
            if G.GAME.current_round.hands_left <= 0 and not card.ability.extra.helpingHand then
                G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 1
                card.ability.extra.chips = card.ability.extra.chips + 20
                card.ability.extra.mult = card.ability.extra.mult + 20
                card.ability.extra.helpingHand = true
            end
        end
        if context.end_of_round then
            if G.GAME.current_round.hands_played <= 0 then
                if not card.ability.extra.xmultIncrement then
                    juice_card(card)
                    card.ability.extra.xmult = card.ability.extra.xmult + 4
                    card.ability.extra.xmultIncrement = true
                end
            end
        end
    end,
    in_pool = function(self, args)
        return false
    end

}

SMODS.Joker{
    key = "envy",
    loc_txt = {
        name = "Envy",
        text = {
            'If this joker has less',
            'chips than the blind’s score',
            'it gains 1/8th the',
            'blind’s score as chips.',
            '(currently +#1#)'
        }
    },
    atlas = 'SinJokers',
    rarity = "uv_sin",
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
            chips = 0,
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.chips} }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.starting_params.ante_scaling = (G.GAME.starting_params.ante_scaling or 1)*2
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            if card.ability.extra.chips < G.GAME.blind.chips then
                card.ability.extra.chips = card.ability.extra.chips + (G.GAME.blind.chips/8)
            end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,
    in_pool = function(self, args)
        return false
    end

}

SMODS.Joker{
    key = "lust",
    loc_txt = {
        name = "Lust",
        text = {
            'Gains x1 Mult if two consecutive',
            'Face cards are scored.',
            '(currently x#1#)'
        }
    },
    atlas = 'SinJokers',
    rarity = "uv_sin",
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
            faceCards = 0,
            xmult = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xmult} }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.starting_params.ante_scaling = (G.GAME.starting_params.ante_scaling or 1)*2
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_face() then
                card.ability.extra.faceCards = card.ability.extra.faceCards + 1
                if card.ability.extra.faceCards >= 2 then
                    juice_card(card)
                    card.ability.extra.xmult = card.ability.extra.xmult + 1
                    card.ability.extra.faceCards = 0
                end
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.after then
            card.ability.extra.faceCards = 0
        end
    end,
    in_pool = function(self, args)
        return false
    end

}

SMODS.Joker{
    key = "gluttony",
    loc_txt = {
        name = "Gluttony",
        text = {
            'This joker gains x0.1 mult',
            'for each consumable held',
            '(currently: x#1#)',
            '+1 consumable slot'
        }
    },
    atlas = 'SinJokers',
    rarity = "uv_sin",
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
            xchips = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xchips} }
    end,
    add_to_deck = function(self, card, from_debuff)
        for k, v in pairs(G.P_BLINDS) do
            v.mult = v.mult*2 
        end
        G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.xchips = card.ability.extra.xchips + (0.1 * #G.consumeables.cards)
        end
        if context.joker_main then
            return {
                xchips = card.ability.extra.xchips
            }
        end
    end,
    in_pool = function(self, args)
        return false
    end

}

SMODS.Joker{
    key = "sloth",
    loc_txt = {
        name = "Sloth",
        text = {
            'Cards that are in hand during scoring',
            'gain triple their chips as perma mult '
        }
    },
    atlas = 'SinJokers',
    rarity = "uv_sin",
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
            rounds = 0,
            xmult = 1,
            xmultIncrement = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xmult} }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.starting_params.ante_scaling = (G.GAME.starting_params.ante_scaling or 1)*2
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            for k, v in ipairs(G.hand.cards) do
                v.ability.perma_mult = v.ability.perma_mult + (v.base.nominal * 3)
                juice_card(v)
            end
        end
    end,
    in_pool = function(self, args)
        return false
    end
    

}
