/* plx 2.1.0 -> 3.0.0: adds the plxcsharp and plxlua languages.
 *
 * 3.0.0 is a major release for behaviour changes in the loadable module
 * ($libdir/plx), which apply when a function is created or replaced:
 * finally/ensure runs on return, break and continue, and an interpolated value
 * in a SQL argument is bound rather than spliced into the SQL (see the 3.0.0
 * entry in CHANGELOG.md and doc/DYNAMIC-SQL.md). Functions already in the
 * catalog keep the plpgsql they were generated with. */

\echo Use "ALTER EXTENSION plx UPDATE TO '3.0.0'" to load this file. \quit

/* C# dialect validator + inline handler live in plx.so */
CREATE FUNCTION plx_csharp_validator(oid)
	RETURNS void
	AS '$libdir/plx', 'plx_csharp_validator'
	LANGUAGE C STRICT;

CREATE FUNCTION plx_csharp_inline_handler(internal)
	RETURNS void
	AS '$libdir/plx', 'plx_csharp_inline_handler'
	LANGUAGE C;

CREATE TRUSTED LANGUAGE plxcsharp
	HANDLER plx_call_handler
	INLINE plx_csharp_inline_handler
	VALIDATOR plx_csharp_validator;

COMMENT ON LANGUAGE plxcsharp IS 'plx C# dialect (transpiles to plpgsql)';

/* Lua dialect validator + inline handler live in plx.so */
CREATE FUNCTION plx_lua_validator(oid)
	RETURNS void
	AS '$libdir/plx', 'plx_lua_validator'
	LANGUAGE C STRICT;

CREATE FUNCTION plx_lua_inline_handler(internal)
	RETURNS void
	AS '$libdir/plx', 'plx_lua_inline_handler'
	LANGUAGE C;

CREATE TRUSTED LANGUAGE plxlua
	HANDLER plx_call_handler
	INLINE plx_lua_inline_handler
	VALIDATOR plx_lua_validator;

COMMENT ON LANGUAGE plxlua IS 'plx Lua dialect (transpiles to plpgsql)';
