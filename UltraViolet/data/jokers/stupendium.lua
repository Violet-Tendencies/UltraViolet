-- Atlas

SMODS.Atlas({
    key = "StupendiumJokers", 
    path = "CustomJokers.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
})

-- Jokers

SMODS.Joker{
    key = "ministry",
    loc_txt = {
        name = "GLORY TO THE MINISTRY.",
        text = {
            'Gains {C:red}+1{} mult for every high card',
            'scored and for every card destroyed',
            'If the scored hand has 2 or more cards',
            'destroy one at random. {C:inactive}(Currently #1#){}',
            '{C:inactive}That telephone\'s not tampered with',
            '{C:inactive}of course it isn\'t listening! {}',
            '{C:inactive}But were it, it prefers the words-{}',
            '{C:inactive}(Stupendium){}'
        }
    },
    atlas = "StupendiumJokers",
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
            mult = 0,
            MultGained = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult} }
    end,
    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.MultGained = false
        end
        if context.joker_main then
                if context.scoring_name == "High Card" then
                    if not card.ability.extra.MultGained then
                        card.ability.extra.mult = card.ability.extra.mult + 1
                        card.ability.extra.MultGained = true
                    end
                else
                if #context.scoring_hand > 1 then
                    local _cards = {}
                    for _, playing_card in ipairs(G.play.cards) do
                        _cards[#_cards + 1] = playing_card
                    end
                    local selected_card = pseudorandom_element(_cards, pseudoseed('Balalalala'))
                    SMODS.destroy_cards(selected_card)
                    if not card.ability.extra.MultGained then
                        card.ability.extra.mult = card.ability.extra.mult + 1
                        card.ability.extra.MultGained = true
                    end
                end
            end
            if card.ability.extra.mult > 0 then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
        if context.destroy_card then
            if not card.ability.extra.MultGained then
                card.ability.extra.mult = card.ability.extra.mult + 1
                card.ability.extra.MultGained = true
            end
        end
    end
}

SMODS.Joker{
    key = "house",
    loc_txt = {
        name = "The House Always Wins",
        text = {
            'If you aren\'t in debt,',
            'scores double your current money as chips',
            'and half your current money as mult',
            'but loses 2/5ths of your current money',
            'Alternates between doubling or halving',
            'all displayed odds (Alternates after scoring)',
            '{C:inactive}(Currently: #1#){}',
            '{C:inactive}Might be safer in the desert,',
            '{C:inactive}only dust to judge your sins.',
            '{C:inactive}but those who wager aren\'t so clever',
            '{C:inactive}\'Cus in heaven, well-',
            '{C:inactive}(Stupendium){}'
        }
    },
    atlas = "StupendiumJokers",
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
            Odds = "double"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.Odds} }
    end,
    add_to_deck = function(self, card, from_debuff)
        for k, v in pairs(G.GAME.probabilities) do
            G.GAME.probabilities[k] = v * 2
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.Odds == "double" then
            for k, v in pairs(G.GAME.probabilities) do
                G.GAME.probabilities[k] = v / 2
            end
        elseif card.ability.extra.Odds == "half" then
            for k, v in pairs(G.GAME.probabilities) do
                G.GAME.probabilities[k] = v * 2
            end
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if G.GAME.dollars or G.GAME.dollar_buffer then
                if (G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0) > 0 then
                    return {
                        mult = math.floor(((G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0)) / 2),
                        chips = math.floor(((G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0)) * 2),
                        dollars = -math.floor(((G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0)) * 0.4)
                    }
                end
            end
        end
        if context.after then
            if card.ability.extra.Odds == "double" then
                for k, v in pairs(G.GAME.probabilities) do
                    G.GAME.probabilities[k] = v / 2
                end
                for k, v in pairs(G.GAME.probabilities) do
                    G.GAME.probabilities[k] = v / 2
                end
                card.ability.extra.Odds = "half"
            elseif card.ability.extra.Odds == "half" then
                for k, v in pairs(G.GAME.probabilities) do
                    G.GAME.probabilities[k] = v * 2
                end
                for k, v in pairs(G.GAME.probabilities) do
                    G.GAME.probabilities[k] = v * 2
                end
                card.ability.extra.Odds = "double"
            end
        end
    end
}

SMODS.Joker{
    key = "monica",
    loc_txt = {
        name = "Dear Diary",
        text = {
            'Transforms a random non-club',
            'card in hand to a Club',
            'scores mult based on how many',
            'Clubs are in the deck {C:inactive}(currently: #1#){}',
            '{C:inactive}MONICA\'S ALL THAT YOU NEED,\nMONICA\'S ALL THAT YOU NEED,\nMONICA\'S-{}',
            '{C:inactive}(Stupendium){}'
        }
    },
    atlas = "StupendiumJokers",
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
            mult = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult} }
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.mult = 0
        for k, v in pairs(G.playing_cards) do
            if v:is_suit("Clubs") then
                card.ability.extra.mult = card.ability.extra.mult + 1
            end
        end
    end,
    calculate = function(self, card, context)
        if context.before or context.setting_blind or context.using_consumeable then
            card.ability.extra.mult = 0
            for k, v in pairs(G.playing_cards) do
                if v:is_suit("Clubs") then
                    card.ability.extra.mult = card.ability.extra.mult + 1
                end
            end
        end
        if context.before then
            local _cards = {}
            for k, v in pairs(G.hand.cards) do
                if not v:is_suit("Clubs") then
                    _cards[#_cards + 1] = v
                end
            end
            if #_cards >= 1 then
                local selectedCard = pseudorandom_element(_cards, pseudoseed("MONICA"))
                selectedCard:flip()
                SMODS.change_base(selectedCard, "Clubs")
                selectedCard:flip()
                card.ability.extra.mult = card.ability.extra.mult + 1
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker{
    key = "alice1",
    loc_txt = {
        name = "The Art of Darkness",
        text = {
            'Scoring all spades brings a',
            'random scored card back to the hand.',
            'Any played Hearts cards are destroyed.',
            '{C:inactive}Ever seen a masterpiece get discarded?{}',
            '{C:inactive}(Stupendium){}'
        }
    },
    atlas = "StupendiumJokers",
    rarity = 2,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    calculate = function(self, card, context)
        if context.after then
            local heart_cards = {} 
            local spade_cards = {}
            for k, v in pairs(G.play.cards) do  
                if v:is_suit("Hearts") then
                    heart_cards[#heart_cards + 1] = v
                elseif v:is_suit("Spades") then
                    spade_cards[#spade_cards + 1] = v
                end
            end
            if spade_cards then
                if #spade_cards == #context.scoring_hand then
                    local CArd = pseudorandom_element(spade_cards, pseudoseed("draw!"))
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            draw_card(G.play, G.hand, 90, 'up', nil, CArd)
                            draw_card(G.play, G.play, 90, 'up', nil, CArd)
                            CArd:flip()
                            return true
                        end
                    }))
                end
            end
            if #heart_cards > 0 then
                SMODS.destroy_cards(heart_cards)
            end
        end
    end
}

-- turn into a blind
--[[ SMODS.Joker{
    key = "count_to_3",
    loc_txt = {
        name = "Count to 3",
        text = {
            'If played hand contains exactly 3 cards',
            'Scored Aces and 2s gain random edition but are debuffed',
            'and scored 4s gain 0.1 xmult for each card debuffed in hand.',
            'All 3s are debuffed',
            '{C:inactive}Is this what you\'ve been waiting for? Say 1, 2, and 4!{}',
            '{C:inactive}(Stupendium and The Chalkeaters){}'
        }
    },
    atlas = "StupendiumJokers",
    rarity = 2,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    add_to_deck = function(self, card, from_debuff)
        for k, v in pairs(G.playing_cards) do
            if v:get_id() == 3 then
                SMODS.debuff_card(v, true, "Count to 3")
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        for k, v in pairs(G.playing_cards) do
            SMODS.debuff_card(v, false, "Count to 3")
        end
    end,
    calculate = function(self, card, context)
        if context.before or context.setting_blind or context.using_consumeable then
            for k, v in pairs(G.playing_cards) do
                if v:get_id() == 3 then
                    SMODS.debuff_card(v, true, "Count to 3")
                end
            end
        end
        if context.joker_main then
            for k, v in ipairs(G.play.cards) do
                if #context.scoring_hand == 3 then
                    if v:get_id() == 2 or v.base.value == "Ace" then
                        v:flip()
                        local enhancement = SMODS.poll_enhancement({guaranteed = true})
                        v:set_ability(enhancement, nil, true)
                        SMODS.debuff_card(v, true, "Count to 3")
                        v:flip()
                    elseif v:get_id() == 4 then
                        local count = 0
                        for k2, v2 in pairs(G.hand.cards) do
                            if v2.debuff == true then
                                count = count + 1
                            end
                        end
                        v.ability.perma_x_mult = (v.ability.perma_x_mult or 0) + (0.1 * count)
                    end
                end
            end
        end
    end
} ]]

SMODS.Joker{
    key = "just_monkey_business",
    loc_txt = {
        name = "Just Monkey Business",
        text = {
            'Gains x0.5 mult when a card is destroyed',
            '{C:inactive}(Currently: #1#){}',
            'and gains a random minor permanent',
            'effect when something is bought',
            '{C:inactive}Pay your tab at the front desk',
            '{C:inactive}or death\'ll be slow.{}',
            '{C:inactive}(Stupendium){}'
        }
    },
    atlas = "StupendiumJokers",
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
            mult = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult} }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.mult > 1 then
                return { xmult = card.ability.extra.mult}
            end
        end
        if context.destroying_card then
            card.ability.extra.mult = card.ability.extra.mult + 0.5
        end
        if context.buying_card then
            local bonus = math.ceil(pseudorandom("hi", 1, 4))
            if bonus == 1 then
                card.ability.perma_bonus = (card.ability.perma_bonus or 0) + pseudorandom("hi", 1, 10)
            elseif bonus == 2 then
                card.ability.perma_mult = (card.ability.perma_mult or 0) + pseudorandom("hi", 1, 10)
            elseif bonus == 3 then
                card.ability.perma_x_chips = (card.ability.perma_x_chips or 0) + pseudorandom("hi", 1, 5)
            elseif bonus == 4 then
                card.ability.perma_x_mult = (card.ability.perma_x_mult or 0) + pseudorandom("hi", 1, 5)
            end
        end
    end
}

SMODS.Joker{
    key = "brb",
    loc_txt = {
        name = "Big Red Button",
        text = {
            'Each hand destroys a random card in deck',
            '{C:inactive}You know, I\'ve just realized that this',
            '{C:inactive}dotted line around the globe is supposed to be the Equator...{}',
            '{C:inactive}I always thought of it more as a \'cut here\'{}',
            '{C:inactive}(Stupendium){}'
        }
    },
    atlas = "StupendiumJokers",
    rarity = 2,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    calculate = function(self, card, context)
        if context.after then
            if #G.deck.cards > 0 then
                local _cards = {}
                for _, playing_card in ipairs(G.deck.cards) do
                    _cards[#_cards + 1] = playing_card
                end
                local selectedCard = pseudorandom_element(_cards, pseudoseed("This a creative enough seed for you"))
                SMODS.destroy_cards(selectedCard)
            end
        end
    end
}

--[[ SMODS.Joker{
    key = "fractured_picture",
    loc_txt = {
        name = "Fractured Picture",
        text = {
            'If a scored card has no seal, enhancement, and edition, give that card a random seal, enhancement, or edition and randomize it\'s suit',
            '{C:inactive}You cannot always choose the pictures, but you can choose how they are depicted{}',
            '{C:inactive}and they will always be hung in your frame of mind.{}',
            '{C:inactive}(Stupendium){}'
        }
    },
    atlas = "StupendiumJokers",
    rarity = 2,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    pos = {x=0, y=0},
    calculate = function(self, card, context)
        if context.after then
            for i, scoredCard in ipairs(context.scoring_hand) do
                if not scoredCard.seal and not scoredCard.edition and not next(SMODS.get_enhancements(scoredCard)) then
                    local choice = pseudorandom("Hi", 1, 3)

                    if choice == 1 then
                        
                    elseif choice == 2 then

                    elseif choice == 3 then

                    end
                end
            end
        end
    end
} ]]

SMODS.Joker{
    key = "carousel",
    loc_txt = {
        name = "#1#",
        text = {
            'Alternates between scoring +#3# chips',
            'and #4# mult each card scored',
            '{C:inactive}#2#{}',
            '{C:inactive}#5#{}',
            '{C:inactive}(Stupendium){}'
        }
    },
    atlas = "StupendiumJokers",
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
            scoring = "chips",
            roundsIncrement = false,
            CloneMade = false,
            rounds = 1,
            mult = -1,
            chips = 5,
            names = {"A Carousel", "A Carousel?", "A \"Carousel\"?", "A... \"Carousel\""},
            lyrics1 = {"It\'s up to us all", "A teleporting exit door and-", "No, forget about the exit", "Quit that line of thinking or"},
            lyrics2 = {"to make the merry go round!", "WHOA! HAHA! NEVER MIND!", "there\'s so much to enjoy!", "else you\'ll END UP IN THE BASEMENT!"}
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.names[card.ability.extra.rounds], card.ability.extra.lyrics1[card.ability.extra.rounds], card.ability.extra.chips * card.ability.extra.rounds, card.ability.extra.mult * card.ability.extra.rounds, card.ability.extra.lyrics2[card.ability.extra.rounds]} }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.roundsIncrement = false
            card.ability.extra.CloneMade = false
        end
        if context.before then
            card.ability.extra.scoring = "chips"
        end
        if context.individual and context.cardarea == G.play then
            if card.ability.extra.scoring == "chips" then
                card.ability.extra.scoring = "mult"
                return {
                    chips = card.ability.extra.chips * card.ability.extra.rounds
                }
            elseif card.ability.extra.scoring == "mult" then
                card.ability.extra.scoring = "chips"
                return {
                    mult = card.ability.extra.mult * card.ability.extra.rounds
                }
            end
        end
        if context.end_of_round then
            if not card.ability.extra.roundsIncrement then
                if card.ability.extra.rounds >= 4 then
                    if not card.ability.extra.CloneMade then
                        SMODS.destroy_cards(card)
                        local clone = SMODS.create_card({set = "Joker", area = G.jokers, key = "j_uv_basement"})
                        card.ability.extra.CloneMade = true
                        clone:add_to_deck()
                        G.jokers:emplace(clone)
                        SMODS.calculate_effect({
                            message = "QUJTVFJBQ1RFRCE=",
                            colour = G.C.ORANGE
                        }, clone)
                    end
                end
                card.ability.extra.rounds = card.ability.extra.rounds + 1
                card.ability.extra.roundsIncrement = true
            end
        end
    end
}

SMODS.Joker{
    key = "basement",
    loc_txt = {
        name = "The Basement.",
        text = {
            'Scores +1 mult for every card in the deck (currently: +#1#)',
            'Scores +1 chips for every card in the discard (currently: +#2#)',
            '{C:inactive}(currently: #3#){}',
            '{C:inactive}HAHAHAHAHAAHAHAHAAAHAAHELPHAHAAAAAHHHAHAHAHAAAHAHHHAHHA{}',
            '{C:inactive}(Stupendium){}'
        }
    },
    atlas = "StupendiumJokers",
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
            mult = 1,
            chips = 1,
            xchips = 1,
            chipsIncrement = false
        }
    },
    loc_vars = function(self, info_queue, card)
        if G.deck ~= nil and G.discard ~= nil then
            return { vars = {card.ability.extra.mult * (#G.deck.cards or 0), card.ability.extra.chips * (#G.discard.cards or 0), (card.ability.extra.xchips or 0)} }
        else
            return { vars = {card.ability.extra.mult * 0, card.ability.extra.chips * 0, (card.ability.extra.xchips or 0)} }
        end
    end,
    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.chipsIncrement = false
        end
        if context.joker_main then
            if card.ability.extra.xchips > 1 then
                return {
                    mult = card.ability.extra.mult * #G.deck.cards,
                    chips = card.ability.extra.chips * #G.discard.cards,
                    xchips = card.ability.extra.xchips
                }
            else
                return {
                    mult = card.ability.extra.mult * #G.deck.cards,
                    chips = card.ability.extra.chips * #G.discard.cards
                }
            end
        end
        if context.destroy_card then
            if not card.ability.extra.chipsIncrement then
                card.ability.extra.xchips = card.ability.extra.xchips + 0.1
                card.ability.extra.chipsIncrement = true
            end
        end
    end,
    in_pool = function(self, args)
        return false
    end
}
