---@meta

----------------------------------------------------------------
-- MetaMethods
----------------------------------------------------------------

---@class Freemaker.ClassSystem.ObjectMetaMethods
---@field protected __init (fun(self: object, ...)) | nil self(...) before construction
---@field protected __call (fun(self: object, ...) : ...) | nil self(...) after construction
---@field protected __close (fun(self: object, errObj: any) : any) | nil invoked when the object gets out of scope
---@field protected __gc fun(self: object) | nil Freemaker.ClassSystem.old.Deconstruct(self) or garbageCollection
---@field protected __add (fun(self: object, other: any) : any) | nil (self) + (value)
---@field protected __sub (fun(self: object, other: any) : any) | nil (self) - (value)
---@field protected __mul (fun(self: object, other: any) : any) | nil (self) * (value)
---@field protected __div (fun(self: object, other: any) : any) | nil (self) / (value)
---@field protected __mod (fun(self: object, other: any) : any) | nil (self) % (value)
---@field protected __pow (fun(self: object, other: any) : any) | nil (self) ^ (value)
---@field protected __idiv (fun(self: object, other: any) : any) | nil (self) // (value)
---@field protected __band (fun(self: object, other: any) : any) | nil (self) & (value)
---@field protected __bor (fun(self: object, other: any) : any) | nil (self) | (value)
---@field protected __bxor (fun(self: object, other: any) : any) | nil (self) ~ (value)
---@field protected __shl (fun(self: object, other: any) : any) | nil (self) << (value)
---@field protected __shr (fun(self: object, other: any) : any) | nil (self) >> (value)
---@field protected __concat (fun(self: object, other: any) : any) | nil (self) .. (value)
---@field protected __eq (fun(self: object, other: any) : any) | nil (self) == (value)
---@field protected __lt (fun(t1: any, t2: any) : any) | nil (self) < (value)
---@field protected __le (fun(t1: any, t2: any) : any) | nil (self) <= (value)
---@field protected __unm (fun(self: object) : any) | nil -(self)
---@field protected __bnot (fun(self: object) : any) | nil  ~(self)
---@field protected __len (fun(self: object) : any) | nil #(self)
---@field protected __pairs (fun(t: table) : ((fun(t: table, key: any) : key: any, value: any), t: table, startKey: any)) | nil pairs(self)
---@field protected __ipairs (fun(t: table) : ((fun(t: table, key: number) : key: number, value: any), t: table, startKey: number)) | nil ipairs(self)
---@field protected __tostring (fun(t):string) | nil tostring(self)
---@field protected __index (fun(class, key) : any) | nil xxx = self.xxx | self[xxx]
---@field protected __newindex fun(class, key, value) | nil self.xxx = xxx | self[xxx] = xxx

---@class object : Freemaker.ClassSystem.ObjectMetaMethods, function

---@class Freemaker.ClassSystem.MetaMethods
---@field __gc fun(self: object) | nil Class.Deconstruct(self) or garbageCollection
---@field __close (fun(self: object, errObj: any) : any) | nil invoked when the object gets out of scope
---@field __call (fun(self: object, ...) : ...) | nil self(...) after construction
---@field __index (fun(class: object, key: any) : any) | nil xxx = self.xxx | self[xxx]
---@field __newindex fun(class: object, key: any, value: any) | nil self.xxx | self[xxx] = xxx
---@field __tostring (fun(t):string) | nil tostring(self)
---@field __add (fun(left: any, right: any) : any) | nil (left) + (right)
---@field __sub (fun(left: any, right: any) : any) | nil (left) - (right)
---@field __mul (fun(left: any, right: any) : any) | nil (left) * (right)
---@field __div (fun(left: any, right: any) : any) | nil (left) / (right)
---@field __mod (fun(left: any, right: any) : any) | nil (left) % (right)
---@field __pow (fun(left: any, right: any) : any) | nil (left) ^ (right)
---@field __idiv (fun(left: any, right: any) : any) | nil (left) // (right)
---@field __band (fun(left: any, right: any) : any) | nil (left) & (right)
---@field __bor (fun(left: any, right: any) : any) | nil (left) | (right)
---@field __bxor (fun(left: any, right: any) : any) | nil (left) ~ (right)
---@field __shl (fun(left: any, right: any) : any) | nil (left) << (right)
---@field __shr (fun(left: any, right: any) : any) | nil (left) >> (right)
---@field __concat (fun(left: any, right: any) : any) | nil (left) .. (right)
---@field __eq (fun(left: any, right: any) : any) | nil (left) == (right)
---@field __lt (fun(left: any, right: any) : any) | nil (left) < (right)
---@field __le (fun(left: any, right: any) : any) | nil (left) <= (right)
---@field __unm (fun(self: object) : any) | nil -(self)
---@field __bnot (fun(self: object) : any) | nil ~(self)
---@field __len (fun(self: object) : any) | nil #(self)
---@field __pairs (fun(self: object) : ((fun(t: table, key: any) : key: any, value: any), t: table, startKey: any)) | nil pairs(self)
---@field __ipairs (fun(self: object) : ((fun(t: table, key: number) : key: number, value: any), t: table, startKey: number)) | nil ipairs(self)

---@class Freemaker.ClassSystem.TypeMetaMethods : Freemaker.ClassSystem.MetaMethods
---@field __init (fun(self: object, ...)) | nil self(...) before construction

----------------------------------------------------------------
-- Type
----------------------------------------------------------------

---@class Freemaker.ClassSystem.Type
---@field Name string
---@field Base Freemaker.ClassSystem.Type | nil
---
---@field Static table<string, any>
---
---@field MetaMethods Freemaker.ClassSystem.TypeMetaMethods
---@field Members table<any, any>
---
---@field HasConstructor boolean
---@field HasDeconstructor boolean
---@field HasClose boolean
---@field HasIndex boolean
---@field HasNewIndex boolean
---
---@field Options Freemaker.ClassSystem.Type.Options
---
---@field Instances table<object, boolean>
---
---@field Blueprint Freemaker.ClassSystem.Blueprint | nil

---@class Freemaker.ClassSystem.Type.Options
---@field IsAbstract boolean | nil

----------------------------------------------------------------
-- Metatable
----------------------------------------------------------------

---@class Freemaker.ClassSystem.Metatable : Freemaker.ClassSystem.MetaMethods
---@field Type Freemaker.ClassSystem.Type
---@field Instance Freemaker.ClassSystem.Instance

----------------------------------------------------------------
-- Blueprint
----------------------------------------------------------------

---@class Freemaker.ClassSystem.BlueprintMetatable : Freemaker.ClassSystem.MetaMethods
---@field Type Freemaker.ClassSystem.Type

---@class Freemaker.ClassSystem.Blueprint

----------------------------------------------------------------
-- Instance
----------------------------------------------------------------

---@class Freemaker.ClassSystem.Instance
---@field IsConstructed boolean
---
---@field CustomIndexing boolean

----------------------------------------------------------------
-- Create Options
----------------------------------------------------------------

---@class Freemaker.ClassSystem.Create.Options : Freemaker.ClassSystem.Type.Options
---@field BaseClass object | nil
