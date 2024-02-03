-- upstream: https://swagger.io/specification

export type Parameter = {
	["in"]: string,
	name: string,
	required: boolean,
	format: string,
	schema: Schema,
}

export type Response = {}

export type Reference = {}

export type Operation = {}

export type Components = {
	schemas: {
		[string]: Schema,
	},
	responses: {
		[string]: Response | Reference,
	},
}

export type Path = {
	parameters: { Parameter },
	responses: {
		[string]: Response,
	},
}

export type Schema = {
	summary: string,
	["type"]: string,
	properties: {
		[string]: {
			["type"]: string,
		},
	},
}

export type OpenAPI = {
	paths: {
		[string]: Path,
	},
	components: {
		schemas: {
			[string]: Schema,
		},
	},
}

return nil
