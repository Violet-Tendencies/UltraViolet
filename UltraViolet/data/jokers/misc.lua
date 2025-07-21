-- Atlas

SMODS.Atlas({
    key = "MiscJokers", 
    path = "CustomJokers.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
})

-- Rarity

SMODS.Rarity({
    key = "emi",
    loc_txt = {
        name = "Emi"
    },
    badge_colour = HEX("521094")
})

-- Joker Retriggers

SMODS.current_mod.optional_features = function()
    return {
        retrigger_joker = true,
    }
end

-- Jokers

SMODS.Joker{
    key = "emi",
    loc_txt = {
        name = "Emi",
        text = {
            "Manipulates blind requirements weirdly.",
            "Flips base chips and mult before scoring.",
            "Perpetually Tired.",
            " ",
            "Dreadful: +#1# and +#2#",
            "Euphoric: +#3#",
            "Angered: x#4#",
            "Held for #5# antes",
            " ",
            "Hexed (Vengance)",
            "Your atypical self-insert",
            "{C:inactive}(All mods are required to have one){}"
        }
    },
    atlas = 'MiscJokers',
    rarity = "uv_emi",
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    config = {
        extra = {
            xchips = 5,
            xmult = 1,
            happyChips = 1,
            dreadChips = 0,
            mult = 0,
            ante = 0,
            blindWon = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.dreadChips, card.ability.extra.mult, card.ability.extra.happyChips, card.ability.extra.xmult, card.ability.extra.ante} }
    end,
    add_to_deck = function(self, card, from_debuff)
        for k, v in pairs(G.P_BLINDS) do
             G.GAME.starting_params.ante_scaling = (G.GAME.starting_params.ante_scaling or 1)+3.1415926535897932384626433832795028841971693993751058209
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        for k, v in pairs(G.P_BLINDS) do
             G.GAME.starting_params.ante_scaling = (G.GAME.starting_params.ante_scaling or 1)-3.1415926535897932384626433832795028841971693993751058209
        end
        SMODS.add_card({set = "Jokers", area = G.jokers, rarity = "uv_sin", no_edition = true})
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.blindWon = false
        end
        if context.playing_card_added then
            card.ability.extra.dreadChips = card.ability.extra.dreadChips + 20
            card.ability.extra.mult = card.ability.extra.mult + 20
        end
        if context.remove_playing_cards then
            if card.ability.extra.dreadChips/2 >= 0 then
                card.ability.extra.dreadChips = card.ability.extra.dreadChips/2
            end
            if card.ability.extra.mult/2 >= 0 then
                card.ability.extra.mult = card.ability.extra.mult/2
            end
        end
        if context.modify_hand then
            local handChips = hand_chips
            local handMult = mult
            mult = handChips
            hand_chips = handMult
            juice_card(card)
        end
        if context.joker_main then
            if card.ability.extra.xmult > 1 then
                card.ability.extra.xmult = card.ability.extra.xmult - 0.1
            end
            local xmult = card.ability.extra.xmult
            local chips = card.ability.extra.happyChips + card.ability.extra.dreadChips
            local mult = card.ability.extra.mult
            if xmult == 0 then xmult = nil end
            if mult == 0 then mult = nil end
            if chips == 0 then chips = nil end
            return {
                xmult = xmult,
                xchips = card.ability.extra.xchips,
                chips = chips,
                mult = mult
            }
        end
        if context.retrigger_joker_check then
            card.ability.extra.happyChips = (card.ability.extra.happyChips or 0) * 3
            return {
                repetitions = 1,
                card = card
            }
        end
        if context.end_of_round and not card.ability.extra.blindWon then
            card.ability.extra.blindWon = true
            card.ability.extra.xmult = card.ability.extra.xmult + 1
            if context.blind.boss then
                card.ability.extra.ante = card.ability.extra.ante + 1
                if card.ability.extra.ante >= 4 then
                    SMODS.destroy_cards(card)
                end
            end
        end
    end,
    in_pool = function(self, args)
        local number = pseudorandom("good luck", 1, 4)
        if number == 3 then
            return true
        else
            return false
        end
    end
}
