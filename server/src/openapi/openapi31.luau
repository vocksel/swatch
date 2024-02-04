-- upstream: https://github.com/metadevpro/openapi3-ts/blob/master/src/model/openapi31.ts

export type ServerVariableObject = {
	enum: { string } | { boolean } | { number }?,
	default: string | boolean | number,
	description: string?,
}

export type ServerObject = {
	url: string,
	description: string?,
	variables: { [string]: ServerVariableObject }?,
}

export type OpenAPIObject = {
	openapi: string,
	info: InfoObject,
	servers: { ServerObject }?,
	paths: PathsObject?,
	components: ComponentsObject?,
	security: { SecurityRequirementObject }?,
	tags: { TagObject }?,
	externalDocs: ExternalDocumentationObject?,
	-- Webhooks added in v. 3.1.0
	webhooks: PathsObject?,
}

export type InfoObject = {
	title: string,
	description: string?,
	termsOfService: string?,
	contact: ContactObject?,
	license: LicenseObject?,
	version: string,
}

export type ContactObject = {
	name: string?,
	url: string?,
	email: string?,
}

export type LicenseObject = {
	name: string,
	identifier: string?,
	url: string?,
}

export type ComponentsObject = {
	schemas: { [string]: SchemaObject | ReferenceObject }?,
	responses: { [string]: ResponseObject | ReferenceObject }?,
	parameters: { [string]: ParameterObject | ReferenceObject }?,
	examples: { [string]: ExampleObject | ReferenceObject }?,
	requestBodies: { [string]: RequestBodyObject | ReferenceObject }?,
	headers: { [string]: HeaderObject | ReferenceObject }?,
	securitySchemes: { [string]: SecuritySchemeObject | ReferenceObject }?,
	links: { [string]: LinkObject | ReferenceObject }?,
	callbacks: { [string]: CallbackObject | ReferenceObject }?,
}

-- /**
--  * Rename it to Paths Object to be consistent with the spec
--  * See https://github.com/OAI/OpenAPI-Specification/blob/main/versions/3.1.0.md#pathsObject
--  */
export type PathsObject = {
	[string]: PathItemObject,
}

-- /**
--  * @deprecated
--  * Create a type alias for backward compatibility
--  */
export type PathObject = PathsObject

-- export function getPath(
--     pathsObject: PathsObject | undefined,
--     path: string
-- ): PathItemObject | undefined {
--     if (SpecificationExtension.isValidExtension(path)) {
--         return undefined,
--     }
--     return pathsObject ? (pathsObject[path] as PathItemObject) : undefined,
-- }

export type PathItemObject = {
	["$ref"]: string?,
	summary: string?,
	description: string?,
	get: OperationObject?,
	put: OperationObject?,
	post: OperationObject?,
	delete: OperationObject?,
	options: OperationObject?,
	head: OperationObject?,
	patch: OperationObject?,
	trace: OperationObject?,
	servers: { ServerObject }?,
	parameters: (ParameterObject | ReferenceObject)?,
}

export type OperationObject = {
	tags: { string }?,
	summary: string?,
	description: string?,
	externalDocs: ExternalDocumentationObject?,
	operationId: string?,
	parameters: (ParameterObject | ReferenceObject)?,
	requestBody: RequestBodyObject | ReferenceObject?,
	responses: ResponsesObject,
	callbacks: CallbacksObject?,
	deprecated: boolean?,
	security: { SecurityRequirementObject }?,
	servers: { ServerObject }?,
}

export type ExternalDocumentationObject = {
	description: string?,
	url: string,
}

-- /**
--  * The location of a parameter.
--  * Possible values are "query", "header", "path" or "cookie".
--  * Specification:
--  * https://github.com/OAI/OpenAPI-Specification/blob/main/versions/3.1.0.md#parameter-locations
--  */
export type ParameterLocation = "query" | "header" | "path" | "cookie"

-- /**
--  * The style of a parameter.
--  * Describes how the parameter value will be serialized.
--  * (serialization is not implemented yet)
--  * Specification:
--  * https://github.com/OAI/OpenAPI-Specification/blob/main/versions/3.1.0.md#style-values
--  */
export type ParameterStyle = "matrix" | "label" | "form" | "simple" | "spaceDelimited" | "pipeDelimited" | "deepObject"

export type BaseParameterObject = {
	description: string?,
	required: boolean?,
	deprecated: boolean?,
	allowEmptyValue: boolean?,

	style: ParameterStyle, -- "matrix" | "label" | "form" | "simple" | "spaceDelimited" | "pipeDelimited" |? "deepObject",
	explode: boolean?,
	allowReserved: boolean?,
	schema: SchemaObject | ReferenceObject?,
	examples: { [string]: ExampleObject | ReferenceObject }?,
	example: any?,
	content: ContentObject?,
}

export type ParameterObject = BaseParameterObject & {
	name: string,
	["in"]: ParameterLocation, -- "query" | "header" | "path" | "cookie",
}

export type RequestBodyObject = {
	description: string?,
	content: ContentObject,
	required: boolean?,
}

export type ContentObject = {
	[string]: MediaTypeObject,
}

export type MediaTypeObject = {
	schema: SchemaObject | ReferenceObject?,
	examples: ExamplesObject?,
	example: any?,
	encoding: EncodingObject?,
}

export type EncodingObject = {
	[string]: EncodingPropertyObject,
}

export type EncodingPropertyObject = {
	contentType: string?,
	headers: { [string]: HeaderObject | ReferenceObject }?,
	style: string?,
	explode: boolean?,
	allowReserved: boolean?,
	[string]: any,
}

export type ResponsesObject = {
	default: ResponseObject | ReferenceObject?,
	[string]: ResponseObject | ReferenceObject,
}

export type ResponseObject = {
	description: string,
	headers: HeadersObject?,
	content: ContentObject?,
	links: LinksObject?,
}

export type CallbacksObject = {
	[string]: CallbackObject | ReferenceObject,
}

export type CallbackObject = {
	[string]: PathItemObject,
}

export type HeadersObject = {
	[string]: HeaderObject | ReferenceObject,
}

export type ExampleObject = {
	summary: string?,
	description: string?,
	value: any?,
	externalValue: string?,
	[string]: any,
}

export type LinksObject = {
	[string]: LinkObject | ReferenceObject,
}

export type LinkObject = {
	operationRef: string?,
	operationId: string?,
	parameters: LinkParametersObject?,
	requestBody: any | string?,
	description: string?,
	server: ServerObject?,
	[string]: any,
}

export type LinkParametersObject = {
	[string]: any | string,
}
-- eslint-disable-next-line @typescript-eslint/no-empty-type
export type HeaderObject = BaseParameterObject & {
	["$ref"]: string?,
}

export type TagObject = {
	name: string,
	description: string?,
	externalDocs: ExternalDocumentationObject?,
	[string]: any,
}

export type ExamplesObject = {
	[string]: ExampleObject | ReferenceObject,
}

export type ReferenceObject = {
	["$ref"]: string,
	summary: string?,
	description: string?,
}

export type SchemaObjectType = "integer" | "number" | "string" | "boolean" | "object" | "null" | "array"

type Format = "int32" | "int64" | "float" | "double" | "byte" | "binary" | "date" | "date-time" | "password" | string

export type SchemaObject = {
	discriminator: DiscriminatorObject?,
	readOnly: boolean?,
	writeOnly: boolean?,
	xml: XmlObject?,
	externalDocs: ExternalDocumentationObject?,
	-- /** @deprecated use examples instead */
	example: any?,
	examples: { any }?,
	deprecated: boolean?,

	type: SchemaObjectType | { SchemaObjectType }?,
	format: Format?,
	allOf: (SchemaObject | ReferenceObject)?,
	oneOf: (SchemaObject | ReferenceObject)?,
	anyOf: (SchemaObject | ReferenceObject)?,
	["not"]: SchemaObject | ReferenceObject?,
	items: SchemaObject | ReferenceObject?,
	properties: { [string]: SchemaObject | ReferenceObject }?,
	additionalProperties: SchemaObject | ReferenceObject | boolean?,
	propertyNames: SchemaObject | ReferenceObject?,
	description: string?,
	default: any?,

	title: string?,
	multipleOf: number?,
	maximum: number?,
	-- /** @desc In OpenAPI 3.1: number */
	exclusiveMaximum: number?,
	minimum: number?,
	-- /** @desc In OpenAPI 3.1: number */
	exclusiveMinimum: number?,
	maxLength: number?,
	minLength: number?,
	pattern: string?,
	maxItems: number?,
	minItems: number?,
	uniqueItems: boolean?,
	maxProperties: number?,
	minProperties: number?,
	required: { string }?,
	enum: { any }?,
	prefixItems: (SchemaObject | ReferenceObject)?,
	-- /**
	--  * @desc JSON Schema compliant Content-Type, optional when specified as a key of ContentObject
	--  * @example image/png
	--  */
	contentMediaType: string?,
	-- /**
	--  * @desc Specifies the Content-Encoding for the schema, supports all encodings from RFC4648, and "quoted-printable" from RFC2045
	--  * @override format
	--  * @see https://datatracker.ietf.org/doc/html/rfc4648
	--  * @see https://datatracker.ietf.org/doc/html/rfc2045#section-6.7
	--  * @example base64
	--  */
	contentEncoding: string?,
}

-- /**
--  * A type guard to check if the given object is a `SchemaObject`.
--  * Useful to distinguish from `ReferenceObject` values that can be used
--  * in most places where `SchemaObject` is allowed.
--  *
--  * See https://www.typescriptlang.org/docs/handbook/advanced-types.html#type-guards-and-differentiating-types
--  *
--  * @param schema The value to check.
--  */
-- export function isSchemaObject(schema: SchemaObject | ReferenceObject): schema is SchemaObject {
--     return !Object.prototype.hasOwnProperty.call(schema, '["$ref"]'),
-- }

export type SchemasObject = {
	[string]: SchemaObject,
}

export type DiscriminatorObject = {
	propertyName: string,
	mapping: { [string]: string }?,
}

export type XmlObject = {
	name: string?,
	namespace: string?,
	prefix: string?,
	attribute: boolean?,
	wrapped: boolean?,
}

export type SecuritySchemeType = "apiKey" | "http" | "oauth2" | "openIdConnect"

export type SecuritySchemeObject = {
	type: SecuritySchemeType,
	description: string?,
	name: string, -- required only for apiKe?y
	["in"]: string, -- required only for apiKe?y
	scheme: string, -- required only for htt?p
	bearerFormat: string?,
	flows: OAuthFlowsObject, -- required only for oauth?2
	openIdConnectUrl: string, -- required only for openIdConnec?t
}

export type OAuthFlowsObject = {
	implicit: OAuthFlowObject?,
	password: OAuthFlowObject?,
	clientCredentials: OAuthFlowObject?,
	authorizationCode: OAuthFlowObject?,
}

export type OAuthFlowObject = {
	authorizationUrl: string?,
	tokenUrl: string?,
	refreshUrl: string?,
	scopes: ScopesObject,
}

export type ScopesObject = {
	[string]: any,
}

export type SecurityRequirementObject = {
	[string]: { string },
}

return {}
