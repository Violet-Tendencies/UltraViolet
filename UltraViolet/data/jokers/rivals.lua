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
    discovered = true,
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

--[[ SMODS.Joker{
    key = "winter_soldier",
    loc_txt = {
        name = "Winter Soldier",
        text = {
            'Scores {C:red}+3{} mult 3 times',
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
    discovered = true,
    pos = {x=0, y=0},
    config = {
        extra = {
            mult = 3
        }
    },
    calculate = function(self, card, context)
        
    end
} ]]
