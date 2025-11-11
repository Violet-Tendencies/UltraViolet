-- Atlas

SMODS.Atlas({
    key = "StupendiumConsumables", 
    path = "CustomJokers.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
})

SMODS.Consumable {
    key = 'table',
    set = 'Tarot',
    loc_txt = {
        name = "Poker Table",
        text = {
            "Joker slots are set to 9.",
            "Create 1 joker and up to 6 random Jokers",
            "{C:inactive}(all are perishable, must have room){}"
        }
    },
    pos = { x = 1, y = 0 },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set = "Other", key = "inspired_by_stupes"}
    end,
    use = function(self, card, area, copier) -- make jimbo spawn as the 4th card instead of the 1st
        G.jokers.config.card_limit = 9
        G.E_MANAGER:add_event(Event({
            func = function() 
                for i = 1, 7 do
                    if #G.jokers.cards < G.jokers.config.card_limit then
                        if i == 4 then
                            local CArd = SMODS.add_card({key = "j_joker", area = G.jokers})
                            CArd:add_sticker("perishable", true)
                        else
                            local CArd = SMODS.add_card({set = 'Joker', area = G.jokers})
                            CArd:add_sticker("perishable", true)
                        end
                    end
                end
                return true 
            end
        }))
    end,
    can_use = function(self, card)
        return true
    end
}