class_name Flowers extends Node

const DANDELION_TEXTURE: Texture2D = preload("res://assets/flowers/dandelion.png")
const DAISY_TEXTURE: Texture2D = preload("res://assets/flowers/daisy.png")
const TULIP_TEXTURE: Texture2D = preload("res://assets/flowers/tulip.png")
const ROSE_TEXTURE: Texture2D = preload("res://assets/flowers/rose.png")
const SUNFLOWER_TEXTURE: Texture2D = preload("res://assets/flowers/sunflower.png")
const CLOVER_TEXTURE: Texture2D = preload("res://assets/flowers/clover.png")

const CLOVER_FLOWER:Flower = preload("res://flowers/clover.tres")
const CORNFLOWER_FLOWER:Flower = preload("res://flowers/cornflower.tres")
const DAISY_FLOWER:Flower = preload("res://flowers/daisy.tres")
const DANDELION_FLOWER:Flower = preload("res://flowers/dandelion.tres")
const DANDELION_OLD_FLOWER:Flower = preload("res://flowers/dandelion_old.tres")
const FIELD_POPPY_FLOWER:Flower = preload("res://flowers/field_poppy.tres")
const LAVENDER_FLOWER:Flower = preload("res://flowers/lavender.tres")
const ROSE_FLOWER:Flower = preload("res://flowers/rose.tres")
const SUNFLOWER_FLOWER:Flower = preload("res://flowers/sunflower.tres")
const TULIP_FLOWER:Flower = preload("res://flowers/tulip.tres")
const VIOLET_FLOWER:Flower = preload("res://flowers/violet.tres")

const FLOWER_TEXTURES: Array[Texture2D] = [
	DANDELION_TEXTURE,
	DAISY_TEXTURE,
	TULIP_TEXTURE,
	ROSE_TEXTURE,
	SUNFLOWER_TEXTURE,
	CLOVER_TEXTURE
]

const FLOWER_TYPES: Array[Flower] = [
	CLOVER_FLOWER,
	CORNFLOWER_FLOWER,
	DAISY_FLOWER,
	DANDELION_FLOWER,
	DANDELION_OLD_FLOWER,
	FIELD_POPPY_FLOWER,
	LAVENDER_FLOWER,
	ROSE_FLOWER,
	SUNFLOWER_FLOWER,
	TULIP_FLOWER,
	VIOLET_FLOWER,
]
