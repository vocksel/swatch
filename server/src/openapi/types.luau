export type Object<T> = { [string]: T }

type Primitive = string | number | boolean

export type LuauType = {
	name: string,
	body: Primitive | { [string]: Primitive },
	comment: string?,
	unions: { string }?,
	isExported: boolean?,
	isRequired: boolean?,
}

return {}
