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
            'Winning a blind in one hand grants this joker x4 mult',
            'Loses x0.25 mult for every card scored after the first hand.',
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
        for k, v in pairs(G.P_BLINDS) do
            v.mult = v.mult*2 
        end
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
    key = "greed",
    loc_txt = {
        name = "Greed",
        text = {
            '+1 selection limit in booster packs',
            'Gain $3 on round end for each joker held.'
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
        for k, v in pairs(G.P_BLINDS) do
            v.mult = v.mult*2 
        end
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
            'If you use your final hand, gain +1 hand (once per round)',
            'Gains +20 chips and +20 mult each time this ability is activated',
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
        for k, v in pairs(G.P_BLINDS) do
            v.mult = v.mult*2 
        end
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

--[[ 
Envy - If this joker has less chips than the blind’s score, it gains 1/8th the blind’s score as chips.
Lust - Gains 1.25X Mult if two consecutive Face cards are scored.
Gluttony - This joker gains x0.1 mult for each consumable held; +1 consumable slot.
Sloth - Cards that are in hand during scoring gain their chips as perma mult 
]]

--[[ SMODS.Joker{
    key = "pride",
    loc_txt = {
        name = "Pride",
        text = {
            'Winning a blind in one hand grants this joker x4 mult',
            'Loses x0.25 mult for every card scored after the first hand.',
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
            rounds = 0,
            xmult = 1,
            xmultIncrement = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xmult} }
    end,
    add_to_deck = function(self, card, from_debuff)
        for k, v in pairs(G.P_BLINDS) do
            v.mult = v.mult*2 
        end
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
    key = "pride",
    loc_txt = {
        name = "Pride",
        text = {
            'Winning a blind in one hand grants this joker x4 mult',
            'Loses x0.25 mult for every card scored after the first hand.',
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
            rounds = 0,
            xmult = 1,
            xmultIncrement = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xmult} }
    end,
    add_to_deck = function(self, card, from_debuff)
        for k, v in pairs(G.P_BLINDS) do
            v.mult = v.mult*2 
        end
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
    key = "pride",
    loc_txt = {
        name = "Pride",
        text = {
            'Winning a blind in one hand grants this joker x4 mult',
            'Loses x0.25 mult for every card scored after the first hand.',
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
            rounds = 0,
            xmult = 1,
            xmultIncrement = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xmult} }
    end,
    add_to_deck = function(self, card, from_debuff)
        for k, v in pairs(G.P_BLINDS) do
            v.mult = v.mult*2 
        end
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
    key = "pride",
    loc_txt = {
        name = "Pride",
        text = {
            'Winning a blind in one hand grants this joker x4 mult',
            'Loses x0.25 mult for every card scored after the first hand.',
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
            rounds = 0,
            xmult = 1,
            xmultIncrement = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xmult} }
    end,
    add_to_deck = function(self, card, from_debuff)
        for k, v in pairs(G.P_BLINDS) do
            v.mult = v.mult*2 
        end
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

} ]]