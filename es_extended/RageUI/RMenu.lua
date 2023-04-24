---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Dylan Malandain.
--- DateTime: 29/10/2019 02:40
---

---@class RageUI
RageUI = {}

---@class Item
RageUI.Item = {}

---@class Panel
RageUI.Panel = {}

---@class Window
RageUI.Window = {}

---@class RMenu
RMenu = setmetatable({}, RMenu)

---@type table
local TotalMenus = {}

---Add
---@param Type string
---@param Name string
---@param Menu table
---@return RMenu
---@public
function RMenu.Add(Type, Name, Menu)
    if RMenu[Type] ~= nil then
        RMenu[Type][Name] = {
            Menu = Menu
        }
    else
        RMenu[Type] = {}
        RMenu[Type][Name] = {
            Menu = Menu
        }
    end
    return table.insert(TotalMenus, Menu)
end

---Get
---@param Type string
---@param Name string
---@return table
---@public
function RMenu:Get(Type, Name)
    if self[Type] ~= nil and self[Type][Name] ~= nil then
        return self[Type][Name].Menu
    end
end

---GetType
---@param Type string
---@return table
---@public
function RMenu:GetType(Type)
    if self[Type] ~= nil then
        return self[Type]
    end
end

---Settings
---@param Type string
---@param Name string
---@param Settings string
---@param Value any optional
---@return void
---@public
function RMenu:Settings(Type, Name, Settings, Value)
    if Value ~= nil then
        self[Type][Name][Settings] = Value
    else
        return self[Type][Name][Settings]
    end
end

---Delete
---@param Type string
---@param Name string
---@return void
---@public
function RMenu:Delete(Type, Name, cb)
    self[Type][Name] = nil
    collectgarbage()

    if cb then
        return nil
    end
end

---DeleteType
---@param Type string
---@return void
---@public
function RMenu:DeleteType(Type, cb)
    self[Type] = nil
    collectgarbage()

    if cb then
        return nil
    end
end
