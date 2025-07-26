SMODS.Stake {
    name = "Purple Stake...?", -- FUCK UI!!
    key = "insanity",
    applied_stakes = { "gold" },
    prefix_config = { applied_stakes = { mod = false } },
    above_stake = 'gold',
    pos = { x = 0, y = 1 },
    sticker_pos = { x = 1, y = 1 },
    modifiers = function()
        local a = 0
        local b = 60
        G.GAME.uv_insanity_timer_threshold = 60
        local delta = 5
        local event
        event = Event {
            blockable = false,
            blocking = false,
            pause_force = true,
            no_delete = false,
            trigger = "after",
            delay = 5,
            timer = "TOTAL",
            func = function()
                a = a + 1
                print(a)
                if a >= b then                
                    local choice = pseudorandom("uv_timer_choice", 1, 42)
                    if choice == 1 then 
                        ease_ante(pseudorandom("uv_insanity_ante_loss", -1, 1))
                    elseif choice == 2 then
                        ease_dollars(-delta)
                    elseif choice == 3 then
                        ease_discard(-delta)
                    elseif choice == 42 then
                        G.hand.config.card_limit = G.hand.config.card_limit - delta
                    elseif choice == 4 then
                        G.GAME.base_reroll_cost = G.GAME.base_reroll_cost + delta
                    elseif choice == 5 then
                        G.GAME.shop.joker_max = G.GAME.shop.joker_max - delta
                    elseif choice == 6 then
                        G.jokers.config.card_limit = G.jokers.config.card_limit - delta
                    elseif choice == 7 then
                        G.consumeables.config.card_limit = G.consumeables.config.card_limit - delta
                    elseif choice == 8 then
                        G.GAME.interest_cap = G.GAME.interest_cap - delta
                    elseif choice == 9 then
                        G.GAME.discount_percent = (G.GAME.discount_percent or 0) - delta
                    elseif choice == 10 then
                        G.GAME.pack_choices = G.GAME.pack_choices - 1
                    elseif choice == 11 then
                        G.GAME.joker_rate = G.GAME.joker_rate - delta
                    elseif choice == 12 then
                        G.GAME.inflation = 1
                    elseif choice == 13 then
                        G.GAME.disabled_suits = {pseudorandom_element(SMODS.Suits, "uv_disabling_suit")}
                    elseif choice == 14 then
                        G.GAME.disabled_ranks = {pseudorandom_element(SMODS.Ranks, "uv_disabling_rank")}
                    elseif choice == 15 then
                        G.GAME.playing_card_rate = G.GAME.playing_card_rate - delta
                    elseif choice == 16 then
                        G.GAME.tarot_rate = G.GAME.tarot_rate - delta
                    elseif choice == 17 then
                        G.GAME.planet_rate = G.GAME.planet_rate - delta
                    elseif choice == 18 then
                        G.GAME.rental_rate = G.GAME.rental_rate + delta
                    elseif choice == 19 then
                        G.GAME.edition_rate = G.GAME.edition_rate - delta
                    elseif choice == 20 then
                        G.GAME.spectral_rate = G.GAME.spectral_rate - delta
                    elseif choice == 21 then
                        G.GAME.bankrupt_at = G.GAME.bankrupt_at + delta
                    elseif choice == 22 then
                        G.GAME.pack_size = G.GAME.pack_size - 1
                    elseif choice == 23 then
                        G.GAME.probabilities.normal = G.GAME.probabilities.normal - 1
                    elseif choice == 24 then
                        G.GAME.modifiers.enable_eternals_in_shop = true
                    elseif choice == 25 then
                        G.GAME.modifiers.enable_rentals_in_shop = true
                    elseif choice == 26 then
                        G.GAME.modifiers.enable_perishables_in_shop = true
                    elseif choice == 27 then
                        G.GAME.modifiers.no_extra_hand_money = true
                    elseif choice == 28 then
                        G.GAME.modifiers.debuff_played_cards = true
                    elseif choice == 29 then
                        G.GAME.modifiers.all_eternal = true
                    elseif choice == 30 then
                        G.GAME.modifiers.minus_hand_size_per_X_dollar = (G.GAME.modifiers.minus_hand_size_per_X_dollar or 0) + delta
                    elseif choice == 31 then
                        G.GAME.modifiers.money_per_discard = (G.GAME.modifiers.money_per_discard or 0) - 1
                    elseif choice == 32 then
                        G.GAME.modifiers.money_per_hand = (G.GAME.modifiers.money_per_hand or 0) - 1
                    elseif choice == 33 then
                        local choice2 = pseudorandom("uv_timer_choice2", 1, 3)
                        if choice2 == 1 then
                            G.GAME.modifiers.no_blind_reward.Small = true
                        elseif choice2 == 2 then
                            G.GAME.modifiers.no_blind_reward.Big = true
                        elseif choice2 == 3 then
                            G.GAME.modifiers.no_blind_reward.Boss = true
                        end
                    elseif choice == 34 then
                        G.GAME.modifiers.no_extra_hand_money = true
                    elseif choice == 35 then
                        G.GAME.modifiers.no_interest = true
                    elseif choice == 36 then
                        G.GAME.modifiers.scaling = (G.GAME.modifiers.scaling or 0) + 1
                    elseif choice == 37 then
                        G.GAME.starting_params.no_faces = true
                    elseif choice == 38 then
                        G.GAME.starting_params.ante_scaling = (G.GAME.starting_params.ante_scaling or 0) + 1
                    elseif choice == 39 then
                        G.GAME.starting_params.boosters_in_shop = G.GAME.starting_params.boosters_in_shop - 1
                    elseif choice == 40 then
                        G.GAME.starting_params.erratic_suits_and_ranks = true
                    elseif choice == 41 then
                        G.GAME.starting_params.vouchers_in_shop = G.GAME.starting_params.vouchers_in_shop -1
                    end
                    if b <= 5 then
                        G.STATE_COMPLETE = false
                        G.STATE = G.STATES.GAME_OVER
                    else
                        b = b - 5
                        G.GAME.uv_insanity_timer_threshold = b
                        a = 0
                    end
                end
                local blinddefeat_old = Blind.defeat
                function Blind:defeat(silent)
                    a = 0
                    return blinddefeat_old(self,silent)
                end 
                
                event.start_timer = false
            end
        }
        G.E_MANAGER:add_event(event)
        
    end,
    colour = G.C.PURPLE,
    shiny = true,
    loc_txt = {
        name = "Purple Stake...?",
        text = {
            "Applies Insanity to this run",
            "{C:inactive}\"I SWEAR i've seen you before\"{}",
            "{C:inactive}\"... Who am I talking to again?\"{}"
        },
        sticker = {
            name = "Purple Stake...?",
            text = {
                "Defeated Insanity with this joker"
            }
        }
    }
}
