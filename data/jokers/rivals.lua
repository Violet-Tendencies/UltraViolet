-- Atlas

SMODS.Atlas({
    key = "RivalsJokers", 
    path = "CustomJokers.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
})

-- Jokers

SMODS.Joker{
    key = "loki",
    loc_txt = {
        name = "Loki",
        text = {
            'Scores {C:blue}+30{} chips',
            '{C:inactive}The god of cunning is always more than he seems{}',
            '{C:inactive}(Marvel Rivals){}'
        }
    },
    atlas = "RivalsJokers",
    rarity = 2,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
            Clones = 0,
            chips = 30,
            Cloned = false,
            CloneMade = false
        }
    },
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.CloneMade = false
        end
        if context.cardarea == G.jokers and context.joker_main then
            return {
                chips = card.ability.extra.chips,
            }
        end
        if context.end_of_round and context.individual and not context.blueprint then
            if not card.ability.extra.Cloned and not card.ability.extra.CloneMade then
                if (card.ability.extra.Clones or 0) < 2 then
                    card.ability.extra.CloneMade = true
                    card.ability.extra.Clones = card.ability.extra.Clones + 1
                    local clone = SMODS.create_card({set = "Joker", area = G.jokers, key = "j_uv_loki", edition = "e_negative"})
                    clone.ability.extra.Cloned = true
                    clone:add_to_deck()
                    G.jokers:emplace(clone)
                    SMODS.calculate_effect({
                        message = "I have many faces...",
                        colour = G.C.GREEN
                    }, clone)
                else
                    if G.jokers.cards[1].config.center.key ~= "j_uv_loki" then
                        card.ability.extra.CloneMade = true
                        local clone = SMODS.create_card({set = "Joker", area = G.jokers, key = G.jokers.cards[1].config.center.key})
                        clone:add_to_deck()
                        G.jokers:emplace(clone)
                        -- remove Loki
                        SMODS.destroy_cards(card)
                        SMODS.calculate_effect({
                            message = "Your powers are MINE!",
                            colour = G.C.GREEN
                        }, clone)
                    end
                end
            end
        end
    end
}

SMODS.Joker{
    key = "winter_soldier",
    loc_txt = {
        name = "Winter Soldier",
        text = {
            'Scores {C:red}+#1#{} mult #2# times',
            '{C:inactive}Fully Armed.{}',
            '{C:inactive}(Marvel Rivals){}'
        }
    },
    atlas = "RivalsJokers",
    rarity = 2,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
            mult = 3,
            chips = 0,
            retriggers = 2,
            retUp = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult, card.ability.extra.retriggers} }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            juice_card(card)
            G.GAME.blind.chips = G.GAME.blind.chips - (G.GAME.blind.chips * 0.15)
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            card.ability.extra.retUp = false
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.retrigger_joker_check then
            return {
                repetitions = card.ability.extra.retriggers,
                card = card
            }
        end
        if context.end_of_round then
            if not card.ability.extra.retUp then
                card.ability.extra.retriggers = card.ability.extra.retriggers + 1
                card.ability.extra.retUp = true
            end
        end
    end
}

SMODS.Joker{
    key = "mantis",
    loc_txt = {
        name = "Mantis",
        text = {
            'Scores +#2# chips per each other joker held',
            'This joker gains +#1# mult every hand',
            '{C:inactive}(Currently #1#){}',
            '{C:inactive}Life always wins!{}',
            '{C:inactive}(Marvel Rivals){}'
        }
    },
    atlas = "RivalsJokers",
    rarity = 2,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
            mult = 2,
            chips = 1,
            multUp = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.multUp = false
        end
        if context.post_trigger then
            card.ability.extra.chips = card.ability.extra.chips + (#G.jokers.cards - 1)
            juice_card(card)
        end
        if context.joker_main then
            if not card.ability.extra.multUp then
                juice_card(card)
                card.ability.extra.mult = card.ability.extra.mult + 2
                card.ability.extra.multUp = true
            end
            return {
                mult = card.ability.extra.mult,
                chips = card.ability.extra.chips * (#G.jokers.cards - 1)
            }
        end
    end
}

SMODS.Joker{
    key = "hela",
    loc_txt = {
        name = "Hela",
        text = {
            'Scores +#1# chips each hand',
            'On the final hand, score +#2#',
            'per each hand played this blind',
            '{C:inactive}Hel\'s blades are sharp indeed.{}',
            '{C:inactive}(Marvel Rivals){}'
        }
    },
    atlas = "RivalsJokers",
    rarity = 2,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
            finalChips = 30,
            normalChips = 10,
            helChips = 250
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if context.blind.boss and (G.GAME.current_round.hands_left + 1) % 2 == 0 then
                return {
                    chips = card.ability.extra.helChips,
                    message = "A feast for my crows!",
                    card = card
                }
            elseif G.GAME.current_round.hands_left <= 0 then
                return {
                    chips = card.ability.extra.finalChips * G.GAME.current_round.hands_played
                }
            else
                return {
                    chips = card.ability.extra.normalChips
                }
            end
        end
    end
}
