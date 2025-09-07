-- Atlas
--[[ SMODS.Atlas({
    key = "virtueblinds", 
    path = "virtueblinds.png", 
    px = 71,
    py = 95, 
    atlas_table = "ANIMATION_ATLAS"
}) ]]

-- Text popup
local hover_ref = Blind.hover
function Blind.hover(self)
    if not G.CONTROLLER.dragging.target and not self.hovering and (self.name == "bl_uv_chastity") then
        self.config.h_popup = parse_card_hover_box {
            name = "Virtue",
            text = {
                "-3 hand size",
                "+1 Joker slot",
                "Awards Lust"
            }
        }
        self.config.h_popup_config = { align = 'cr', parent = self }
    elseif not G.CONTROLLER.dragging.target and not self.hovering and (self.name == "bl_uv_temperance") then
        self.config.h_popup = parse_card_hover_box {
            name = "Virtue",
            text = {
                "-3 hand size",
                "+1 Joker slot",
                "Awards Gluttony"
            }
        }
        self.config.h_popup_config = { align = 'cr', parent = self }
    elseif not G.CONTROLLER.dragging.target and not self.hovering and (self.name == "bl_uv_charity") then
        self.config.h_popup = parse_card_hover_box {
            name = "Virtue",
            text = {
                "-3 hand size",
                "+1 Joker slot",
                "Awards Greed"
            }
        }
        self.config.h_popup_config = { align = 'cr', parent = self }
     elseif not G.CONTROLLER.dragging.target and not self.hovering and (self.name == "bl_uv_diligence") then
        self.config.h_popup = parse_card_hover_box {
            name = "Virtue",
            text = {
                "-3 hand size",
                "+1 Joker slot",
                "Awards Sloth"
            }
        }
        self.config.h_popup_config = { align = 'cr', parent = self }
     elseif not G.CONTROLLER.dragging.target and not self.hovering and (self.name == "bl_uv_kindness") then
        self.config.h_popup = parse_card_hover_box {
            name = "Virtue",
            text = {
                "-3 hand size",
                "+1 Joker slot",
                "Awards Envy"
            }
        }
        self.config.h_popup_config = { align = 'cr', parent = self }
    elseif not G.CONTROLLER.dragging.target and not self.hovering and (self.name == "bl_uv_patience") then
        self.config.h_popup = parse_card_hover_box {
            name = "Virtue",
            text = {
                "-3 hand size",
                "+1 Joker slot",
                "Awards Wrath"
            }
        }
        self.config.h_popup_config = { align = 'cr', parent = self }
     elseif not G.CONTROLLER.dragging.target and not self.hovering and (self.name == "bl_uv_humility") then
        self.config.h_popup = parse_card_hover_box {
            name = "Virtue",
            text = {
                "-3 hand size",
                "+1 Joker slot",
                "Awards Pride"
            }
        }
        self.config.h_popup_config = { align = 'cr', parent = self } 
    end
    return hover_ref(self)
end 

SMODS.Blind{
    key = "chastity",
    loc_txt = {
        name = "Chastity",
        text = {
            "Pairs and Two Pairs",
            "are unable to be scored"
        }
    },
    dollars = 8,
    mult = 4,
    boss = {
        min = 4
    },
    boss_colour = HEX('9F5786'),
    -- atlas = "virtueblinds",
    pos = {x = 0, y = 0},
    hands = {
        ["Pair"] = true,
        ["Two Pair"] = true
    },
    set_blind = function(self, reset, silent)
        G.hand:change_size(-3)
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        return self.hands[handname]
    end,
    defeat = function(self)
        G.hand:change_size(3)
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        local clone = SMODS.create_card({set = "Joker", area = G.jokers, key = "j_uv_lust"})
        clone:add_to_deck()
        G.jokers:emplace(clone)
        
    end
}

SMODS.Blind{
    key = "temperance",
    loc_txt = {
        name = "Temperance",
        text = {
            "Blind amount is increased by 25%",
            "for each consumable used this run",
            "(Activates at blind selection)"
        }
    },
    dollars = 8,
    mult = 4,
    boss = {
        min = 4
    },
    boss_colour = HEX('c07b57'),
    -- atlas = "virtueblinds",
    pos = {x = 0, y = 0},
    set_blind = function(self, reset, silent)
        G.hand:change_size(-3)
        G.GAME.blind.chips = G.GAME.blind.chips + ((G.GAME.blind.chips/4) * G.GAME.consumeable_usage_total.all)
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        G.GAME.blind:juice_up()
    end,
    defeat = function(self)
        G.hand:change_size(3)
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        local clone = SMODS.create_card({set = "Joker", area = G.jokers, key = "j_uv_gluttony"})
        clone:add_to_deck()
        G.jokers:emplace(clone)
    end
}

SMODS.Blind{
    key = "charity",
    loc_txt = {
        name = "Charity",
        text = {
            "Lose $5 each hand played.",
            "Amount lost increases by $2",
            "every hand for each joker you have."
        }
    },
    dollars = 8,
    mult = 4,
    boss = {
        min = 4
    },
    config = {
        extra = {
            dollars = 5
        }
    },
    boss_colour = HEX('cdce4e'),
    -- atlas = "virtueblinds",
    pos = {x = 0, y = 0},
    loc_vars = function(self, info_queue, card)
        return { vars = {self.config.extra.dollars} }
    end,
    set_blind = function(self, reset, silent)
        G.hand:change_size(-3)
        G.GAME.bankrupt_at = G.GAME.bankrupt_at - 99999
    end,
    press_play = function(self)
        ease_dollars(-self.config.extra.dollars)
        self.config.extra.dollars = self.config.extra.dollars + (2 * #G.jokers.cards)
        G.GAME.blind:juice_up()
    end,
    defeat = function(self)
        G.hand:change_size(3)
        G.GAME.bankrupt_at = G.GAME.bankrupt_at + 99999
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        local clone = SMODS.create_card({set = "Joker", area = G.jokers, key = "j_uv_greed"})
        clone:add_to_deck()
        G.jokers:emplace(clone)
    end,
}

SMODS.Blind{
    key = "diligence",
    loc_txt = {
        name = "Diligence",
        text = {
            "Cards are discarded if they",
            "are held in hand for two turns.",
        }
    },
    dollars = 8,
    mult = 4,
    boss = {
        min = 4
    },
    boss_colour = HEX('4c7e9a'),
    -- atlas = "virtueblinds",
    pos = {x = 0, y = 0},
    set_blind = function(self, reset, silent)
        G.hand:change_size(-3)
    end,
    press_play = function(self)
         G.E_MANAGER:add_event(Event({
            func = function()
                local any_selected = false
                for k, v in ipairs(G.hand.cards) do
                    v.diligenceCounter = (v.diligenceCounter or 0) + 1
                    if v.diligenceCounter >= 2 then
                        G.hand.config.highlighted_limit = G.hand.config.highlighted_limit + 99999
                        G.hand:add_to_highlighted(v, true)
                        any_selected = true
                    end
                end
                if any_selected then 
                    G.GAME.blind:juice_up()
                    G.FUNCS.discard_cards_from_highlighted(nil, true) 
                    G.hand.config.highlighted_limit = G.hand.config.highlighted_limit - 99999 
                end
                return true
            end
        }))
    end,
    defeat = function(self)
        for k, v in ipairs(G.hand.cards) do
            v.diligenceCounter = 0
        end
        for k, v in ipairs(G.discard.cards) do
            v.diligenceCounter = 0
        end
        for k, v in ipairs(G.deck.cards) do
            v.diligenceCounter = 0
        end
        for k, v in ipairs(G.play.cards) do
            v.diligenceCounter = 0
        end
        G.hand:change_size(3)
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        local clone = SMODS.create_card({set = "Joker", area = G.jokers, key = "j_uv_sloth"})
        clone:add_to_deck()
        G.jokers:emplace(clone)
    end,
}

SMODS.Blind{
    key = "kindness",
    loc_txt = {
        name = "Kindness",
        text = {
            "Scored cards lose 50 chips"
        }
    },
    dollars = 8,
    mult = 4,
    boss = {
        min = 4
    },
    boss_colour = HEX('2b7d53'),
    -- atlas = "virtueblinds",
    pos = {x = 0, y = 0},
    set_blind = function(self, reset, silent)
        G.hand:change_size(-3)
    end,
    press_play = function(self)
        for k, v in ipairs(G.hand.cards) do
            v.ability.perma_chips = v.ability.perma_chips - 50
            G.GAME.blind:juice_up()
        end
    end,
    defeat = function(self)
        G.hand:change_size(3)
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        local clone = SMODS.create_card({set = "Joker", area = G.jokers, key = "j_uv_envy"})
        clone:add_to_deck()
        G.jokers:emplace(clone)
    end,
}

SMODS.Blind{
    key = "patience",
    loc_txt = {
        name = "Patience",
        text = {
            "Starts at x8 base",
            "loses 1/8th of it's chips per hand played"
        }
    },
    dollars = 8,
    mult = 8,
    boss = {
        min = 4
    },
    config = {
        extra = {
            oneEighth = 0
        }
    },
    boss_colour = HEX('af3233'),
    -- atlas = "virtueblinds",
    pos = {x = 0, y = 0},
    set_blind = function(self, reset, silent)
        G.hand:change_size(-3)
        self.config.extra.oneEighth = math.ceil(G.GAME.blind.chips/8)

    end,
    press_play = function(self)
        G.GAME.blind.chips = G.GAME.blind.chips - self.config.extra.oneEighth
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        G.GAME.blind:juice_up()
    end,
    defeat = function(self)
        G.hand:change_size(3)
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        local clone = SMODS.create_card({set = "Joker", area = G.jokers, key = "j_uv_wrath"})
        clone:add_to_deck()
        G.jokers:emplace(clone)
    end,
}

SMODS.Blind{
    key = "humility",
    loc_txt = {
        name = "Humility",
        text = {
            "Can only score up to 2 cards.",
            "x6 base"
        }
    },
    dollars = 8,
    mult = 6,
    boss = {
        min = 4
    },
    config = {
        extra = {
            oneEighth = 0
        }
    },
    debuff = {
        h_size_le = 2
    },
    boss_colour = HEX('523b67'),
    -- atlas = "virtueblinds",
    pos = {x = 0, y = 0},
    set_blind = function(self, reset, silent)
        G.hand:change_size(-3)
    end,
    defeat = function(self)
        G.hand:change_size(3)
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        local clone = SMODS.create_card({set = "Joker", area = G.jokers, key = "j_uv_pride"})
        clone:add_to_deck()
        G.jokers:emplace(clone)
    end,
}