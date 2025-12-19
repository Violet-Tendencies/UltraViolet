SMODS.current_mod.calculate = function(self, context)
    if context.end_of_round and SMODS.saved and context.main_eval then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                SMODS.add_card({
                    set = 'Joker',
                    key = 'j_uv_yomi',
                })
                return true
            end
        }))
    end
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
                if context.joker_main then
                    for k, v in ipairs(G.play.cards) do
                        context.destroying_card.assiduityCounter = (context.destroying_card.assiduityCounter or 0) + 1
                        if context.destroying_card.assiduityCounter >= 2 then
                            return {
                                remove = true,
                                card = context.destroying_card
                            }
                        end
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