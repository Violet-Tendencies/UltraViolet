-- Atlas
SMODS.Atlas({
    key = "MagicsDecks", 
    path = "CustomJokers.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
})

-- Decks
SMODS.Back {
    key = "necromancy",
    loc_txt = {
        name = "Necromancy Deck",
        text = {
            "Immutable 1/4 chance to Ressurect",
            "a previously destroyed card"
        }
    },
    pos = { x = 0, y = 0 },
     config = {
        extra = {
            destroyed_cards = {}
        }
    },
    calculate = function(self, back, context)
        if context.press_play then
            back.in_scoring = true
        end
        if context.evaluate_poker_hand and back.in_scoring and not back.necromanced then
            local CArd
            if self.config.extra.destroyed_cards ~= nil then
                local cloneCArd = pseudorandom_element(self.config.extra.destroyed_cards, pseudorandom("ressurected card"))
                CArd = SMODS.create_card({set = "Playing Card", key = cloneCArd})
            end
            if CArd then
                back.necromanced = true
                CArd.necromanced = true
                -- G.hand:remove_card(CArd)
                G.play:emplace(CArd)
                table.insert(context.scoring_hand, CArd)
            end
        end
        if context.modify_scoring_hand and context.in_scoring and context.other_card.necromanced then
            context.other_card.necromanced = nil
            return { add_to_hand = true }
        end
        if context.after then
            back.in_scoring = nil
            back.necromanced = nil
        end
        if context.destroy_card then
            table.insert(self.config.extra.destroyed_cards, context.destroy_card.config.center_key)
        end
    end
}