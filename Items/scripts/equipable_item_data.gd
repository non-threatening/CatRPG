class_name EquipableItemData extends ItemData

enum Type { WEAPON, COLLAR, ARMOR, RFID_CHIP }

@export var type : Type = Type.WEAPON
@export var modifiers : Array[ EquipableItemModifier ]
